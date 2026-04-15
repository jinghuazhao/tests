test_that("pbsize returns numeric scalar for valid inputs", {

  expect_type(pbsize(kp = 0.05, gamma = 2, p = 0.1), "double")
  expect_length(pbsize(kp = 0.05, gamma = 2, p = 0.1), 1)
})

test_that("pbsize enforces parameter bounds", {

  expect_error(pbsize(kp = -0.1, gamma = 2, p = 0.1))
  expect_error(pbsize(kp = 1.5, gamma = 2, p = 0.1))
  expect_error(pbsize(kp = 0.05, gamma = -1, p = 0.1))
  expect_error(pbsize(kp = 0.05, gamma = 2, p = 1.2))
})

test_that("pbsize increases as gamma approaches 1 (risk weakens)", {

  n1 <- pbsize(kp = 0.05, gamma = 1.2, p = 0.1)
  n2 <- pbsize(kp = 0.05, gamma = 1.05, p = 0.1)

  expect_true(n2 >= n1)
})

test_that("pbsize handles extreme gamma near null effect", {

  n <- pbsize(kp = 0.05, gamma = 1.001, p = 0.1)

  expect_true(is.finite(n) || is.na(n))
})

test_that("pbsize is stable for moderate GWAS-like parameters", {

  n <- pbsize(kp = 0.01, gamma = 1.5, p = 0.2)

  expect_true(is.finite(n))
  expect_true(n > 0)
})
