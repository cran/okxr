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
#' converted to milliseconds since epoch (in `tz`) and sent as `after=...`
#' (per OKX semantics: *return data before this time*).
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT"`.
#' @param bar Character. Candlestick granularity, e.g. `"1m"`, `"5m"`, `"1H"`.
#' @param before Character or `NULL`. Timestamp string like
#'   `"\%Y-\%m-\%d \%H:\%M:\%S"`. If `NULL`, fetch recent history.
#' @param limit Integer. Number of bars to retrieve. Default `100L`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#' @param standardize_names Logical. If `TRUE` (default), renames columns to
#'   `timestamp`, `open`, `high`, `low`, `close`, `volume`, `volQuote`.
#'
#' @return
#' A `data.frame` of candlestick bars. If `standardize_names = TRUE`,
#' column names are normalized. Timestamps are `POSIXct` in `tz`.
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
get_market_books <- function(
  inst_id,
  sz = NULL,
  config = NULL,
  tz = .okx_default_tz
) {
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
get_market_trades <- function(
  inst_id,
  limit = NULL,
  config = NULL,
  tz = .okx_default_tz
) {
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

#' Get mark price candles
#'
#' Retrieve recent candlestick data for the mark price of an instrument.
#'
#' @param inst_id Character. Instrument ID.
#' @param bar Character or `NULL`. Bar size.
#' @param after Character or `NULL`. Pagination cursor for older rows.
#' @param before Character or `NULL`. Pagination cursor for newer rows.
#' @param limit Integer. Number of rows to request. Default `100L`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#' @param standardize_names Logical. If `TRUE` (default), renames OHLC columns
#'   to `timestamp`, `open`, `high`, `low`, and `close`.
#'
#' @return A `data.frame` of mark-price candlesticks.
#'
#' @export
get_market_mark_price_candles <- function(inst_id, bar = NULL, after = NULL, before = NULL, limit = 100L, config = NULL, tz = .okx_default_tz, standardize_names = TRUE) {
  query_string <- .okx_build_query(
    instId = inst_id,
    after = after,
    before = before,
    bar = bar,
    limit = as.integer(limit)
  )
  df <- .gets$market_mark_price_candles(query_string = query_string, config = config, tz = tz)
  if (standardize_names) return(.okx_standardize_ohlcv_names(df))
  df
}

#' Get historical mark price candles
#'
#' Retrieve historical candlestick data for mark price.
#'
#' @inheritParams get_market_mark_price_candles
#'
#' @return A `data.frame` of historical mark-price candlesticks.
#'
#' @export
get_market_history_mark_price_candles <- function(inst_id, bar = NULL, after = NULL, before = NULL, limit = 100L, config = NULL, tz = .okx_default_tz, standardize_names = TRUE) {
  query_string <- .okx_build_query(
    instId = inst_id,
    after = after,
    before = before,
    bar = bar,
    limit = as.integer(limit)
  )
  df <- .gets$market_history_mark_price_candles(query_string = query_string, config = config, tz = tz)
  if (standardize_names) return(.okx_standardize_ohlcv_names(df))
  df
}

#' Get exchange rate
#'
#' Retrieve the two-week average exchange rate series summary.
#'
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A one-row `data.frame` with `usdCny`.
#'
#' @export
get_market_exchange_rate <- function(config = NULL, tz = .okx_default_tz) {
  .gets$market_exchange_rate(query_string = "", config = config, tz = tz)
}

#' Get index components
#'
#' Retrieve component-exchange information for an index.
#'
#' @param index Character. Index identifier, e.g. `"BTC-USD"`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A one-row `data.frame` with `index`, `last`, `ts`, and JSON-encoded
#'   `components`.
#'
#' @export
get_market_index_components <- function(
  index,
  config = NULL,
  tz = .okx_default_tz
) {
  query_string <- .okx_build_query(index = index)
  .gets$market_index_components(query_string = query_string, config = config, tz = tz)
}

#' Get platform 24-hour volume
#'
#' Retrieve total platform order-book trading volume over the last 24 hours.
#'
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A one-row `data.frame` with `volUsd`, `volCny`, and `ts`.
#'
#' @export
get_market_platform_24_volume <- function(
  config = NULL,
  tz = .okx_default_tz
) {
  .gets$market_platform_24_volume(query_string = "", config = config, tz = tz)
}

#' Get block ticker
#'
#' Retrieve the latest 24-hour block-trading volume for a single instrument.
#'
#' @param inst_id Character. Instrument ID.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A one-row `data.frame` with block trading volume fields.
#'
#' @export
get_market_block_ticker <- function(
  inst_id,
  config = NULL,
  tz = .okx_default_tz
) {
  query_string <- .okx_build_query(instId = inst_id)
  .gets$market_block_ticker(query_string = query_string, config = config, tz = tz)
}

#' Get block tickers
#'
#' Retrieve the latest 24-hour block-trading volume for instruments under an
#' instrument type.
#'
#' @param inst_type Character. Instrument type.
#' @param inst_family Character or `NULL`. Instrument family filter.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with one row per block ticker.
#'
#' @export
get_market_block_tickers <- function(inst_type, inst_family = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    instFamily = inst_family
  )
  .gets$market_block_tickers(query_string = query_string, config = config, tz = tz)
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
#' `minSz`, `expTime`, `lever`, `state`, ...).
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
#' @note Since okxr 0.1.2
#' @export
get_public_instruments <- function(inst_id = NULL, inst_type = "SWAP", config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instType = inst_type, instId = inst_id)
  .gets$public_instruments(query_string = query_string, config = config, tz = tz)
}

#' Get underlying list
#'
#' Retrieve available underlyings for derivatives instruments.
#'
#' @param inst_type Character. Instrument type: `"SWAP"`, `"FUTURES"`, or
#'   `"OPTION"`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Unused except for interface consistency.
#'
#' @return A one-column `data.frame` with `uly`.
#'
#' @export
get_public_underlying <- function(
  inst_type,
  config = NULL,
  tz = .okx_default_tz
) {
  query_string <- .okx_build_query(instType = inst_type)
  .gets$public_underlying(query_string = query_string, config = config, tz = tz)
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
get_public_funding_rate <- function(
  inst_id,
  config = NULL,
  tz = .okx_default_tz
) {
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
get_public_price_limit <- function(
  inst_id,
  config = NULL,
  tz = .okx_default_tz
) {
  query_string <- .okx_build_query(instId = inst_id)
  .gets$public_price_limit(query_string = query_string, config = config, tz = tz)
}

#' Get estimated delivery or exercise price
#'
#' Retrieve the estimated delivery, exercise, or settlement price for
#' derivatives and events instruments.
#'
#' @param inst_type Character. Instrument type, such as `"FUTURES"`, `"OPTION"`,
#'   `"SWAP"`, or `"EVENTS"`.
#' @param inst_family Character or `NULL`. Instrument family filter.
#' @param inst_id Character or `NULL`. Specific instrument ID filter.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with `instType`, `instId`, `settlePx`, and `ts`.
#'
#' @export
get_public_estimated_price <- function(inst_type, inst_family = NULL, inst_id = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    instFamily = inst_family,
    instId = inst_id
  )
  .gets$public_estimated_price(query_string = query_string, config = config, tz = tz)
}

#' Get delivery or exercise history
#'
#' Retrieve futures delivery records or option exercise records.
#'
#' @param inst_type Character. `"FUTURES"` or `"OPTION"`.
#' @param inst_family Character. Instrument family.
#' @param after Character or `NULL`. Pagination cursor for older rows.
#' @param before Character or `NULL`. Pagination cursor for newer rows.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with `ts` and JSON-encoded `details`.
#'
#' @export
get_public_delivery_exercise_history <- function(inst_type, inst_family, after = NULL, before = NULL, limit = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    instFamily = inst_family,
    after = after,
    before = before,
    limit = limit
  )
  .gets$public_delivery_exercise_history(query_string = query_string, config = config, tz = tz)
}

#' Get estimated settlement info
#'
#' Retrieve the estimated settlement price for a futures instrument close to
#' settlement.
#'
#' @param inst_id Character. Instrument ID.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with `instId`, `nextSettleTime`, `estSettlePx`, and `ts`.
#'
#' @export
get_public_estimated_settlement_info <- function(inst_id, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instId = inst_id)
  .gets$public_estimated_settlement_info(query_string = query_string, config = config, tz = tz)
}

