#' Create a Relative Log Expression (RLE) Plot
#'
#' Generates a Relative Log Expression (RLE) plot for quality assessment of
#' gene expression data. For each feature (row), the median expression across
#' samples is subtracted, and boxplots of the resulting relative expression
#' values are displayed for each sample.
#'
#' @param E A numeric matrix or data frame with features in rows and samples
#'   in columns.
#' @param log2.data Logical; if `TRUE`, expression values are log2-transformed
#'   before computing RLE values.
#' @param groups Optional factor or vector defining sample groups.
#' @param col.group Optional vector of colours corresponding to the levels of
#'   `groups`.
#' @param showTitle Logical; if `TRUE`, display a plot title.
#' @param title Character string specifying the plot title.
#' @param ... Additional arguments passed to [graphics::boxplot()].
#'
#' @return Invisibly returns the matrix of relative log expression values.
#'
#' @examples
#' \dontrun{
#' par(mfrow = c(2, 1))
#' makeRLEplot(
#'   d,
#'   log2.data = FALSE,
#'   groups = group,
#'   col.group = col.group,
#'   cex = 0.3,
#'   showTitle = TRUE
#' )
#'
#' makeRLEplot(
#'   d,
#'   log2.data = FALSE,
#'   cex = 0.3,
#'   showTitle = TRUE,
#'   title = "Uncoloured relative log expression (RLE) plot"
#' )
#' }
#'
#' @export
#'
makeRLEplot <- function(
    E,
    log2.data = TRUE,
    groups = NULL,
    col.group = NULL,
    showTitle = FALSE,
    title = "Relative log expression (RLE) plot",
    ...
) {

  E <- as.matrix(E)

  if (isTRUE(log2.data)) {
    message("Applying log2 transformation")
    E <- log2(E)
  }

  mycol <- NULL

  if (!is.null(groups)) {

    if (!is.factor(groups)) {
      groups <- factor(groups)
    }

    if (is.null(col.group)) {
      warning("No colours supplied; plotting without group colours.")
    } else if (nlevels(groups) > length(col.group)) {
      warning("More groups than colours; plotting without group colours.")
    } else {
      mycol <- col.group[groups]
    }
  }

  if (requireNamespace("matrixStats", quietly = TRUE)) {
    g.medians <- matrixStats::rowMedians(E, na.rm = TRUE)
  } else {
    g.medians <- apply(E, 1, median, na.rm = TRUE)
  }

  E.rle <- sweep(E, MARGIN = 1, STATS = g.medians, FUN = "-")

  boxplot(E.rle, xaxt = "n", las = 2, col = mycol, ...)

  xtick <- seq_len(ncol(E.rle))
  axis(side = 1, at = xtick, tick = FALSE, labels = FALSE)

  text(
    x = xtick,
    y = par("usr")[3],
    labels = colnames(E.rle),
    srt = 90,
    pos = 1,
    xpd = TRUE,
    col = mycol
  )

  if (isTRUE(showTitle)) {
    mtext(text = title, side = 3, line = 0.1)
  }

  invisible(E.rle)
}
