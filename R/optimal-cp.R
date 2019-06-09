#' Optimal complexity parameter
#'
#' Extract optimal complexity parameter for tree pruning.
#'
#' @param model An object of class \code{rpart}.
#'
#' @examples
#' model <- rpart::rpart(Species ~ ., data = iris)
#' optimal_cp(model)
#'
#' @export
#'
optimal_cp <- function(model) {

  check_rpart(model)

  cp_table <-
    model %>%
    magrittr::use_series(cptable) %>%
    as.data.frame()

  xerror_min_index <-
    cp_table %>%
    dplyr::pull(xerror) %>%
    which.min()

  cp_table %>%
    dplyr::pull(CP) %>%
    magrittr::extract(xerror_min_index)
}

check_rpart <- function(model) {
  model_class <- class(model)
  if (model_class != "rpart") {
    stop("model must be an object of class rpart")
  }
}
