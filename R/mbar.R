#' \code{mbar} package
#'
#' Helper functions for online courses.
#'
#' @docType package
#' @name mbar
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if (getRversion() >= "2.15.1") {
  utils::globalVariables(c(
    ".", "cptable", "xerror", "CP"
  ))
}
