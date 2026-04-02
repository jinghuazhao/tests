# Test script for ccsize functions against published tables
# Load the functions
source("ccsize04.md")
source("ccsize07.md")

cat("=" , rep("=", 70), "\n", sep="")
cat("TEST 1: Table 1 Validation (Cai & Zeng 2004)\n")
cat("=" , rep("=", 70), "\n\n", sep="")

table1_data <- list(
  # Format: list(n, pD, p1, theta, q, expected)
  list(1000, 0.10, 0.3, 0.5, 0.10, 0.179),
  list(1000, 0.10, 0.3, 0.5, 0.20, 0.267),
  list(1000, 0.10, 0.3, 1.0, 0.10, 0.422),
  list(1000, 0.10, 0.3, 1.0, 0.20, 0.657),
  list(1000, 0.10, 0.5, 0.5, 0.10, 0.196),
  list(1000, 0.10, 0.5, 0.5, 0.20, 0.299),
  list(1000, 0.10, 0.5, 1.0, 0.10, 0.475),
  list(1000, 0.10, 0.5, 1.0, 0.20, 0.723),
  list(1000, 0.05, 0.3, 0.5, 0.10, 0.129),
  list(1000, 0.05, 0.3, 0.5, 0.20, 0.179),
  list(1000, 0.05, 0.3, 1.0, 0.10, 0.267),
  list(1000, 0.05, 0.3, 1.0, 0.20, 0.422),
  list(1000, 0.05, 0.5, 0.5, 0.10, 0.139),
  list(1000, 0.05, 0.5, 0.5, 0.20, 0.196),
  list(1000, 0.05, 0.5, 1.0, 0.10, 0.299),
  list(1000, 0.05, 0.5, 1.0, 0.20, 0.475),
  list(5000, 0.05, 0.3, 0.5, 0.01, 0.100),
  list(5000, 0.05, 0.3, 0.5, 0.02, 0.129),
  list(5000, 0.05, 0.3, 1.0, 0.01, 0.179),
  list(5000, 0.05, 0.3, 1.0, 0.02, 0.267),
  list(5000, 0.05, 0.5, 0.5, 0.01, 0.106),
  list(5000, 0.05, 0.5, 0.5, 0.02, 0.139),
  list(5000, 0.05, 0.5, 1.0, 0.01, 0.196),
  list(5000, 0.05, 0.5, 1.0, 0.02, 0.299),
  list(5000, 0.01, 0.3, 0.5, 0.01, 0.069),
  list(5000, 0.01, 0.3, 0.5, 0.02, 0.078),
  list(5000, 0.01, 0.3, 1.0, 0.01, 0.093),
  list(5000, 0.01, 0.3, 1.0, 0.02, 0.118),
  list(5000, 0.01, 0.5, 0.5, 0.01, 0.071),
  list(5000, 0.01, 0.5, 0.5, 0.02, 0.081),
  list(5000, 0.01, 0.5, 1.0, 0.01, 0.098),
  list(5000, 0.01, 0.5, 1.0, 0.02, 0.126)
)

all_pass <- TRUE
max_error <- 0

for (row in table1_data) {
  n <- row[[1]]
  pD <- row[[2]]
  p1 <- row[[3]]
  theta <- row[[4]]
  q <- row[[5]]
  expected <- row[[6]]
  
  result <- ccsize(n, q, pD, p1, theta, alpha = 0.05)
  error <- abs(result - expected) / expected * 100
  max_error <- max(max_error, error)
  status <- if (error < 1) "PASS" else "FAIL"
  if (status == "FAIL") all_pass <- FALSE
  
  cat(sprintf("n=%4d pD=%.2f p1=%.1f θ=%.1f q=%.2f | computed=%.3f expected=%.3f | error=%.2f%% [%s]\n",
              n, pD, p1, theta, q, result, expected, error, status))
}

cat("\n")
cat("Max relative error: ", round(max_error, 3), "%\n", sep="")
cat("All tests passed: ", all_pass, "\n", sep="")

cat("\n")
cat("=" , rep("=", 70), "\n", sep="")
cat("TEST 2: Table 3 Validation (Cai & Zeng 2007)\n")
cat("=" , rep("=", 70), "\n\n", sep="")

# Format: pD (P(T<τ)), HR (e^θ), p1 (p), n, expected_A1, expected_A2
table3_A1_data <- list(
  # 20% event rate
  list(0.20, 1.00, 0.1, 1000, 0.050),
  list(0.20, 1.00, 0.2, 1000, 0.053),
  list(0.20, 1.25, 0.1, 1000, 0.163),
  list(0.20, 1.25, 0.2, 1000, 0.187),
  list(0.20, 1.50, 0.1, 1000, 0.326),
  list(0.20, 1.50, 0.2, 1000, 0.384),
  # 40% event rate
  list(0.40, 1.00, 0.1, 1000, 0.052),
  list(0.40, 1.00, 0.2, 1000, 0.050),
  list(0.40, 1.25, 0.1, 1000, 0.207),
  list(0.40, 1.25, 0.2, 1000, 0.267),
  list(0.40, 1.50, 0.1, 1000, 0.439),
  list(0.40, 1.50, 0.2, 1000, 0.564)
)

