context("test-cp")

test_that("output from optimal_cp is as expected", {
  model <- rpart::rpart(Species ~ ., data = iris)
  expect_equal(optimal_cp(model), 0.01)
})

test_that("optimal_cp throws appropriate error messages", {
	model <- lm(mpg ~ ., data = mtcars)
	expect_error(optimal_cp(model), "model must be an object of class rpart")
})

model   <- rpart::rpart(Attrition ~ ., data = hr_train)
perform <- tree_prediction(model, hr_test, Attrition)

test_that("output from tree_auc is as expected", {	
	expect_equal(round(tree_auc(perform), 2), 0.67)
})

test_that("output from tree_prediction is as expected", {
	out <- tree_prediction(model, hr_test, Attrition)
	expect_equal(round(mean(slot(out, "predictions")[[1]]), 2), 0.17)
	expect_equal(round(mean(slot(out, "fp")[[1]]), 2), 70.8)
})

test_that("output from plot_roc is as expected", {
	p <- plot_roc(perform)
	vdiffr::expect_doppelganger('plot roc', p)
})

test_that("output from plot_prec_rec is as expected", {
	p <- plot_prec_rec(perform)
	vdiffr::expect_doppelganger('plot prec_rec', p)
})

test_that("output from plot_sens_spec is as expected", {
	p <- plot_sens_spec(perform)
	vdiffr::expect_doppelganger('plot sens_spec', p)
})

test_that("output from plot_lift_curve is as expected", {
	p <- plot_lift_curve(perform)
	vdiffr::expect_doppelganger('plot lift_curve', p)
})