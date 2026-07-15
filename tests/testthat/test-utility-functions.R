# Unit tests for exported utility functions
# (LogisticModel, ItemInformationFunc, ItemInformationFunc_GRM)

# --- LogisticModel ---

test_that("LogisticModel returns correct probabilities", {
  # 2PLM: P(theta = b) = 0.5
  expect_equal(LogisticModel(x = 0, a = 1, b = 0), 0.5)
  # 3PLM: lower asymptote c at theta -> -Inf
  expect_equal(LogisticModel(x = -100, a = 1.5, b = 0, c = 0.2), 0.2)
  # 4PLM: upper asymptote d at theta -> +Inf
  expect_equal(LogisticModel(x = 100, a = 1.5, b = 0, c = 0, d = 0.9), 0.9)
  # Monotonically increasing in theta
  probs <- LogisticModel(x = seq(-3, 3, 0.5), a = 1.2, b = 0.3, c = 0.1, d = 0.95)
  expect_true(all(diff(probs) > 0))
})

# --- ItemInformationFunc ---

test_that("ItemInformationFunc matches 2PL closed form", {
  # For 2PL (c = 0, d = 1): I(theta) = a^2 * P * (1 - P)
  a <- 1.5
  b <- 0.5
  for (th in c(-2, 0, 1)) {
    p <- LogisticModel(x = th, a = a, b = b)
    expect_equal(ItemInformationFunc(x = th, a = a, b = b), a^2 * p * (1 - p))
  }
})

test_that("ItemInformationFunc peaks near difficulty for 2PL", {
  thetas <- seq(-4, 4, 0.01)
  info <- sapply(thetas, function(x) ItemInformationFunc(x, a = 1.2, b = 0.7))
  expect_equal(thetas[which.max(info)], 0.7, tolerance = 0.02)
})

# --- ItemInformationFunc_GRM ---

test_that("ItemInformationFunc_GRM matches the numerical Fisher information", {
  # Self-contained check: I(theta) = sum_k (dP_k/dtheta)^2 / P_k,
  # with the category probabilities computed independently and the
  # derivative taken by central differences
  grm_cat_prob <- function(theta, a, b) {
    cum_p <- c(1, 1 / (1 + exp(-a * (theta - b))), 0)
    cum_p[-length(cum_p)] - cum_p[-1]
  }
  fisher_num <- function(theta, a, b, h = 1e-5) {
    P <- grm_cat_prob(theta, a, b)
    dP <- (grm_cat_prob(theta + h, a, b) - grm_cat_prob(theta - h, a, b)) / (2 * h)
    sum(dP^2 / P)
  }
  a <- 1.5
  b <- c(-1, -0.5, 0.5, 1)
  for (th in seq(-3, 3, 0.5)) {
    expect_equal(
      ItemInformationFunc_GRM(theta = th, a = a, b = b),
      fisher_num(th, a, b),
      tolerance = 1e-6,
      info = paste("theta =", th)
    )
  }
  # Binary special case: reduces to the 2PL information a^2 P Q
  p <- 1 / (1 + exp(-1.2 * (0.5 - 0.3)))
  expect_equal(
    ItemInformationFunc_GRM(theta = 0.5, a = 1.2, b = 0.3),
    1.2^2 * p * (1 - p),
    tolerance = 1e-10
  )
})

test_that("ItemInformationFunc_GRM matches exametrika::grm_iif (fixed parent)", {
  skip_if_not_installed("exametrika")
  # exametrika <= 1.15.0 had a defective grm_iif; only compare against
  # versions that carry the corrected formula
  skip_if(utils::packageVersion("exametrika") < "1.15.0.9000",
    message = "installed exametrika predates the grm_iif fix"
  )
  a <- 1.5
  b <- c(-1, -0.5, 0.5, 1)
  for (th in seq(-3, 3, 0.5)) {
    expect_equal(
      ItemInformationFunc_GRM(theta = th, a = a, b = b),
      exametrika::grm_iif(theta = th, a = a, b = b),
      info = paste("theta =", th)
    )
  }
})

# --- 4PL lowerAsym regression (plotICC_gg / plotIIC_gg) ---

test_that("plotICC_gg respects lowerAsym in 4PL models", {
  skip_if_not_installed("exametrika")
  result <- exametrika::IRT(exametrika::J15S500, model = 4)
  p <- plotICC_gg(result, items = 1)[[1]]
  # Evaluate the drawn function at a very low theta: it must approach
  # the item's lower asymptote, not 0
  built <- ggplot2::ggplot_build(p)
  y_min <- min(built$data[[1]]$y, na.rm = TRUE)
  expect_gte(y_min, result$params$lowerAsym[1] - 0.02)
})
