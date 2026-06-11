#' Convert pedigree data to Graphviz DOT format
#'
#' @param pedfile A data frame with at least 6 columns:
#'   pedigree id, individual id, father id, mother id, sex, affection.
#'
#' | Column | Description |
#' |----------|----------------|
#' | 1 | Pedigree identifier |
#' | 2 | Individual identifier |
#' | 3 | Father identifier |
#' | 4 | Mother identifier |
#' | 5 | Sex (`1`/`f`, `2`/`m`, `0`/`u`) |
#' | 6 | Affection status (`0`, `1`, `2`, `x`, `n`, `y`) |
#'
#' @param makeped logical: TRUE if pedigree is post-makeped format.
#' @param node.height node height.
#' @param node.width node width.
#'
#' @details
#' Converts GAS/LINKAGE pedigree data into Graphviz DOT format.
#' Each pedigree is written as a separate directed graph.
#'
#' Typical rendering:
#' ```
#' dot -Tpdf file.dot -o file.pdf
#' neato -Tpdf file.dot -o file.pdf
#' ```
#' @section S3 methods:
#' The following S3 methods are available for `pedtodot` objects:
#'
#' - `plot.pedtodot()` renders an interactive DiagrammeR view
#' - `print.pedtodot()` displays the DOT representation
#' - `output.pedtodot()` writes DOT files to disk
#' - `export.pedtodot()` renders via Graphviz engines (dot, neato, etc.)
#'
#' @return A list of DOT character vectors (S3 class `pedtodot`),
#' one per pedigree. DOT is treated as the canonical representation.
#'
#' @seealso DiagrammeR, Rgraphviz
#'
#' @examples
#' \dontrun{
#' # example as in R News and Bioinformatics (see also plot.pedigree in package kinship)
#' # it works from screen paste only
#' p1 <- scan(nlines=16,what=list(0,0,0,0,0,"",""))
#'  1   2   3  2  2  7/7  7/10
#'  2   0   0  1  1  -/-  -/-
#'  3   0   0  2  2  7/9  3/10
#'  4   2   3  2  2  7/9  3/7
#'  5   2   3  2  1  7/7  7/10
#'  6   2   3  1  1  7/7  7/10
#'  7   2   3  2  1  7/7  7/10
#'  8   0   0  1  1  -/-  -/-
#'  9   8   4  1  1  7/9  3/10
#' 10   0   0  2  1  -/-  -/-
#' 11   2  10  2  1  7/7  7/7
#' 12   2  10  2  2  6/7  7/7
#' 13   0   0  1  1  -/-  -/-
#' 14  13  11  1  1  7/8  7/8
#' 15   0   0  1  1  -/-  -/-
#' 16  15  12  2  1  6/6  7/7
#'
#' p2 <- as.data.frame(p1)
#' names(p2) <-c("id","fid","mid","sex","aff","GABRB1","D4S1645")
#' p3 <- data.frame(pid=10081,p2)
#' attach(p3)
#' pedtodot(p3)
#' #
#' # Three examples of pedigree-drawing
#' # pre-MakePed LINKAGE file in which IDs are characters
#' pre <- read.table("me.pre",as.is=TRUE)[,1:6]
#' dot <- pedtodot(pre)
#' # post-MakePed LINKAGE file in which IDs are integers
#' ped <- read.table("me.ped")[,1:10]
#' dot <- pedtodot(ped,makeped=TRUE)
#' output(dot,file="me.dot")
#' plot(dot)
#' export(dot, "ped.pdf", engine="dot")
#' # An example from Richard Mott
#' pre <- read.table("ped.1.3.txt",as.is=TRUE,
#'                   col.names=c("id", "fid", "mid", "sex", "aff"))
#' pre <- data.frame(pid=1,pre)
#' pre[is.na(pre)] <- 0
#' pre[pre == "UnknownFather5"] <- 0
#' gap::pedtodot(pre,dir="forward")
#' dot <- pedtodot(pre)
#' export(dot,file="1.pdf")
#' }
#'
#' @author David Duffy, Jing Hua Zhao
#' @export
# ============================================================
#'
pedtodot <- function(pedfile,
                     makeped = FALSE,
                     node.height = 0.5,
                     node.width = 0.75)
{
  if (!is.data.frame(pedfile)) stop("pedfile must be a data.frame")
  `%||%` <- function(a, b) if (is.null(a) || length(a) == 0 || all(is.na(a))) b else a
  sep <- "\034"
  shape <- c(f = "box", `1` = "box", m = "circle", `2` = "circle", u = "diamond", `0` = "diamond")
  shade <- c(y = "grey",`2` = "grey",n = "white", `1` = "white", x = "white", `0` = "white")
  if (makeped) ped <- pedfile[,-c(5,6,7,9)]
  else ped <- pedfile
  build <- function(pid, ped)
  {
    sex <- aff <- character()
    marriage <- list()
    child <- list()
    for (i in seq_len(nrow(ped)))
    {
      id  <- as.character(ped[i,2])
      dad <- as.character(ped[i,3])
      mom <- as.character(ped[i,4])
      sx  <- as.character(ped[i,5])
      af  <- as.character(ped[i,6])
      sex[id] <- if (sx %in% names(shape)) sx else "u"
      aff[id] <- if (af %in% names(shade)) af else "x"
      if (!is.na(dad) && !is.na(mom) &&
          !dad %in% c("0","x",".","") &&
          !mom %in% c("0","x",".",""))
      {
        key <- paste(dad, mom, sep = sep)
        marriage[[key]] <- (marriage[[key]] %||% 0L) + 1L
        child[[paste(key, marriage[[key]], sep = sep)]] <- id
      }
    }
    ids <- sort(unique(names(sex)))
    pairs <- sort(names(marriage))
    dot <- c(
      sprintf("digraph Ped_%s {", pid),
      "graph [rankdir=TB, splines=true, overlap=false, nodesep=0.35, ranksep=0.7];",
      "node [fontname=Helvetica, fontsize=10];",
      sprintf("label=\"Pedigree %s\";", pid)
    )
    for (id in ids)
    {
      sx <- sex[id] %||% "u"
      af <- aff[id] %||% "x"
      dot <- c(dot,
        sprintf("\"%s\" [shape=%s, style=filled, fillcolor=%s, height=%s, width=%s];",
                id,
                shape[[sx]] %||% "ellipse",
                shade[[af]] %||% "white",
                node.height, node.width)
      )
    }
    for (p in pairs)
    {
      par <- strsplit(p, sep, fixed=TRUE)[[1]]
      dad <- par[1]; mom <- par[2]
      fam <- paste0("fam_", dad, "_", mom)
      dot <- c(dot, sprintf("\"%s\" [shape=point, width=0.03, label=\"\"];", fam))
      dot <- c(dot,
        sprintf("\"%s\" -> \"%s\" [dir=none, weight=1];", dad, fam),
        sprintf("\"%s\" -> \"%s\" [dir=none, weight=1];", mom, fam)
      )
      n <- marriage[[p]] %||% 0L
      for (k in seq_len(n))
      {
        kid <- child[[paste(p, k, sep=sep)]]
        dot <- c(dot,
          sprintf("\"%s\" -> \"%s\" [dir=none, weight=1];", fam, kid)
        )
      }
    }
    c(dot, "}")
  }
  ids <- unique(ped[[1]])
  out <- lapply(ids, function(pid)
    build(pid, ped[ped[[1]] == pid, , drop=FALSE])
  )
  names(out) <- ids
  class(out) <- "pedtodot"
  out
}

