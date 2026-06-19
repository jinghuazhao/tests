set.seed(as.integer(Sys.time()))

# Question files
qfiles <- list.files(
  pattern = "^(A[0-9]+|E[0-9]+|L[0-9]+|N[0-9]+)$"
)

# Randomly select 10 questions
selected <- sample(qfiles, 10)

# Initialize output
out <- c(header, "", "# Questions", "")

# Append questions
for (i in seq_along(selected)) {
  out <- c(
    out,
    paste0("## Question ", i),
    "",
    readLines(selected[i], warn = FALSE),
    "",
    "---",
    ""
  )
}

# Write markdown file
writeLines(out, "MCQs.md")