#' Get settlement history
#'
#' Retrieve futures settlement history for an instrument family.
#'
#' @param inst_family Character. Instrument family.
#' @param after Character or `NULL`. Pagination cursor for older rows.
#' @param before Character or `NULL`. Pagination cursor for newer rows.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with `ts` and JSON-encoded `details`.
#'
#' @export
get_public_settlement_history <- function(inst_family, after = NULL, before = NULL, limit = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instFamily = inst_family,
    after = after,
    before = before,
    limit = limit
  )
  .gets$public_settlement_history(query_string = query_string, config = config, tz = tz)
}

#' Get collateral discount rate and interest-free quota
#'
#' Retrieve public collateral discount-rate tiers and interest-free quota
#' information for supported currencies.
#'
#' @param ccy Character or `NULL`. Currency filter, e.g. `"BTC"`.
#' @param discount_lv Character or `NULL`. Discount level filter.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with top-level discount and interest-free quota
#'   fields; nested tier details are JSON-encoded in `details`.
#'
#' @export
get_public_discount_rate_interest_free_quota <- function(ccy = NULL, discount_lv = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    ccy = ccy,
    discountLv = discount_lv
  )
  .gets$public_discount_rate_interest_free_quota(query_string = query_string, config = config, tz = tz)
}

#' Get option summary
#'
#' Retrieve option market summary data for an instrument family.
#'
#' @param inst_family Character. Option instrument family.
#' @param exp_time Character or `NULL`. Expiry date in `YYMMDD`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with option greeks, volatility, forward price, and
#'   timestamp fields.
#'
#' @export
get_public_opt_summary <- function(inst_family, exp_time = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instFamily = inst_family,
    expTime = exp_time
  )
  .gets$public_opt_summary(query_string = query_string, config = config, tz = tz)
}

