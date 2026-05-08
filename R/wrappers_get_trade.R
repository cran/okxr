#---- Trade: GET Wrappers ----

#' Get trade order details
#'
#' Retrieve detailed information about a specific OKX order by either the
#' exchange-assigned `ord_id` or your client-assigned `cl_ord_id`.
#'
#' @details
#' You must provide exactly one identifier: `ord_id` **or** `cl_ord_id`.
#' Timestamps in the response are converted to `POSIXct` in the supplied `tz`.
#'
#' @param inst_id Character. Instrument ID, e.g. `"ETH-USDT-SWAP"` (perps),
#'   `"BTC-USDT"` (spot), or `"BTC-USD-240927"` (dated futures).
#' @param ord_id Character, optional. The OKX order ID. Provide this **or** `cl_ord_id`.
#' @param cl_ord_id Character, optional. Your client order ID. Provide this **or** `ord_id`.
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`. May also include `base_url`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` (one row) with order details following OKX schema (e.g.,
#' `ordId`, `clOrdId`, `instId`, `ordType`, `px`, `sz`, `side`, `posSide`,
#' `tdMode`, `accFillSz`, `fillPx`, `fillSz`, `fillTime`, `avgPx`, `state`,
#' `lever`, etc.). Timestamp columns are `POSIXct` in `tz`.
#'
#' @section Common errors:
#' - `Either 'ord_id' or 'cl_ord_id' must be provided.` (client-side)
#' - HTTP 401 Unauthorized (missing/invalid credentials)
#' - OKX `code` like `51000` invalid sign or `51603` order not found
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' get_trade_order(
#'   inst_id = "ETH-USDT-SWAP",
#'   ord_id  = "1234567890",
#'   config  = cfg
#' )
#' }
#'
#' @seealso [get_trade_orders_pending()], [get_trade_orders_history_7d()]
#' @note Since okxr 0.1.1
#' @export
get_trade_order <- function(inst_id, ord_id = NULL, cl_ord_id = NULL, config, tz = .okx_default_tz) {
  if (xor(is.null(ord_id), is.null(cl_ord_id)) == FALSE) {
    stop("Provide exactly one of `ord_id` or `cl_ord_id`.", call. = FALSE)
  }

  query_string <- .okx_build_query(
    instId = inst_id,
    ordId = ord_id,
    clOrdId = cl_ord_id
  )
  .gets$trade_order(query_string = query_string, config = config, tz = tz)
}

#' Get all pending trade orders
#'
#' Retrieve all currently open (unfilled) orders for your OKX account.
#'
#' @details
#' Returns one row per open order. Timestamps are parsed to `POSIXct` using `tz`.
#'
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`. May also include `base_url`.
#' @param tz Character. Time zone for parsing timestamps (e.g. `"Asia/Hong_Kong"`).
#'
#' @return
#' A `data.frame` with one row per pending order and columns following the OKX
#' schema (e.g., `cTime`, `ordId`, `clOrdId`, `tag`, `instId`, `ordType`, `px`,
#' `sz`, `side`, `posSide`, `tdMode`, `accFillSz`, `fillPx`, `fillSz`,
#' `fillTime`, `avgPx`, `state`, `lever`, ...). Timestamp columns are `POSIXct`.
#'
#' @section Common errors:
#' - HTTP 401 Unauthorized (missing/invalid credentials)
#' - Rate limiting: HTTP 429 / OKX throttle codes
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' df <- get_trade_orders_pending(config = cfg, tz = "Asia/Hong_Kong")
#' head(df)
#' }
#'
#' @seealso [get_trade_order()], [get_trade_orders_history_7d()]
#' @note Since okxr 0.1.1
#' @export
get_trade_orders_pending <- function(config, tz = .okx_default_tz) {
  .gets$trade_orders_pending(query_string = "", config = config, tz = tz)
}

#' Get trade orders history (last 7 days)
#'
#' Retrieve recent order history for an instrument type.
#'
#' This wraps `/api/v5/trade/orders-history` and covers about 7 days of data.
#' Older data is available from OKX's archive endpoint.
#'
#' @param inst_type Character. Instrument type. One of `"SPOT"`, `"MARGIN"`,
#'   `"SWAP"`, `"FUTURES"`, `"OPTION"`. Default `"SWAP"`.
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`. May also include `base_url`.
#' @param tz Character. Time zone for parsing timestamps (e.g. `"Asia/Hong_Kong"`).
#'
#' @return
#' A `data.frame` with one row per historical order and columns following the OKX
#' schema (same layout as pending orders, plus final states). Timestamp columns
#' are `POSIXct` in `tz`.
#'
#' @section Common errors:
#' - HTTP 401 Unauthorized
#' - HTTP 400 Bad Request for invalid `inst_type`
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' hist <- get_trade_orders_history_7d(
#'   inst_type = "SWAP",
#'   config = cfg,
#'   tz = "Asia/Hong_Kong"
#' )
#' tail(hist)
#' }
#'
#' @seealso [get_trade_order()], [get_trade_orders_pending()]
#' @note Since okxr 0.1.2
#' @export
get_trade_orders_history_7d <- function(
  inst_type = "SWAP",
  config,
  tz = .okx_default_tz
) {
  query_string <- .okx_build_query(instType = inst_type)
  .gets$trade_orders_history_7d(query_string = query_string, config = config, tz = tz)
}

#' Get trade fills
#'
#' Retrieve recently filled transaction details from the last 3 days.
#'
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param inst_family Character or `NULL`. Instrument family filter.
#' @param inst_id Character or `NULL`. Instrument ID filter.
#' @param ord_id Character or `NULL`. Order ID filter.
#' @param sub_type Character or `NULL`. Transaction subtype filter.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param begin Character or `NULL`. Begin timestamp in milliseconds.
#' @param end Character or `NULL`. End timestamp in milliseconds.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with fill rows.
#'
#' @export
get_trade_fills <- function(inst_type = NULL, inst_family = NULL, inst_id = NULL, ord_id = NULL, sub_type = NULL, after = NULL, before = NULL, limit = NULL, begin = NULL, end = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    instFamily = inst_family,
    instId = inst_id,
    ordId = ord_id,
    subType = sub_type,
    after = after,
    before = before,
    limit = limit,
    begin = begin,
    end = end
  )
  .gets$trade_fills(query_string = query_string, config = config, tz = tz)
}

