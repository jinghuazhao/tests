options(width=120)
library(hdf5r)
file <- H5File$new("oxford_segmentation.h5", mode = "r")
content <- file$ls(recursive = TRUE)
datasets <- content[!is.na(content$dataset.rank), ]
print(datasets)
if (nrow(datasets) > 0) {
    path <- datasets$name[1]  # pick the first dataset
    cat("Reading dataset:", path, "\n")
    data_array <- file[[path]][]
    str(data_array)
}
file$close_all()
