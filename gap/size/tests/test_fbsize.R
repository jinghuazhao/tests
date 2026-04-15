test_that("fbsize returns structured list", {

  out <- fbsize(gamma = 2, p = 0.1)

  expect_true(is.list(out))
  expect_true(all(c("n1","n2","n3","y","pA","h1","h2","lambdao","lambdas")
                  %in% names(out)))
})

test_that("fbsize returns finite sample sizes for valid input", {

  out <- fbsize(gamma = 2, p = 0.1)

  expect_true(is.finite(out$n1))
  expect_true(is.finite(out$n2))
  expect_true(is.finite(out$n3))
})

test_that("fbsize enforces parameter bounds", {

  expect_error(fbsize(gamma = -1, p = 0.1))
  expect_error(fbsize(gamma = 2, p = -0.1))
  expect_error(fbsize(gamma = 2, p = 1.5))
})

test_that("fbsize behaves deterministically", {

  out1 <- fbsize(gamma = 2, p = 0.1)
  out2 <- fbsize(gamma = 2, p = 0.1)

  expect_equal(out1$n1, out2$n1)
  expect_equal(out1$n2, out2$n2)
  expect_equal(out1$n3, out2$n3)
})

test_that("fbsize increases sample size when gamma approaches 1", {

  a <- fbsize(gamma = 1.5, p = 0.1)
  b <- fbsize(gamma = 1.1, p = 0.1)

  expect_true(b$n1 >= a$n1 || is.na(b$n1))
})

test_that("fbsize handles extreme weak-effect regime", {

  out <- fbsize(gamma = 1.01, p = 0.01)

  expect_true(is.list(out))
  expect_true(all(is.finite(c(out$y, out$pA, out$h1))))
})
