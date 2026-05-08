#' Build a typed OKX JSON response parser (named or positional) to data.table
#'
#' Constructs and returns a parser function that converts an OKX REST API JSON
#' response into a typed \code{data.table}, using a provided field schema and a
#' parsing \code{mode}. Supports both key-based (\code{"named"}) and index-based
#' (\code{"positional"}) endpoints. For \code{"named"} endpoints returning a
#' single object, the parser wraps it as a one-row table.
#'
#' @param schema A \code{data.frame} with \code{okx}, \code{formal}, and
#'   \code{type} columns. Supported types are time, numeric, integer, string,
#'   and logical.
#' @param mode Parser mode: \code{"named"}, \code{"positional"}, or
#'   \code{"vector"}.
#'
#' @return A function with signature \code{function(res, tz)} where:
#'   \describe{
#'     \item{\code{res}}{An \code{httr::response}. The body must decode to a list
#'       with \code{$code}, \code{$msg}, and \code{$data}.}
#'     \item{\code{tz}}{Time zone for \code{"time"} fields. Millisecond values
#'       are converted with \code{as.POSIXct()}.}
#'   }
#'   The returned parser yields a \code{data.table} with column names from
#'   \code{schema$okx} and attaches variable labels as
#'   \code{attr(DT, "var_labels")} (a named character vector \code{formal} by \code{okx}).
#'   Returns \code{NULL} if the API \code{code} is not \code{"0"} or if \code{$data}
#'   is empty.
#'
#' @details
#' \itemize{
#'   \item \strong{Typing}: Columns are preallocated per \code{schema$type}. Time fields
#'   are interpreted as UNIX \emph{milliseconds}.
#'   \item \strong{Modes}:
#'     \itemize{
#'       \item \code{"named"} - fields accessed via \code{okx} keys; a single object
#'         in \code{$data} is wrapped to one row.
#'       \item \code{"positional"} - fields accessed by index order of \code{schema}.
#'       \item \code{"vector"} - scalar or vector payloads returned in one column.
#'     }
#'   \item \strong{Attributes}: \code{attr(DT, "var_labels")} maps \code{okx} to \code{formal}.
#' }
#'
#' @section Errors & warnings:
#' If \code{parsed$code != "0"}, a warning with \code{parsed$msg} is emitted and
#' \code{NULL} is returned.
#' @importFrom httr content
#' @importFrom data.table as.data.table
#' @keywords internal
.make_parser <- function(schema, mode = c("named", "positional", "vector")) {
  mode <- match.arg(mode)

  function(res, tz) {
    if (is.null(res)) {
      return(NULL)
    }

    parsed <- tryCatch(
      httr::content(res, as = "parsed", type = "application/json"),
      error = function(err) {
        warning("Response parsing failed: ", conditionMessage(err), call. = FALSE)
        NULL
      }
    )
    if (is.null(parsed)) {
      return(NULL)
    }

    if (parsed$code != "0") {
      warning("Request failed: ", parsed$msg %||% "unknown OKX API error", call. = FALSE)
      return(NULL)
    }

    data_list <- parsed$data
    if (length(data_list) == 0) return(NULL)

    if (mode == "vector") {
      okx_key <- schema$okx[[1]]
      formal_name <- schema$formal[[1]]
      values <- unlist(data_list, use.names = FALSE)
      DT <- data.table::as.data.table(stats::setNames(list(as.character(values)), okx_key))
      attr(DT, "var_labels") <- stats::setNames(formal_name, okx_key)
      return(list(data_raw = data_list, data_dt = DT))
    }

    # If it's a named single-entry, wrap in a list
    if (mode == "named" && is.list(data_list) && !is.list(data_list[[1]])) {
      data_list <- list(data_list)
    }

    okx_keys  <- schema$okx
    col_names <- schema$formal
    col_types <- schema$type

    .extract_column <- function(index) {
      raw_vals <- lapply(
        data_list,
        function(entry) {
          if (mode == "named") entry[[okx_keys[[index]]]] else entry[[index]]
        }
      )

      type <- col_types[[index]]
      switch(
        type,
        time = {
          seconds <- vapply(
            raw_vals,
            function(raw_val) {
              if (is.null(raw_val)) {
                return(NA_real_)
              }
              suppressWarnings(as.numeric(raw_val) / 1000)
            },
            numeric(1)
          )
          as.POSIXct(seconds, origin = "1970-01-01", tz = tz)
        },
        numeric = vapply(
          raw_vals,
          function(raw_val) {
            if (is.null(raw_val)) NA_real_ else suppressWarnings(as.numeric(raw_val))
          },
          numeric(1)
        ),
        integer = vapply(
          raw_vals,
          function(raw_val) {
            if (is.null(raw_val)) NA_integer_ else suppressWarnings(as.integer(raw_val))
          },
          integer(1)
        ),
        string = vapply(
          raw_vals,
          function(raw_val) {
            if (is.null(raw_val)) {
              return(NA_character_)
            }

            if (is.list(raw_val)) {
              return(as.character(jsonlite::toJSON(raw_val, auto_unbox = TRUE)))
            }

            as.character(raw_val)
          },
          character(1)
        ),
        logical = vapply(
          raw_vals,
          function(raw_val) {
            if (is.null(raw_val)) {
              return(NA)
            }

            if (is.logical(raw_val)) {
              return(raw_val)
            }

            raw_text <- toupper(as.character(raw_val))
            if (identical(raw_text, "TRUE")) return(TRUE)
            if (identical(raw_text, "FALSE")) return(FALSE)
            NA
          },
          logical(1)
        ),
        raw_vals
      )
    }

    cols <- stats::setNames(lapply(seq_along(okx_keys), .extract_column), okx_keys)
    DT <- data.table::as.data.table(cols)

    attr(DT, "var_labels") <- stats::setNames(col_names, okx_keys)
    list(
      data_raw = data_list,
      data_dt = DT
    )
  }
}
