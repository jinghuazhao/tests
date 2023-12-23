library(htmltools)

dependencies <- list(
  htmlDependency(
    "locuszoom.css", "0.14.0",
    src = c(href = "https://cdn.jsdelivr.net/npm/locuszoom@0.14.0/dist/"),
    stylesheet = "all",
    all_files = FALSE
  ),
  htmlDependency(
    "d3.min.js", "5.16.0",
    src = c(href = "https://cdn.jsdelivr.net/npm/d3@5.16.0/dist/"),
    script = "d3.min.js",
    all_files = FALSE
  ),
  htmlDependency(
    "locuszoom.app.min.js", "0.14.0",
    src = c(href = "https://cdn.jsdelivr.net/npm/locuszoom@0.14.0/dist/"),
    script = "locuszoom.app.min.js",
    all_files = FALSE
  ),
  htmlDependency(
    "lz-credible-sets.min.js", "latest",
    src = "https://statgen.github.io/locuszoom/dist/ext/",
    script = "lz-credible-sets.min.js",
    all_files = FALSE
  ),
  htmlDependency(
    "lz-dynamic-urls.min.js", "0.14.0",
    src = c(href = "https://cdn.jsdelivr.net/npm/locuszoom@0.14.0/dist/ext/"),
    script = "lz-dynamic-urls.min.js",
    all_files = FALSE
  ),
  htmlDependency(
    "lz-intervals-track.min.js", "0.14.0",
    src = c(href = "https://cdn.jsdelivr.net/npm/locuszoom@0.14.0/dist/ext/"),
    script = "lz-intervals-track.min.js",
    all_files = FALSE
  ),
  htmlDependency(
    "lz-parsers.min.js", "0.14.0",
    src = c(href = "https://cdn.jsdelivr.net/npm/locuszoom@0.14.0/dist/ext/"),
    script = "lz-parsers.min.js",
    all_files = FALSE
  ),
  htmlDependency(
    "lz-tabix-source.min.js", "0.14.0",
    src = c(href = "https://cdn.jsdelivr.net/npm/locuszoom@0.14.0/dist/ext/"),
    script = "lz-tabix-source.min.js",
    all_files = FALSE
  )
)

# Use these dependencies in your Shiny app or R Markdown document
# For example, using tagList to include them all in a Shiny app
shinyApp(
  ui = fluidPage(
    tags$head(tags$script(HTML(dependencies))),
    # Other UI components
  ),
  server = function(input, output) {
    # Server logic
  }
)
