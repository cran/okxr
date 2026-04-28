#---- Market: GET Wrappers ----

.okx_standardize_ohlcv_names <- function(df) {
  if (is.null(df)) {
    return(NULL)
  }

  names(df)[names(df) == "ts"] <- "timestamp"
  names(df)[names(df) == "o"]  <- "open"
  names(df)[names(df) == "h"]  <- "high"
  names(df)[names(df) == "l"]  <- "low"
  names(df)[names(df) == "c"]  <- "close"
  names(df)[names(df) == "vol"]  <- "volume"
  names(df)[names(df) == "volCcyQuote"]  <- "volQuote"
  df
}

#' Get recent market candles
#'
#' Retrieve the latest candlestick data for a given instrument and bar size.
#'
#' @details
#' Wraps `/api/v5/market/candles`. Returns up to `limit` bars, sorted by
#' timestamp. Candlestick fields can be standardized to common OHLCV names via
#' `standardize_names = TRUE`.
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT"`, `"ETH-USDT-SWAP"`.
#' @param bar Character. Candlestick granularity, e.g. `"1m"`, `"5m"`, `"1H"`, `"1D"`.
#' @param limit Integer. Number of bars to retrieve. Default `100L`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#' @param standardize_names Logical. If `TRUE` (default), renames columns to
#'   `timestamp`, `open`, `high`, `low`, `close`, `volume`, `volQuote`.
#'
#' @return
#' A `data.frame` with columns including `timestamp`, `open`, `high`, `low`,
#' `close`, `volume`, and `volQuote`. Timestamps are `POSIXct` in `tz`.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' get_market_candles("BTC-USDT", bar = "5m", limit = 50, config = cfg)
#' }
#'
#' @seealso [get_market_history_candles()], [get_public_mark_price()]
#' @family okxr-market
#' @note Since okxr 0.1.1
#' @export
get_market_candles <- function(inst_id, bar, limit = 100L, config = NULL, tz = .okx_default_tz, standardize_names = TRUE) {
  query_string <- .okx_build_query(instId = inst_id, bar = bar, limit = as.integer(limit))
  df <- .gets$market_candles(query_string = query_string, config = config, tz = tz)
  if (standardize_names) return(.okx_standardize_ohlcv_names(df))
  df
}

#' Get historical market candles
#'
#' Retrieve candlestick data before a specific datetime.
#'
#' @details
#' Wraps `/api/v5/market/history-candles`. If `before` is supplied, it is
#' converted to milliseconds since epoch (in `tz`) and sent as `after=…`
#' (per OKX semantics: *return data before this time*).
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT"`.
#' @param bar Character. Candlestick granularity, e.g. `"1m"`, `"5m"`, `"1H"`.
#' @param before Character or `NULL`. Timestamp string in format
#'   `"\%Y-\%m-\%d \%H:\%M:\%S"`. If `NULL` (default), fetches most recent history.
#' @param limit Integer. Number of bars to retrieve. Default `100L`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#' @param standardize_names Logical. If `TRUE` (default), renames columns to
#'   `timestamp`, `open`, `high`, `low`, `close`, `volume`, `volQuote`.
#'
#' @return
#' A `data.frame` of candlestick bars with standardized column names if
#' `standardize_names = TRUE`. Timestamps are `POSIXct` in `tz`.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' get_market_history_candles(
#'   "ETH-USDT-SWAP", bar = "1H",
#'   before = "2025-08-20 00:00:00", config = cfg
#' )
#' }
#'
#' @seealso [get_market_candles()]
#' @family okxr-market
#' @note Since okxr 0.1.1
#' @export
get_market_history_candles <- function(inst_id, bar, before = NULL, limit = 100L, config = NULL, tz = .okx_default_tz, standardize_names = TRUE) {
  before_ms <- .okx_datetime_to_ms(before, tz = tz)
  query_string <- .okx_build_query(
    instId = inst_id,
    bar = bar,
    after = before_ms,
    limit = as.integer(limit)
  )
  df <- .gets$market_history_candles(query_string = query_string, config = config, tz = tz)
  if (is.null(df) || length(df) == 0L) {
    return(NULL)
  }
  if (standardize_names) return(.okx_standardize_ohlcv_names(df))
  df
}

#' Get current mark price
#'
#' Retrieve the current mark price for a given instrument.
#'
#' @details
#' Wraps `/api/v5/public/mark-price`. Useful for margin calculations and PnL
#' estimation. Returns a single row with the latest mark price and timestamp.
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT"`, `"ETH-USDT-SWAP"`.
#' @param inst_type Character. Instrument type. One of `"SPOT"`, `"MARGIN"`,
#'   `"SWAP"` (default), `"FUTURES"`, `"OPTION"`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with columns `timestamp`, `instId`, `markPx`.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' get_public_mark_price("BTC-USDT", inst_type = "SWAP", config = cfg)
#' }
#'
#' @seealso [get_public_instruments()]
#' @family okxr-market
#' @note Since okxr 0.1.1
#' @export
get_public_mark_price <- function(inst_id, inst_type = "SWAP", config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instType = inst_type, instId = inst_id)
  .gets$public_mark_price(query_string = query_string, config = config, tz = tz)
}

#' Get market ticker
#'
#' Retrieve the latest ticker snapshot for a specific instrument.
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT"` or `"ETH-USDT-SWAP"`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with the latest ticker fields returned by OKX.
#'
#' @export
get_market_ticker <- function(inst_id, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instId = inst_id)
  .gets$market_ticker(query_string = query_string, config = config, tz = tz)
}

