#' A call to expressionSet class
#'
#' This is really a direct call to the Bioconductor/Biobase class.
#'
#' @param assayData Expression data.
#' @param phenoData Phenotype.
#' @param featureData featureData.
#' @param experimentData Information on data source.
#' @param annotation Annotation information.
#' @param protocolData protocol information.
#' @param ... Other options.
#'
#' @details
#' The explicit call make it easier to handle proteomic data for other downstream analyses.
#'
#' @export
#' @return
#' An ExpressionSet object.
#'
#' @examples
#' dataDirectory <- system.file("extdata", package="Biobase")
#' exprsFile <- file.path(dataDirectory, "exprsData.txt")
#' exprs <- as.matrix(read.table(exprsFile, header=TRUE, sep="\t", row.names=1, as.is=TRUE))
#' pDataFile <- file.path(dataDirectory, "pData.txt")
#' pData <- read.table(pDataFile, row.names=1, header=TRUE, sep="\t")
#' all(rownames(pData)==colnames(exprs))
#' metadata <- data.frame(labelDescription=
#'                        c("Patient gender",
#'                          "Case/control status",
#'                          "Tumor progress on XYZ scale"),
#'                        row.names=c("gender", "type", "score"))
#' suppressMessages(library(Biobase))
#' phenoData <- Biobase::AnnotatedDataFrame(data=pData, varMetadata=metadata)
#' experimentData <- Biobase::MIAME(
#'     name="Pierre Fermat",
#'     lab="Francis Galton Lab",
#'     contact="pfermat@lab.not.exist",
#'     title="Smoking-Cancer Experiment",
#'     abstract="An example ExpressionSet",
#'     url="www.lab.not.exist",
#'     other=list(notes="Created from text files"))
#' exampleSet <- pQTLtools::make_ExpressionSet(exprs,phenoData,
#'                                  experimentData=experimentData,
#'                                  annotation="hgu95av2")
#' data(sample.ExpressionSet, package="Biobase")
#' identical(exampleSet,sample.ExpressionSet)
#' invisible(Biobase::esApply(exampleSet,2,hist))
#' lm(score~gender+X31739_at,data=exampleSet)
#'
#' @note
#' Adapted from Bioconductor/Biobase following a number of proteomic pilot studies.
#' @keywords utilities

make_ExpressionSet <- function(assayData,
                      phenoData=Biobase::annotatedDataFrameFrom(assayData, byrow=FALSE),
                      featureData=Biobase::annotatedDataFrameFrom(assayData, byrow=TRUE),
                      experimentData=Biobase::MIAME(),
                      annotation=character(),
                      protocolData=Biobase::annotatedDataFrameFrom(assayData, byrow=FALSE),...)
{
  Biobase::ExpressionSet(assayData,phenoData=phenoData,
                         featureData=featureData,
                         experimentData=experimentData,
                         annotation=annotation,
                         protocolData=protocolData,...)
}

#' Limit of detection analysis
#'
#' The function obtains lower limit of detection as in proteomic analysis.
#'
#' @param eset An ExpressionSet object.
#' @param flagged A flag is an indicator for sample exclusion.
#' @export
#' @return An updated ExpressionSet object.
#' @examples
#' suppressMessages(library(Biobase))
#' data(sample.ExpressionSet, package="Biobase")
#' exampleSet <- sample.ExpressionSet
#' Biobase::fData(exampleSet)
#' Biobase::fData(exampleSet)$lod.max <-
#'     apply(Biobase::exprs(exampleSet),1,quantile,runif(nrow(exampleSet)))
#' lod <- get.prop.below.LLOD(exampleSet)
#' x <- dplyr::arrange(fData(lod),desc(pc.belowLOD.new))
#' knitr::kable(head(lod))
#' plot(x[,2], main="Random quantile cut off", ylab="<lod%")
#' @author James Peters

get.prop.below.LLOD <- function(eset,
                                flagged = c("OUT", "IN")) {

    flagged <- match.arg(flagged)

    if (!inherits(eset, "ExpressionSet")) {
        stop("'eset' must inherit from ExpressionSet")
    }

    if (flagged == "OUT") {
        ind_fl <- which(eset$Flagged == "Flagged")

        if (length(ind_fl)) {
            eset <- eset[, -ind_fl]
        }
    }

    expr_matrix <- t(Biobase::exprs(eset))
    feature_data <- Biobase::fData(eset)

    feature_data$pc.belowLOD.new <-
        100 *
        base::colSums(expr_matrix <= feature_data$lod.max,
                      na.rm = TRUE) /
        base::colSums(!is.na(expr_matrix))

    Biobase::fData(eset) <- feature_data

    eset
}
