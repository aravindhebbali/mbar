context("test-mbar-prep")

test_that("data is properly processed", {
  processed_data <- mbar_prep_data(mba_sample, InvoiceNo, Description)
  expect_equal(nrow(processed_data), 66)
  expect_equal(ncol(processed_data), 85)
})
