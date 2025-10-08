# Load or install networkD3
if (!require(networkD3)) install.packages("networkD3")
library(networkD3)

# Define nodes (must be unique and in order of appearance)
nodes <- data.frame(name = c("Start", "Math", "Physics", "Engineering",
                             "Academia", "Industry", "Research", "Teaching"))

# Define links using 0-based index for source and target
links <- data.frame(
  source = c(0, 0, 1, 1, 2, 2, 3, 3),  # from "Start", "Math", etc.
  target = c(1, 2, 4, 5, 5, 6, 6, 7),  # to other nodes
  value  = c(5, 3, 2, 1, 2, 1, 2, 1)   # flow strength
)

# Create Sankey diagram
sankeyNetwork(
  Links = links,
  Nodes = nodes,
  Source = "source",
  Target = "target",
  Value = "value",
  NodeID = "name",
  fontSize = 12,
  nodeWidth = 30
)
