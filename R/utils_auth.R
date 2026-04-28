#' Create OKX API request headers
#'
#' Generate the required signed headers for an OKX REST request.
#'
#' @param config List with `api_key`, `secret_key`, and `passphrase`.
#' @param httr_method HTTP method as a string (e.g., "GET" or "POST").
#' @param httr_path Path portion of the API endpoint.
#' @param body_json Optional JSON string of the request body.
#'
#' @return A `httr::add_headers` object containing the signed headers.
.get_headers <- function(config, httr_method, httr_path, body_json = "") {
  .okx_validate_config(config)

  timestamp <- format(Sys.time(), "%Y-%m-%dT%H:%M:%S.000Z", tz = "UTC")
  prehash <- paste0(timestamp, toupper(httr_method), httr_path, body_json)
  hmac_sha256 <- digest::hmac(
    key = config$secret_key,
    object = charToRaw(prehash),
    algo = "sha256",
    raw = TRUE
  )
  signature <- base64enc::base64encode(hmac_sha256)

  if (identical(config$demo, TRUE)) {
    httr::add_headers(
      "OK-ACCESS-KEY" = config$api_key,
      "OK-ACCESS-SIGN" = signature,
      "OK-ACCESS-TIMESTAMP" = timestamp,
      "OK-ACCESS-PASSPHRASE" = config$passphrase,
      "Content-Type" = "application/json",
      "x-simulated-trading" = "1"
    )
  } else {
    httr::add_headers(
      "OK-ACCESS-KEY" = config$api_key,
      "OK-ACCESS-SIGN" = signature,
      "OK-ACCESS-TIMESTAMP" = timestamp,
      "OK-ACCESS-PASSPHRASE" = config$passphrase,
      "Content-Type" = "application/json"
    )
  }
}

#' Build a full OKX request object
#'
#' Assemble URL, headers, and body for an OKX API call.
#'
#' @param httr_method HTTP method ("GET" or "POST").
#' @param base_url Base URL of the OKX API.
#' @param api_path API path (e.g., "/api/v5/account/balance").
#' @param query_string Query string starting with "?" or empty.
#' @param config List with API credentials.
#' @param body_json Optional JSON string for POST body.
#' @param auth Logical. Whether to sign the request with OKX credentials.
#'
#' @return A list with elements: `method`, `url`, `full_path`, `headers`, and `body_json`.
.build_request <- function(httr_method, base_url, api_path, query_string, config = NULL, body_json = "", auth = TRUE) {
  full_path <- paste0(api_path, query_string)
  full_url  <- paste0(base_url, full_path)
  headers   <- if (auth) .get_headers(config, httr_method, full_path, body_json) else NULL

  list(
    method     = httr_method,
    url        = full_url,
    full_path  = full_path,
    headers    = headers,
    body_json  = body_json
  )
}

#' Execute a GET request to OKX
#'
#' Perform a signed GET call to the OKX API.
#'
#' @param api_path API path (e.g., "/api/v5/account/balance").
#' @param query_string Query string starting with "?" or empty.
#' @param config List with API credentials.
#' @param auth Logical. Whether to sign the request with OKX credentials.
#'
#' @return An `httr` response object, or `NULL` if the request fails.
.execute_get_action <- function(api_path, query_string, config = NULL, auth = TRUE) {
  base_url <- .okx_base_url
  httr_method <- "GET"
  req <- .build_request(httr_method, base_url, api_path, query_string, config, auth = auth)
  timeout <- .okx_request_timeout(config)
  res <- tryCatch(
    {
      if (is.null(req$headers)) {
        httr::GET(req$url, timeout)
      } else {
        httr::GET(req$url, req$headers, timeout)
      }
    },
    error = function(err) {
      warning("Request failed: ", conditionMessage(err), call. = FALSE)
      NULL
    }
  )
  if (is.null(res)) {
    return(NULL)
  }
  if (httr::http_error(res)) {
    warning("Request failed: ", httr::status_code(res), call. = FALSE)
    return(NULL)
  }
  res
}

#' Execute a POST request to OKX
#'
#' Perform a signed POST call to the OKX API.
#'
#' @param api_path API path (e.g., "/api/v5/trade/order").
#' @param body_list List to be converted to JSON for the request body.
#' @param config List with API credentials.
#'
#' @return An `httr` response object, or `NULL` if the request fails.
.execute_post_action <- function(api_path, body_list, config) {
  base_url     <- .okx_base_url
  httr_method  <- "POST"

  body_json <- jsonlite::toJSON(body_list, auto_unbox = TRUE, pretty = FALSE)

  req <- .build_request(
    httr_method   = httr_method,
    base_url      = base_url,
    api_path      = api_path,
    query_string  = "",
    config        = config,
    body_json     = body_json,
    auth          = TRUE
  )

  timeout <- .okx_request_timeout(config)
  res <- tryCatch(
    httr::POST(req$url, req$headers, timeout, body = req$body_json, encode = "raw"),
    error = function(err) {
      warning("Request failed: ", conditionMessage(err), call. = FALSE)
      NULL
    }
  )

  if (is.null(res)) {
    return(NULL)
  }
  if (httr::http_error(res)) {
    warning("Request failed: ", httr::status_code(res), call. = FALSE)
    return(NULL)
  }
  res
}
