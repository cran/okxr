#' Internal OKX request helpers
#'
#' Shared helpers for request validation, query construction, and package-wide
#' defaults used by user-facing wrappers.
#'
#' @keywords internal
.okx_default_tz <- "Asia/Hong_Kong"

#' @keywords internal
.okx_default_timeout <- 10

#' @keywords internal
.okx_validate_config <- function(config) {
  if (!is.list(config)) {
    stop("`config` must be a list.", call. = FALSE)
  }

  required_fields <- c("api_key", "secret_key", "passphrase")
  missing_fields <- setdiff(required_fields, names(config))
  if (length(missing_fields) > 0L) {
    stop(
      "Missing required config field(s): ",
      paste(missing_fields, collapse = ", "),
      call. = FALSE
    )
  }

  invisible(config)
}

#' @keywords internal
.okx_request_timeout <- function(config = NULL) {
  timeout <- if (is.list(config) && !is.null(config$timeout)) {
    config$timeout
  } else {
    getOption("okxr.timeout", .okx_default_timeout)
  }

  if (!is.numeric(timeout) || length(timeout) != 1L || is.na(timeout) || timeout <= 0) {
    stop("Request timeout must be a single positive number of seconds.", call. = FALSE)
  }

  httr::timeout(timeout)
}

#' @keywords internal
.okx_build_query <- function(...) {
  params <- list(...)
  keep <- !vapply(
    params,
    function(value) is.null(value) || length(value) == 0L || identical(value, ""),
    logical(1)
  )
  params <- params[keep]

  if (length(params) == 0L) {
    return("")
  }

  parts <- Map(
    function(name, value) {
      if (length(value) != 1L) {
        stop("Each query parameter must be length 1.", call. = FALSE)
      }

      paste0(
        utils::URLencode(name, reserved = TRUE),
        "=",
        utils::URLencode(as.character(value), reserved = TRUE)
      )
    },
    names(params),
    params
  )

  paste0("?", paste(unlist(parts, use.names = FALSE), collapse = "&"))
}

#' @keywords internal
.okx_datetime_to_ms <- function(value, tz = .okx_default_tz, format = "%Y-%m-%d %H:%M:%S") {
  if (is.null(value)) {
    return(NULL)
  }

  timestamp <- as.POSIXct(value, format = format, tz = tz)
  if (is.na(timestamp)) {
    stop(
      "`value` must be parseable with format '", format, "'.",
      call. = FALSE
    )
  }

  as.integer(as.numeric(timestamp) * 1000)
}

#' @keywords internal
.okx_extract_result <- function(parsed_res, raw_data = FALSE) {
  if (is.null(parsed_res)) {
    return(NULL)
  }

  if (raw_data) parsed_res$data_raw else parsed_res$data_dt
}

#' @keywords internal
.okx_generate_client_order_id <- function(prefix = "r") {
  paste0(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sample(1000:9999, 1))
}