#' Get public position tiers
#'
#' Retrieve public tier, margin, and maximum leverage information.
#'
#' @param inst_type Character. Instrument type.
#' @param td_mode Character. Trade mode.
#' @param inst_family Character or `NULL`. Instrument family.
#' @param inst_id Character or `NULL`. Instrument ID(s).
#' @param ccy Character or `NULL`. Margin currency.
#' @param tier Character or `NULL`. Tier filter.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with public position tier information.
#'
#' @export
get_public_position_tiers <- function(inst_type, td_mode, inst_family = NULL, inst_id = NULL, ccy = NULL, tier = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    tdMode = td_mode,
    instFamily = inst_family,
    instId = inst_id,
    ccy = ccy,
    tier = tier
  )
  .gets$public_position_tiers(query_string = query_string, config = config, tz = tz)
}

#' Get economic calendar
#'
#' Retrieve macro-economic calendar records. OKX requires authentication for
#' this endpoint.
#'
#' @param region Character or `NULL`. Region filter.
#' @param importance Character or `NULL`. Importance level filter.
#' @param before Character or `NULL`. Pagination cursor for newer rows.
#' @param after Character or `NULL`. Pagination cursor for older rows.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with calendar event fields and timestamps.
#'
#' @export
get_public_economic_calendar <- function(region = NULL, importance = NULL, before = NULL, after = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    region = region,
    importance = importance,
    before = before,
    after = after,
    limit = limit
  )
  .gets$public_economic_calendar(query_string = query_string, config = config, tz = tz)
}

#' Get interest rate and loan quota
#'
#' Retrieve public borrowing-rate and loan-quota tables.
#'
#' @param ccy Character or `NULL`. Currency filter.
#' @param vip_level Character or `NULL`. VIP level filter when supported by OKX.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` where nested basic, VIP, regular, and custom quota
#'   tables are JSON-encoded string columns.
#'
#' @export
get_public_interest_rate_loan_quota <- function(ccy = NULL, vip_level = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    ccy = ccy,
    vipLevel = vip_level
  )
  .gets$public_interest_rate_loan_quota(query_string = query_string, config = config, tz = tz)
}

