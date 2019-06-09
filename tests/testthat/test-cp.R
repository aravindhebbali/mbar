context("test-cp")

test_that("output from optimal_cp is as expected", {
  model <- rpart::rpart(Species ~ ., data = iris)
  expect_equal(optimal_cp(model), 0.01)
})
