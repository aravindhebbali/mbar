context("test-cp")

test_that("output from optimal_cp is as expected", {
  model <- rpart::rpart(Species ~ ., data = iris)
  expect_equal(optimal_cp(model), 0.01)
})

test_that("optimal_cp throws appropriate error messages", {
	model <- lm(mpg ~ ., data = mtcars)
	expect_error(optimal_cp(model), "model must be an object of class rpart")
})