#' @export
print.pedtodot <- function(x, id = names(x)[1], ...)
{
  cat("<pedtodot>\n")
  cat("pedigree:", id, "\n\n")
  cat(x[[id]], sep = "\n")
  invisible(x)
}

#' @export
output.pedtodot <- function(x, id = names(x)[1], file = NULL) {
  if (is.null(file)) file <- paste0(id, ".dot")
  writeLines(x[[id]], file)
  invisible(file)
}

output <- function(x, ...) UseMethod("output")

#' Plot pedigree using DiagrammeR
#' @export
plot.pedtodot <- function(x, id = names(x)[1], engine = c("dot", "neato", "fdp"), ...)
{
  engine <- match.arg(engine)
  if (!requireNamespace("DiagrammeR", quietly = TRUE)) {
    stop("Package 'DiagrammeR' required for plotting.")
  }
  dot <- x[[id]]
  if (engine != "dot") {
    dot <- sub(
      "digraph [^\\{]*\\{",
      paste0("digraph { graph [layout=", engine, "];"),
      dot
    )
  }
  DiagrammeR::grViz(paste(dot, collapse = "\n"))
}

#' Export a pedigree diagram via Graphviz
#'
#' Export a pedigree stored in a `pedtodot` object to any format
#' supported by Graphviz (e.g. PDF, PNG, SVG, PostScript).
#'
#' The selected pedigree is first written to a temporary DOT file and
#' then rendered using the chosen Graphviz layout engine.
#'
#' @param x An object returned by [pedtodot()].
#' @param file Output filename. The output format is inferred from the
#'   file extension.
#' @param id Pedigree identifier. Defaults to the first pedigree in `x`.
#' @param engine Graphviz layout engine. One of `"dot"`, `"neato"`,
#'   `"fdp"`, `"sfdp"`, `"circo"` or `"twopi"`.
#'
#' @return Invisibly returns `file`.
#'
#' @details
#' Graphviz supports multiple rendering engines. For pedigree diagrams,
#' `dot` usually gives the most traditional hierarchical layout, whereas
#' `neato` and `fdp` may produce more compact force-directed layouts.
#'
#' The output format is determined from the extension of `file`, for
#' example:
#'
#' * `.pdf` — Portable Document Format
#' * `.png` — Portable Network Graphics
#' * `.svg` — Scalable Vector Graphics
#' * `.ps` — PostScript
#'
#' Graphviz must be installed and available on the system path.
#'
#' @examples
#' \dontrun{
#' pd <- pedtodot(ped)
#'
#' # export first pedigree
#' export(pd, "pedigree.pdf")
#'
#' # export a specific pedigree
#' export(pd, "10081.pdf", id = "10081")
#'
#' # alternative layout engine
#' export(pd, "10081.svg", id = "10081", engine = "neato")
#'
#' # All pedigrees
#' for(id in names(pd)) export(pd, paste0(id, ".pdf"), id = id)
#' }
#'
#' @seealso [pedtodot()], [output.pedtodot()], [plot.pedtodot()]
#'
#' @export
#'
export.pedtodot <- function(x, file, id = names(x)[1],
    engine = c("dot","neato","fdp","sfdp","circo","twopi")
)
{
    engine <- match.arg(engine)
    fmt <- tools::file_ext(file)
    tmp <- tempfile(fileext = ".dot")
    writeLines(x[[id]], tmp)
    system2(engine, c(paste0("-T", fmt), tmp, "-o", file))
    invisible(file)
}

export <- function(x, ...)
  UseMethod("export")
