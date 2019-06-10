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

#' Class probability prediction
#'
#' Predict class probability on a data set.
#'
#' @param An object of class \code{rpart}.
#' @param A \code{data.frame} or \code{tibble}.
#' @param Response variable.
#'
#' @examples
#' model <- rpart::rpart(Attrition ~ ., data = hr_train)
#' tree_prediction(model, hr_test, Attrition)
#'
#' @importFrom rlang !!
#'
#' @export
#'
tree_prediction <- function(model, test_data, response) {

  resp_var <- rlang::enquo(response)
  resp <- dplyr::pull(test_data, !!resp_var)

  model %>%
    predict(newdata = test_data, type = "prob") %>%
    as.data.frame() %>%
    dplyr::select(2) %>%
    ROCR::prediction(resp)
}

#' AUC
#'
#' Area under the curve.
#'
#' @param perform An object of class \code{prediction}.
#'
#' @examples
#' model   <- rpart::rpart(Attrition ~ ., data = hr_train)
#' perform <- tree_prediction(model, hr_test, Attrition)
#' tree_auc(perform)
#'
#' @export
#'
tree_auc <- function(perform) {
  perform %>%
    ROCR::performance(measure = "auc") %>%
    slot("y.values") %>%
    magrittr::extract2(1)
}

#' Plot validation curves
#'
#' Plot curves to validate decision tree model.
#'
#' @param perform An object of class \code{prediction}.
#' @param line_color Color of lines in the plot.
#'
#' @examples
#' model   <- rpart::rpart(Attrition ~ ., data = hr_train)
#' perform <- tree_prediction(model, hr_test, Attrition)
#' plot_roc(perform)
#' plot_prec_rec(perform)
#' plot_sens_spec(perform)
#' plot_lift_curve(perform)
#'
#' @export
#'
plot_roc <- function(perform, line_color = "blue") {

  plot_perform(perform, "tpr", "fpr") +
    ggplot2::xlab("False Positive Rate") +
    ggplot2::ylab("True Positive Rate") +
    ggplot2::ggtitle("ROC Curve")
}

#' @rdname plot_roc
#' @export
#'
plot_prec_rec <- function(perform, line_color = "blue") {

  plot_perform(perform, "prec", "rec") +
    ggplot2::xlab("Recall") + ggplot2::ylab("Precision") +
    ggplot2::ggtitle("Precision Recall Curve")

}

#' @rdname plot_roc
#' @export
#'
plot_sens_spec <- function(perform, line_color = "blue") {

  plot_perform(perform, "sens", "spec") +
    ggplot2::xlab("Specificity") + ggplot2::ylab("Sensitivity") +
    ggplot2::ggtitle("Sensitivity Specificity Curve")

}

#' @rdname plot_roc
#' @export
#'
plot_lift_curve <- function(perform, line_color = "blue") {

  plot_perform(perform, "lift", "rpp") +
    ggplot2::xlab("Rate of Positive Predictions") +
    ggplot2::ylab("Lift Value") +
    ggplot2::ggtitle("Lift Curve")

}

#' Generic plot function
#'
#' A generic plot function used to generate validation plots.
#'
plot_perform <- function(perform, y, x, line_color = "blue") {

	measures <- ROCR::performance(perform, measure = y, x.measure = x)

  yval <-
    measures %>%
    slot("y.values") %>%
    magrittr::extract2(1)

  xval <-
    measures %>%
    slot("x.values") %>%
    magrittr::extract2(1)

  data.frame(yval, xval) %>%
    ggplot2::ggplot() +
    ggplot2::geom_line(ggplot2::aes(x = xval, y = yval), color = line_color)

}
