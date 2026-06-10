#' Converting pedigree(s) to dot file(s)
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
#' @param height node height.
#' @param width node width.
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
#'
#' @return A list of DOT graphs (class `pedtodot`).
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
#' #
#' # Three examples of pedigree-drawing
#' # assuming pre-MakePed LINKAGE file in which IDs are characters
#' pre<-read.table("me.pre",as.is=TRUE)[,1:6]
#' pedtodot(pre)
#' # for post-MakePed LINKAGE file in which IDs are integers
#' ped <-read.table("me.ped")[,1:10]
#' pedtodot(ped,makeped=TRUE)
#' dot <- pedtodot(ped)
#' write_pedtodot(dot)
#' plot(dot)
#' ped_export(dot, "ped.pdf", engine="dot")
#' # more details
#' pedtodot(ped)
#' # An example from Richard Mott and in the demo
#' filespec <- "ped.1.3.txt"
#' pre <- read.table(filespec,as.is=TRUE)
#' pre
#' pedtodot(data.frame(pid=1,pre),dir="forward")
#' }
#'
#' @author David Duffy, Jing Hua Zhao
#' @export
# ============================================================
#'
pedtodot <- function(pedfile,
                     makeped = FALSE,
                     height = 0.5,
                     width = 0.75,
                     dir = "none")
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
      if (is.null(sx) || !(sx %in% names(shape))) sx <- "u"
      if (is.null(af) || !(af %in% names(shade))) af <- "x"
      sh <- shape[[sx]]
      if (is.null(sh)) sh <- "ellipse"
      sd <- shade[[af]]
      if (is.null(sd)) sd <- "white"
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
                height, width)
      )
    }
    for (p in pairs)
    {
      par <- strsplit(p, sep, fixed=TRUE)[[1]]
      dad <- par[1]; mom <- par[2]
      fam <- paste0("fam_", dad, "_", mom)
      # IMPORTANT: small neutral node (no rank forcing)
      dot <- c(dot,
        sprintf("\"%s\" [shape=point, width=0.03, label=\"\"];", fam)
      )
      # relaxed edges (avoid rigid centering artifacts)
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
  ids <- unique(pedfile[[1]])
  out <- lapply(ids, function(pid)
    build(pid, pedfile[pedfile[[1]] == pid, , drop=FALSE])
  )
  names(out) <- ids
  class(out) <- "pedtodot"
  out
}

#' @export
write_pedtodot <- function(x, id = names(x)[1], file = NULL)
{
  if (is.null(file)) file <- paste0(id, ".dot")
  writeLines(x[[id]], file)
  invisible(file)
}

#' @export
plot.pedtodot <- function(x, id = names(x)[1], ...)
{
  if (!requireNamespace("DiagrammeR", quietly=TRUE))
    stop("Install DiagrammeR")

  DiagrammeR::grViz(paste(x[[id]], collapse="\n"))
}

#' @export
ped_export <- function(x, file, engine = c("dot","neato","fdp","sfdp","circo","twopi"))
{
  engine <- match.arg(engine)
  tmp <- tempfile(fileext=".dot")
  writeLines(x[[1]], tmp)

  system2(engine, c(paste0("-T", tools::file_ext(file)), tmp, "-o", file))
  invisible(file)
}
