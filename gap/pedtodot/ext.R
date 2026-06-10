# ============================================================
#' Pedigree → Graphviz DOT (S3 lightweight implementation)
#'
#' Convert GAS/LINKAGE pedigree data into Graphviz DOT format
#' and optionally render or export diagrams.
#'
#' This is a compact, self-contained R implementation inspired by
#' the original `pedtodot` awk script by David Duffy. It preserves
#' the core algorithm: individuals + explicit mating nodes + offspring edges.
#'
#' The output is a list of DOT character vectors (S3 class `ped_dot`),
#' one per pedigree. DOT is treated as the canonical representation.
#'
#' @param f A data frame with at least 6 columns:
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
#' @return An object of class `ped_dot` (list of DOT character vectors).
#'
#' @examples
#' dot <- pedtodot(ped)
#' plot(dot)
#' ped_export(dot, "ped.pdf")
#'
#' @export
#'
pedtodot <- function(f)
{
  stopifnot(is.data.frame(f), ncol(f) >= 6)
  sep <- "\034"
  `%||%` <- function(a, b)
    if (is.null(a) || length(a) == 0 || all(is.na(a))) b else a
  shape <- c(
    f = "box", `1` = "box",
    m = "circle", `2` = "circle",
    u = "diamond", `0` = "diamond"
  )
  shade <- c(
    y = "grey",
    `2` = "grey",
    n = "white",
    `1` = "white",
    x = "white",
    `0` = "white"
  )
  build <- function(pid, ped)
  {
    sex <- aff <- character()
    marriage <- list()
    child <- list()
    # -------------------------
    # PARSE
    # -------------------------
    for (i in seq_len(nrow(ped)))
    {
      id  <- as.character(ped[i,2])
      dad <- as.character(ped[i,3])
      mom <- as.character(ped[i,4])
      sx  <- as.character(ped[i,5])
      st  <- as.character(ped[i,6])
      sex[id] <- sx
      aff[id] <- if (!is.na(st) && grepl("^[012nyx]$", st)) st else "x"
      if (!is.na(dad) && !is.na(mom) &&
          !dad %in% c("0","x",".","") &&
          !mom %in% c("0","x",".",""))
      {
        p <- paste(dad, mom, sep = sep)
        marriage[[p]] <- (marriage[[p]] %||% 0L) + 1L
        child[[paste(p, marriage[[p]], sep = sep)]] <- id
      }
    }
    ids <- sort(unique(names(sex)))
    pairs <- sort(names(marriage))
    # -------------------------
    # HEADER (IMPORTANT CHANGE HERE)
    # -------------------------
    dot <- c(
      sprintf("digraph Ped_%s {", pid),
      "graph [",
      "rankdir=TB,",
      "splines=true,",        # ✔️ CURVED EDGES (NOT ORTHO)
      "overlap=false,",
      "nodesep=0.35,",
      "ranksep=0.7",
      "];",
      "node [fontname=Helvetica, fontsize=10];",
      sprintf("label=\"Pedigree %s\";", pid)
    )
    # -------------------------
    # NODES
    # -------------------------
    for (id in ids)
    {
      sx <- sex[id] %||% "u"
      af <- aff[id] %||% "x"
      dot <- c(dot,
        sprintf("\"%s\" [shape=%s, style=filled, fillcolor=%s];",
                id,
                shape[[sx]] %||% "ellipse",
                shade[[af]] %||% "white")
      )
    }
    # -------------------------
    # FAMILY STRUCTURE (NO RECTANGULAR FORCE)
    # -------------------------
    for (p in pairs)
    {
      par <- strsplit(p, sep, fixed=TRUE)[[1]]
      dad <- par[1]
      mom <- par[2]
      fam <- paste0("fam_", dad, "_", mom)
      # marriage node (small point)
      dot <- c(dot,
        sprintf("\"%s\" [shape=point, width=0.04, label=\"\"];", fam)
      )
      # parents → marriage node (SOFT CONSTRAINT)
      dot <- c(dot,
        sprintf("\"%s\" -> \"%s\" [dir=none, weight=1];", dad, fam),
        sprintf("\"%s\" -> \"%s\" [dir=none, weight=1];", mom, fam)
      )
      n <- marriage[[p]] %||% 0L
      # children edges (also soft)
      for (k in seq_len(n))
      {
        kid <- child[[paste(p, k, sep = sep)]]
        dot <- c(dot,
          sprintf("\"%s\" -> \"%s\" [dir=none, weight=1.2];", fam, kid)
        )
      }
    }
    c(dot, "}")
  }
  ids <- unique(f[[1]])
  res <- lapply(ids, function(pid) {
    build(pid, f[f[[1]] == pid, , drop = FALSE])
  })
  names(res) <- ids
  class(res) <- "pedtodot"
  res
}

#' Optional helper: write DOT
#'
#' @export
#'
write_pedtodot <- function(x, id = names(x)[1], file = NULL)
{
  if (is.null(file)) file <- paste0(id, ".dot")
  writeLines(x[[id]], file)
  invisible(file)
}

#' Plot pedigree using DiagrammeR
#'
#' @export
#'
plot.pedtodot <- function(x, id = names(x)[1], ...)
{
  if (!requireNamespace("DiagrammeR", quietly=TRUE))
    stop("Install DiagrammeR to view graphs in a browser")
  DiagrammeR::grViz(paste(x[[id]], collapse="\n"))
}

#' Export DOT to Graphviz formats
#'
#' @export
#'
ped_export <- function(x, file,
                       engine=c("dot","neato","fdp","sfdp","circo","twopi"))
{
  engine <- match.arg(engine)
  fmt <- tools::file_ext(file)
  tmp <- tempfile(fileext=".dot")
  writeLines(x[[1]], tmp)
  system2(engine, c(paste0("-T", fmt), tmp, "-o", file))
  invisible(file)
}