#' Get security fund balance information
#'
#' Retrieve public insurance-fund or security-fund balance information.
#'
#' @param inst_type Character. Instrument type, such as `"MARGIN"`, `"SWAP"`,
#'   `"FUTURES"`, or `"OPTION"`.
#' @param type Character or `NULL`. Fund update type filter.
#' @param inst_family Character or `NULL`. Instrument family filter for
#'   derivatives.
#' @param ccy Character or `NULL`. Currency filter for margin data.
#' @param before Character or `NULL`. Pagination cursor for newer rows.
#' @param after Character or `NULL`. Pagination cursor for older rows.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with top-level fund totals; nested per-currency detail
#'   rows are JSON-encoded in `details`.
#'
#' @export
get_public_insurance_fund <- function(inst_type, type = NULL, inst_family = NULL, ccy = NULL, before = NULL, after = NULL, limit = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    type = type,
    instFamily = inst_family,
    ccy = ccy,
    before = before,
    after = after,
    limit = limit
  )
  .gets$public_insurance_fund(query_string = query_string, config = config, tz = tz)
}

#' Convert between contract size and currency amount
#'
#' Convert the crypto value to the number of contracts, or vice versa.
#'
#' @param inst_id Character. Instrument ID.
#' @param sz Character or numeric. Quantity to convert.
#' @param type Character or `NULL`. Convert type: `"1"` for currency to
#'   contract, `"2"` for contract to currency.
#' @param px Character, numeric, or `NULL`. Optional order price.
#' @param unit Character or `NULL`. Currency unit, `"coin"` or `"usds"`.
#' @param op_type Character or `NULL`. Order type for futures or swaps, such as
#'   `"open"` or `"close"`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with conversion result fields `type`, `instId`, `px`,
#'   `sz`, and `unit`.
#'
#' @export
get_public_convert_contract_coin <- function(inst_id, sz, type = NULL, px = NULL, unit = NULL, op_type = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    type = type,
    instId = inst_id,
    sz = sz,
    px = px,
    unit = unit,
    opType = op_type
  )
  .gets$public_convert_contract_coin(query_string = query_string, config = config, tz = tz)
}

#' Get option instrument tick bands
#'
#' Retrieve option tick-band information for one or more option instrument
#' families.
#'
#' @param inst_type Character. Instrument type. Currently `"OPTION"`.
#' @param inst_family Character or `NULL`. Instrument family filter.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with `instType`, `instFamily`, and JSON-encoded
#'   `tickBand` details.
#'
#' @export
get_public_instrument_tick_bands <- function(inst_type = "OPTION", inst_family = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    instFamily = inst_family
  )
  .gets$public_instrument_tick_bands(query_string = query_string, config = config, tz = tz)
}

#' Get premium history
#'
#' Retrieve premium-index history for an instrument.
#'
#' @param inst_id Character. Instrument ID.
#' @param after Character or `NULL`. Pagination cursor for older rows.
#' @param before Character or `NULL`. Pagination cursor for newer rows.
#' @param bar Character or `NULL`. Bar size such as `"1m"` or `"1H"`.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with `instId`, `premium`, and `ts`.
#'
#' @export
get_public_premium_history <- function(inst_id, after = NULL, before = NULL, bar = NULL, limit = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instId = inst_id,
    after = after,
    before = before,
    bar = bar,
    limit = limit
  )
  .gets$public_premium_history(query_string = query_string, config = config, tz = tz)
}

#' Get public block trades
#'
#' Retrieve recent single-leg public block trades for an instrument.
#'
#' @param inst_id Character. Instrument ID.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with block trade fields such as price, size, trade
#'   side, volatility, and timestamps.
#'
#' @export
get_public_block_trades <- function(
  inst_id,
  config = NULL,
  tz = .okx_default_tz
) {
  query_string <- .okx_build_query(instId = inst_id)
  .gets$public_block_trades(query_string = query_string, config = config, tz = tz)
}

