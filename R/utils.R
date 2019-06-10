check_rpart <- function(model) {
  model_class <- class(model)
  if (model_class != "rpart") {
    stop("model must be an object of class rpart")
  }
}