#' Get trade fills history
#'
#' Retrieve historical filled transaction details from the last 3 months.
#'
#' @param inst_type Character. Instrument type, e.g. `"SPOT"` or `"SWAP"`.
#' @param inst_family Character or `NULL`. Instrument family filter.
#' @param inst_id Character or `NULL`. Instrument ID filter.
#' @param ord_id Character or `NULL`. Order ID filter.
#' @param sub_type Character or `NULL`. Transaction subtype filter.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param begin Character or `NULL`. Begin timestamp in milliseconds.
#' @param end Character or `NULL`. End timestamp in milliseconds.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with historical fill rows.
#'
#' @export
get_trade_fills_history <- function(inst_type, inst_family = NULL, inst_id = NULL, ord_id = NULL, sub_type = NULL, after = NULL, before = NULL, limit = NULL, begin = NULL, end = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    instFamily = inst_family,
    instId = inst_id,
    ordId = ord_id,
    subType = sub_type,
    after = after,
    before = before,
    limit = limit,
    begin = begin,
    end = end
  )
  .gets$trade_fills_history(query_string = query_string, config = config, tz = tz)
}

#' Get trade account rate limit
#'
#' Retrieve account rate limit information related to new and amended order
#' requests.
#'
#' @details
#' Wraps `/api/v5/trade/account-rate-limit`. Returns one row containing the
#' current account rate limit and fill-ratio metrics used by OKX.
#'
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A one-row `data.frame` with rate-limit metrics such as
#'   `accRateLimit`, `fillRatio`, `mainFillRatio`, `nextAccRateLimit`, and `ts`.
#'
#' @export
get_trade_account_rate_limit <- function(config, tz = .okx_default_tz) {
  .gets$trade_account_rate_limit(query_string = "", config = config, tz = tz)
}

#' Get trade orders history
#'
#' Retrieve completed orders from the last 7 days.
#'
#' @param inst_type Character. Instrument type.
#' @param inst_family Character or `NULL`. Instrument family filter.
#' @param inst_id Character or `NULL`. Instrument ID filter.
#' @param ord_type Character or `NULL`. Order type filter.
#' @param state Character or `NULL`. Order state filter.
#' @param category Character or `NULL`. Order category filter.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param begin Character or `NULL`. Begin timestamp in milliseconds.
#' @param end Character or `NULL`. End timestamp in milliseconds.
#' @param limit Integer or `NULL`. Number of results to request.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps.
#'
#' @return A `data.frame` with historical order rows.
#' @export
get_trade_orders_history <- function(inst_type, inst_family = NULL, inst_id = NULL, ord_type = NULL, state = NULL, category = NULL, after = NULL, before = NULL, begin = NULL, end = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    instFamily = inst_family,
    instId = inst_id,
    ordType = ord_type,
    state = state,
    category = category,
    after = after,
    before = before,
    begin = begin,
    end = end,
    limit = limit
  )
  .gets$trade_orders_history(query_string = query_string, config = config, tz = tz)
}

#' Get archived trade orders history
#'
#' Retrieve completed orders from the last 3 months.
#'
#' @inheritParams get_trade_orders_history
#'
#' @return A `data.frame` with archived order rows.
#' @export
get_trade_orders_history_archive <- function(inst_type, inst_family = NULL, inst_id = NULL, ord_type = NULL, state = NULL, category = NULL, after = NULL, before = NULL, begin = NULL, end = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    instFamily = inst_family,
    instId = inst_id,
    ordType = ord_type,
    state = state,
    category = category,
    after = after,
    before = before,
    begin = begin,
    end = end,
    limit = limit
  )
  .gets$trade_orders_history_archive(query_string = query_string, config = config, tz = tz)
}