#' Get index tickers
#'
#' Retrieve the latest public index-price snapshots.
#'
#' @param quote_ccy Character or `NULL`. Quote currency filter.
#' @param inst_id Character or `NULL`. Specific index ID filter.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with one row per index ticker.
#'
#' @export
get_market_index_tickers <- function(quote_ccy = NULL, inst_id = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    quoteCcy = quote_ccy,
    instId = inst_id
  )
  .gets$market_index_tickers(query_string = query_string, config = config, tz = tz)
}

#' Get recent index candles
#'
#' Retrieve the latest candlestick data for an index.
#'
#' @param inst_id Character. Index ID.
#' @param bar Character or `NULL`. Bar size.
#' @param after Character or `NULL`. Pagination cursor for older rows.
#' @param before Character or `NULL`. Pagination cursor for newer rows.
#' @param limit Integer. Number of rows to request. Default `100L`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#' @param standardize_names Logical. If `TRUE` (default), renames OHLC columns
#'   to `timestamp`, `open`, `high`, `low`, and `close`.
#'
#' @return A `data.frame` of index candlesticks.
#'
#' @export
get_market_index_candles <- function(inst_id, bar = NULL, after = NULL, before = NULL, limit = 100L, config = NULL, tz = .okx_default_tz, standardize_names = TRUE) {
  query_string <- .okx_build_query(
    instId = inst_id,
    after = after,
    before = before,
    bar = bar,
    limit = as.integer(limit)
  )
  df <- .gets$market_index_candles(query_string = query_string, config = config, tz = tz)
  if (standardize_names) return(.okx_standardize_ohlcv_names(df))
  df
}

#' Get historical index candles
#'
#' Retrieve historical candlestick data for an index.
#'
#' @param inst_id Character. Index ID.
#' @param bar Character or `NULL`. Bar size.
#' @param after Character or `NULL`. Pagination cursor for older rows.
#' @param before Character or `NULL`. Pagination cursor for newer rows.
#' @param limit Integer. Number of rows to request. Default `100L`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#' @param standardize_names Logical. If `TRUE` (default), renames OHLC columns
#'   to `timestamp`, `open`, `high`, `low`, and `close`.
#'
#' @return A `data.frame` of historical index candlesticks.
#'
#' @export
get_market_history_index_candles <- function(inst_id, bar = NULL, after = NULL, before = NULL, limit = 100L, config = NULL, tz = .okx_default_tz, standardize_names = TRUE) {
  query_string <- .okx_build_query(
    instId = inst_id,
    after = after,
    before = before,
    bar = bar,
    limit = as.integer(limit)
  )
  df <- .gets$market_history_index_candles(query_string = query_string, config = config, tz = tz)
  if (standardize_names) return(.okx_standardize_ohlcv_names(df))
  df
}

#' Get option trades by instrument family
#'
#' Retrieve recent option trades for all instruments under the same instrument
#' family.
#'
#' @param inst_family Character. Instrument family, e.g. `"BTC-USD"`.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with recent option trades under the requested
#'   instrument family, including `instId`, `tradeId`, `px`, `sz`, `side`, and
#'   `ts`.
#'
#' @export
get_market_option_instrument_family_trades <- function(inst_family, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instFamily = inst_family)
  .gets$market_option_instrument_family_trades(query_string = query_string, config = config, tz = tz)
}

#' Get public option trades
#'
#' Retrieve recent public option trades filtered by instrument ID or instrument
#' family.
#'
#' @param inst_id Character or `NULL`. Specific option instrument ID.
#' @param inst_family Character or `NULL`. Option instrument family, e.g.
#'   `"BTC-USD"`. Either `inst_id` or `inst_family` should be supplied.
#' @param opt_type Character or `NULL`. Option type filter: `"C"` for call or
#'   `"P"` for put.
#' @param config Optional list. Public endpoint request options, such as
#'   `timeout`; credentials are not required.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with recent option trade rows, including option
#'   instrument identifiers, trade price and size, option side/type, forward,
#'   index and mark prices, implied volatility, and trade time.
#'
#' @export
get_public_option_trades <- function(inst_id = NULL, inst_family = NULL, opt_type = NULL, config = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instId = inst_id,
    instFamily = inst_family,
    optType = opt_type
  )
  .gets$public_option_trades(query_string = query_string, config = config, tz = tz)
}
