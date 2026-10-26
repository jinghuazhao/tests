test_that("pbsize2 agrees with tscc for an additive model", {
  pb <- gap::pbsize2(
    N = 200, fc = 0.5, alpha = 0.05,
    gamma = 1.5, p = 0.1, kp = 0.1,
    model = "additive"
  )

  ts <- gap::tscc(
    model = "additive", GRR = 1.5,
    p1 = 0.1, n1 = 100, n2 = 100,
    M = 1, alpha.genome = 0.05,
    pi.samples = 1, pi.markers = 1, K = 0.1
  )

  expect_equal(pb, ts$power[1], tolerance = 1e-6)
})