#' Get easy convert currency list
#'
#' Retrieve currencies available for easy convert.
#'
#' @param source Character or `NULL`. Source account type filter.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps.
#'
#' @return A `data.frame` with source and target currency metadata.
#' @export
get_trade_easy_convert_currency_list <- function(source = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(source = source)
  .gets$trade_easy_convert_currency_list(query_string = query_string, config = config, tz = tz)
}

#' Get easy convert history
#'
#' Retrieve easy convert history.
#'
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of results to request.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps.
#'
#' @return A `data.frame` with easy convert history rows.
#' @export
get_trade_easy_convert_history <- function(after = NULL, before = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(after = after, before = before, limit = limit)
  .gets$trade_easy_convert_history(query_string = query_string, config = config, tz = tz)
}

#' Get one-click repay currency list
#'
#' Retrieve repayable currencies for the legacy one-click repay endpoint.
#'
#' @param debt_type Character or `NULL`. Debt type filter.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps.
#'
#' @return A `data.frame` with debt and repay currency metadata.
#' @export
get_trade_one_click_repay_currency_list <- function(debt_type = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(debtType = debt_type)
  .gets$trade_one_click_repay_currency_list(query_string = query_string, config = config, tz = tz)
}

#' Get one-click repay history
#'
#' Retrieve legacy one-click repay history.
#'
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of results to request.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps.
#'
#' @return A `data.frame` with one-click repay history rows.
#' @export
get_trade_one_click_repay_history <- function(after = NULL, before = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(after = after, before = before, limit = limit)
  .gets$trade_one_click_repay_history(query_string = query_string, config = config, tz = tz)
}

#' Get one-click repay currency list v2
#'
#' Retrieve repayable currencies for the new one-click repay endpoint.
#'
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps.
#'
#' @return A `data.frame` with debt and repay currency metadata.
#' @export
get_trade_one_click_repay_currency_list_v2 <- function(
  config,
  tz = .okx_default_tz
) {
  .gets$trade_one_click_repay_currency_list_v2(query_string = "", config = config, tz = tz)
}

#' Get one-click repay history v2
#'
#' Retrieve new one-click repay history.
#'
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of results to request.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps.
#'
#' @return A `data.frame` with one-click repay history rows.
#' @export
get_trade_one_click_repay_history_v2 <- function(after = NULL, before = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(after = after, before = before, limit = limit)
  .gets$trade_one_click_repay_history_v2(query_string = query_string, config = config, tz = tz)
}

#' Get a single algo order
#'
#' Retrieve a specific algo order by algo ID or client algo order ID.
#'
#' @param algo_id Character or `NULL`. Algo order ID.
#' @param algo_cl_ord_id Character or `NULL`. Client algo order ID.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps.
#'
#' @return A `data.frame` with algo order details.
#' @export
get_trade_order_algo <- function(algo_id = NULL, algo_cl_ord_id = NULL, config, tz = .okx_default_tz) {
  if (xor(is.null(algo_id), is.null(algo_cl_ord_id)) == FALSE) {
    stop("Provide exactly one of `algo_id` or `algo_cl_ord_id`.", call. = FALSE)
  }

  query_string <- .okx_build_query(algoId = algo_id, algoClOrdId = algo_cl_ord_id)
  .gets$trade_order_algo(query_string = query_string, config = config, tz = tz)
}

#' Get pending algo orders
#'
#' Retrieve untriggered algo orders.
#'
#' @param ord_type Character. Algo order type filter.
#' @param algo_id Character or `NULL`. Algo order ID.
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param inst_id Character or `NULL`. Instrument ID filter.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of results to request.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps.
#'
#' @return A `data.frame` with pending algo orders.
#' @export
get_trade_orders_algo_pending <- function(ord_type, algo_id = NULL, inst_type = NULL, inst_id = NULL, after = NULL, before = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    ordType = ord_type,
    algoId = algo_id,
    instType = inst_type,
    instId = inst_id,
    after = after,
    before = before,
    limit = limit
  )
  .gets$trade_orders_algo_pending(query_string = query_string, config = config, tz = tz)
}

#' Get algo order history
#'
#' Retrieve historical algo orders.
#'
#' @param ord_type Character. Algo order type filter.
#' @param state Character or `NULL`. Algo order state filter.
#' @param algo_id Character or `NULL`. Algo order ID.
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param inst_id Character or `NULL`. Instrument ID filter.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of results to request.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps.
#'
#' @return A `data.frame` with algo order history rows.
#' @export
get_trade_orders_algo_history <- function(ord_type, state = NULL, algo_id = NULL, inst_type = NULL, inst_id = NULL, after = NULL, before = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    ordType = ord_type,
    state = state,
    algoId = algo_id,
    instType = inst_type,
    instId = inst_id,
    after = after,
    before = before,
    limit = limit
  )
  .gets$trade_orders_algo_history(query_string = query_string, config = config, tz = tz)
}