#' Get market tickers
#'
#' Retrieve ticker snapshots for all instruments under an instrument type.
#'
#' @param inst_type Character. Instrument type, e.g. `"SPOT"`, `"SWAP"`,
#'   `"FUTURES"`, or `"OPTION"`.
#' @param uly Character or `NULL`. Underlying. Optional filter for derivatives.
#' @param inst_family Character or `NULL`. Instrument family. Optional filter
#'   for derivatives and options.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with one row per ticker.
#'
#' @export
get_market_tickers <- function(inst_type, uly = NULL, inst_family = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    uly = uly,
    instFamily = inst_family
  )
  .gets$market_tickers(query_string = query_string, config = config, tz = tz)
}

#' Get order book
#'
#' Retrieve the current order book for an instrument.
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT"`.
#' @param sz Integer or `NULL`. Order book depth. If `NULL`, OKX uses its
#'   endpoint default.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with JSON-encoded `asks` and `bids` columns plus `ts`.
#'
#' @export
get_market_books <- function(inst_id, sz = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instId = inst_id, sz = sz)
  .gets$market_books(query_string = query_string, config = config, tz = tz)
}

#' Get recent public trades
#'
#' Retrieve recent public trades for an instrument.
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT"`.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with recent public trades.
#'
#' @export
get_market_trades <- function(inst_id, limit = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instId = inst_id, limit = limit)
  .gets$market_trades(query_string = query_string, config = config, tz = tz)
}

#' Get historical public trades
#'
#' Retrieve public trade history for an instrument.
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT"`.
#' @param type Character or `NULL`. Pagination type, using OKX values.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with historical public trades.
#'
#' @export
get_market_history_trades <- function(inst_id, type = NULL, after = NULL, before = NULL, limit = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instId = inst_id,
    type = type,
    after = after,
    before = before,
    limit = limit
  )
  .gets$market_history_trades(query_string = query_string, config = config, tz = tz)
}

#' Get instrument metadata
#'
#' Retrieve metadata for instruments of a given type.
#'
#' @details
#' Wraps `/api/v5/public/instruments`. Returns one row per instrument,
#' including contract specifications, tick size, lot size, expiry, and state.
#'
#' @param inst_id Character or `NULL`. Specific instrument ID to query. Use
#'   `NULL` to fetch all instruments of `inst_type`.
#' @param inst_type Character. Instrument type. One of `"SPOT"`, `"MARGIN"`,
#'   `"SWAP"` (default), `"FUTURES"`, `"OPTION"`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with instrument metadata (e.g., `instType`, `instId`, `uly`,
#' `baseCcy`, `quoteCcy`, `settleCcy`, `ctVal`, `ctMult`, `tickSz`, `lotSz`,
#' `minSz`, `expTime`, `lever`, `state`, …).
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' # Get metadata for all SWAP instruments
#' df <- get_public_instruments(inst_type = "SWAP", config = cfg)
#'
#' # Get metadata for one instrument
#' get_public_instruments("ETH-USDT-SWAP", inst_type = "SWAP", config = cfg)
#' }
#'
#' @seealso [get_public_mark_price()]
#' @family okxr-market
#' @note Since okxr 0.1.2
#' @export
get_public_instruments <- function(inst_id = NULL, inst_type = "SWAP", config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instType = inst_type, instId = inst_id)
  .gets$public_instruments(query_string = query_string, config = config, tz = tz)
}

#' Get current funding rate
#'
#' Retrieve the current funding rate for a perpetual swap instrument.
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT-SWAP"`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` containing the current funding rate fields returned by OKX.
#'
#' @export
get_public_funding_rate <- function(inst_id, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instId = inst_id)
  .gets$public_funding_rate(query_string = query_string, config = config, tz = tz)
}

#' Get funding rate history
#'
#' Retrieve historical funding rate entries for a perpetual swap instrument.
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT-SWAP"`.
#' @param before Optional cursor for records earlier than the supplied value.
#' @param after Optional cursor for records later than the supplied value.
#' @param limit Integer. Number of records to request. Default `400`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` containing funding rate history rows returned by OKX.
#'
#' @export
get_public_funding_rate_history <- function(inst_id, before = NULL, after = NULL, limit = 400, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instId = inst_id,
    before = before,
    after = after,
    limit = as.integer(limit)
  )
  .gets$public_funding_rate_history(query_string = query_string, config = config, tz = tz)
}

#' Get open interest
#'
#' Retrieve current open interest for an instrument.
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT-SWAP"`.
#' @param inst_type Character. Instrument type such as `"SWAP"` or `"FUTURES"`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` containing open interest fields returned by OKX.
#'
#' @export
get_public_open_interest <- function(inst_id, inst_type, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instType = inst_type, instId = inst_id)
  .gets$public_open_interest(query_string = query_string, config = config, tz = tz)
}

#' Get OKX system time
#'
#' Retrieve OKX system time.
#'
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A one-row `data.frame` with system time.
#'
#' @export
get_public_time <- function(config = NULL, tz = .okx_default_tz) {
  .gets$public_time(query_string = "", config = config, tz = tz)
}

#' Get price limit
#'
#' Retrieve buy and sell price limits for an instrument.
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT-SWAP"`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with price limit fields.
#'
#' @export
get_public_price_limit <- function(inst_id, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instId = inst_id)
  .gets$public_price_limit(query_string = query_string, config = config, tz = tz)
}
