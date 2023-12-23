# Install and load required packages
library(r2d3)

# Define your R2D3 script

# HTML dependencies
htmlDependencies <- htmltools::htmlDependency(
  name = "locuszoom",
  version = "0.14.0",
  src = c(href = "https://cdn.jsdelivr.net/npm/locuszoom@0.14.0/dist/"),
  script = c("locuszoom.app.min.js", "ext/lz-credible-sets.min.js", "ext/lz-dynamic-urls.min.js",
             "ext/lz-intervals-track.min.js", "ext/lz-parsers.min.js", "ext/lz-tabix-source.min.js"),
  stylesheet = "locuszoom.css",
  all_files = FALSE
)

# Create R2D3 script
r2d3_script <- '
  // Your R2D3 script goes here
'

# Render R2D3
r2d3(html = r2d3_script, dependencies = htmlDependencies)