table3_A2_data <- list(
  # 20% event rate
  list(0.20, 1.00, 0.1, 1000, 0.054),
  list(0.20, 1.00, 0.2, 1000, 0.048),
  list(0.20, 1.25, 0.1, 1000, 0.173),
  list(0.20, 1.25, 0.2, 1000, 0.187),
  list(0.20, 1.50, 0.1, 1000, 0.340),
  list(0.20, 1.50, 0.2, 1000, 0.383),
  # 40% event rate
  list(0.40, 1.00, 0.1, 1000, 0.053),
  list(0.40, 1.00, 0.2, 1000, 0.045),
  list(0.40, 1.25, 0.1, 1000, 0.218),
  list(0.40, 1.25, 0.2, 1000, 0.258),
  list(0.40, 1.50, 0.1, 1000, 0.462),
  list(0.40, 1.50, 0.2, 1000, 0.552)
)

cat("Method A1 tests:\n")
max_error_A1 <- 0
all_A1_pass <- TRUE
for (row in table3_A1_data) {
  pD <- row[[1]]
  hr <- row[[2]]
  p1 <- row[[3]]
  n <- row[[4]]
  expected <- row[[5]]
  q <- 0.1  # Default used in table
  
  result <- ccsize07(n, q, pD, p1, log(hr), 0.05, method = "A1")
  error <- abs(result - expected) / expected * 100
  max_error_A1 <- max(max_error_A1, error)
  status <- if (error < 1) "PASS" else "FAIL"
  if (status == "FAIL") all_A1_pass <- FALSE
  
  cat(sprintf("pD=%.2f HR=%.2f p1=%.1f | computed=%.3f expected=%.3f | error=%.2f%% [%s]\n",
              pD, hr, p1, result, expected, error, status))
}

cat("\n")
cat("Method A2 tests:\n")
max_error_A2 <- 0
all_A2_pass <- TRUE
for (row in table3_A2_data) {
  pD <- row[[1]]
  hr <- row[[2]]
  p1 <- row[[3]]
  n <- row[[4]]
  expected <- row[[5]]
  q <- 0.1  # Default used in table
  
  result <- ccsize07(n, q, pD, p1, log(hr), 0.05, method = "A2")
  error <- abs(result - expected) / expected * 100
  max_error_A2 <- max(max_error_A2, error)
  status <- if (error < 1) "PASS" else "FAIL"
  if (status == "FAIL") all_A2_pass <- FALSE
  
  cat(sprintf("pD=%.2f HR=%.2f p1=%.1f | computed=%.3f expected=%.3f | error=%.2f%% [%s]\n",
              pD, hr, p1, result, expected, error, status))
}

cat("\n")
cat("Max relative error A1: ", round(max_error_A1, 3), "%\n", sep="")
cat("Max relative error A2: ", round(max_error_A2, 3), "%\n", sep="")
cat("All A1 tests passed: ", all_A1_pass, "\n", sep="")
cat("All A2 tests passed: ", all_A2_pass, "\n", sep="")

cat("\n")
cat("=" , rep("=", 70), "\n", sep="")
cat("TEST 3: Reference Example\n")
cat("=" , rep("=", 70), "\n\n", sep="")

# Expected: n=25000, pD=0.3, p1=0.2, hr=1.3 -> sample size ≈ 5099
test_ss <- ccsize07(25000, q = 0.1, pD = 0.3, p1 = 0.2, 
                    theta = log(1.3), alpha = 0.05, 
                    beta = 0.2, power = FALSE, method = "A1")
cat(sprintf("Reference example (n=25000, pD=0.3, p1=0.2, hr=1.3): ssize = %d (expected ≈ 5099)\n", test_ss))

cat("\n")
cat("=" , rep("=", 70), "\n", sep="")
cat("TEST 4: Edge Cases\n")
cat("=" , rep("=", 70), "\n\n", sep="")

cat("Testing input validation:\n")
tryCatch({
  ccsize(-1, 0.1, 0.01, 0.5, log(1.5), 0.05)
}, error = function(e) cat("Negative n: caught error -", e$message, "\n"))

tryCatch({
  ccsize(1000, 1.5, 0.01, 0.5, log(1.5), 0.05)
}, error = function(e) cat("q > 1: caught error -", e$message, "\n"))

tryCatch({
  ccsize(1000, 0.1, 0, 0.5, log(1.5), 0.05)
}, error = function(e) cat("pD = 0: caught error -", e$message, "\n"))

tryCatch({
  ccsize(1000, 0.1, 1.0, 0.5, log(1.5), 0.05)
}, error = function(e) cat("pD = 1: caught error -", e$message, "\n"))

cat("\nTesting extreme values:\n")
# Very small pD
cat("Very small pD (0.001):", ccsize(10000, 0.1, 0.001, 0.5, log(1.2), 0.05), "\n")
# Large HR
cat("Large HR (3.0):", ccsize(1000, 0.1, 0.05, 0.5, log(3.0), 0.05), "\n")
# Small HR
cat("Small HR (1.05):", ccsize(1000, 0.1, 0.05, 0.5, log(1.05), 0.05), "\n")

cat("\nTesting sample size calculation:\n")
# Sample size should return positive integer
ssize1 <- ccsize(5000, 0.1, 0.05, 0.5, log(1.5), 0.05, beta = 0.2, power = FALSE)
cat(sprintf("Sample size (n=5000, pD=0.05, HR=1.5): %d\n", ssize1))

# Infeasible configuration
ssize2 <- ccsize(100, 0.1, 0.01, 0.5, log(1.1), 0.05, beta = 0.2, power = FALSE, verbose = TRUE)
cat(sprintf("Infeasible (small n): %s\n", ifelse(is.na(ssize2), "NA (correct)", "ERROR")))
