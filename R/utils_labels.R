#' Retrieve variable labels from OKX data frames
#'
#' Returns human-readable labels attached to a data frame produced by OKX API parsers.
#' You can retrieve all labels or a label for a specific variable by name or index.
#'
#' @param df A \code{data.frame} with \code{"var_labels"} attribute (as returned by OKX API parsers).
#' @param var Optional variable name (character) or index (numeric). If \code{NULL}, all labels are returned.
#' @param default Value to return if the variable has no label (default: \code{NA_character_}).
#'
#' @return A character label if \code{var} is provided, or a named character vector of all labels if \code{var = NULL}.
#'
#' @examples
#' df <- data.frame(ordId = "123", px = 10)
#' attr(df, "var_labels") <- c(ordId = "Order ID", px = "Price")
#'
#' get_var_label(df, "ordId")
#' get_var_label(df, 2)
#' get_var_label(df)
#'
#' @export
get_var_label <- function(df, var = NULL, default = NA_character_) {
  labels <- attr(df, "var_labels")
  if (is.null(labels)) return(default)

  if (is.null(var)) {
    return(labels)  # Return all labels
  }

  var_name <- if (is.character(var)) var else names(df)[var]
  if (!var_name %in% names(labels)) return(default)

  labels[[var_name]]
}
