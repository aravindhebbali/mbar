#' Prepare Data
#'
#' Prepares transaction data for analysis.
#'
#' @param data A \code{data.frame} or \code{tibble}.
#' @param id Unique id for the transaction.
#' @param Product/items part of the transaction.
#'
#' @importFrom magrittr %>% %<>%
#'
#' @export
#'
mbar_prep_data <- function(data, id, products) {

  col_id <- rlang::enquo(id)
  col_items <- rlang::enquo(products)

  prep_data <-
    data %>%
    dplyr::select(!! col_id, !! col_items) %>%
    dplyr::group_by(!! col_id)

  group_items <-
    prep_data %>%
    dplyr::mutate(items = paste(!! col_items, collapse = ',')) %>%
    dplyr::select(-!! col_items) %>%
    dplyr::distinct()

  count_items <-
    prep_data %>%
    dplyr::tally()

  max_items <-
    count_items %>%
    dplyr::pull(n) %>%
    max()

  result <-
    suppressWarnings(
      group_items %>%
      tidyr::separate(items, into = paste0("item_", seq_len(max_items)), sep = ",") %>%
      dplyr::inner_join(count_items, by = rlang::quo_name(col_id)) %>%
      dplyr::arrange(n) %>%
      dplyr::select(-n)
    )


  replace_na_list <- as.list(rep("", max_items))
  names(replace_na_list) <- names(result)[-1]

  transaction_data <-
    result %>%
    tidyr::replace_na(replace_na_list)

  return(transaction_data[, -1])
}
