#' 2D QTL cis/trans visualization (Plotly)
#'
#' Interactive visualization of QTL–gene relationships in 2D genomic space,
#' separating cis and trans associations into stable Plotly traces.
#'
#' This function wraps `gap::qtl2dplot()` and converts its output into an
#' interactive Plotly scatter plot.
#'
#' Compared with earlier implementations, this version:
#'
#' - avoids `color = ~cistrans`, preventing silent row dropping in Plotly
#' - uses explicit grouping based on observed values (not factor levels)
#' - ensures stable HTML widget rendering in RStudio and static HTML (e.g. GitHub Pages)
#' - prevents "Ignoring observations" warnings from Plotly
#'
#' @param d Data frame in `gap::qtl2dplot()` format containing QTL and gene
#' annotations, including cis/trans classification.
#' @param chrlen Chromosome length reference (e.g. `gap::hg19`).
#' @param qtl.id Prefix for SNP identifier in hover text.
#' @param qtl.prefix Prefix for QTL genomic coordinate labels.
#' @param qtl.gene Prefix for gene coordinate labels.
#' @param target.type Label for target entity type (e.g. "Protein").
#' @param TSS Logical; if `TRUE`, uses transcription start site.
#' @param xlab Label for x-axis.
#' @param ylab Label for y-axis.
#' @param ... Additional arguments passed to `gap::qtl2dplot()`.
#'
#' @return A `plotly` object.
#'
#' @examples
#' \dontrun{
#' INF <- Sys.getenv("INF")
#' d <- read.csv(file.path(INF, "work", "INF1.merge.cis.vs.trans"), as.is = TRUE)
#' r <- qtl2dplotly(d)
#' htmlwidgets::saveWidget(r, file = "INF1.qtl2dplotly.html", selfcontained = TRUE)
#' r
#' }
#'
#' @export
qtl2dplotly <- function(
    d,
    chrlen = gap::hg19,
    qtl.id = "SNPid:",
    qtl.prefix = "QTL:",
    qtl.gene = "Gene:",
    target.type = "Protein",
    TSS = FALSE,
    xlab = "QTL position",
    ylab = "Gene position",
    ...
) {

    t2d <- qtl2dplot(
        d,
        chrlen,
        TSS = TSS,
        plot = FALSE,
        ...
    )

    names(t2d$data)[names(t2d$data) == "id"] <- "t2d_id"
    t2d_pos <- t2d$data

    t2d_pos$snpid <- paste(qtl.id, t2d_pos$t2d_id)

    t2d_pos$pos_qtl <- paste0(qtl.prefix, t2d_pos$chr1, ":", t2d_pos$pos1)
    t2d_pos$pos_gene <- paste0(qtl.gene, t2d_pos$chr2, ":", t2d_pos$pos2)

    t2d_pos$target_gene <- paste0(
        target.type,
        " (gene): ",
        t2d_pos$target,
        " (",
        t2d_pos$gene,
        ")"
    )

    t2d_pos$lp <- paste("value:", t2d_pos$value)

    t2d_pos$text <- paste(
        t2d_pos$snpid,
        t2d_pos$pos_qtl,
        t2d_pos$pos_gene,
        t2d_pos$target_gene,
        t2d_pos$lp,
        sep = "\n"
    )

    t2d_pos$cistrans <- as.character(t2d_pos$cistrans)

    n <- t2d$n
    CM <- t2d$CM

    tkvals <- numeric(n)
    tktxts <- character(n)

    for (x in seq_len(n)) {
        tkvals[x] <- if (x == 1) {
            CM[x] / 2
        } else {
            (CM[x] + CM[x - 1]) / 2
        }
        tktxts[x] <- as.character(x)
    }

    axes <- list(
        tickmode = "array",
        tickvals = tkvals,
        ticktext = tktxts
    )

    xaxis <- c(title = xlab, axes)
    yaxis <- c(title = ylab, axes)

    cols <- c("cis" = "#BF382A", "trans" = "#0C4B8E")

    fig <- plotly::plot_ly()

    for (lvl in unique(t2d_pos$cistrans)) {

        df <- t2d_pos[t2d_pos$cistrans == lvl, , drop = FALSE]
        if (nrow(df) == 0) next

        fig <- fig %>%
            plotly::add_trace(
                data = df,
                x = ~x,
                y = ~y,
                type = "scatter",
                mode = "markers",
                name = lvl,
                text = ~text,
                hoverinfo = "text",
                marker = list(
                    size = 11,
                    color = cols[[lvl]]
                )
            )
    }

    fig %>%
        plotly::layout(
            xaxis = xaxis,
            yaxis = yaxis,
            showlegend = TRUE
        )
}
