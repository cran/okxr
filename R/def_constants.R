#' @importFrom rlang %||%
NULL

#' Set or get okxr options
#'
#' @description
#' Convenience wrapper to set global options for okxr, such as whether to
#' return raw data instead of parsed data.
#'
#' @param raw_data Logical. Whether functions should return raw data (default = FALSE).
#'   If `NULL`, the current value is left unchanged.
#' @param timeout Numeric. HTTP request timeout in seconds. If `NULL`, the
#'   current value is left unchanged.
#' @return An invisible named list with the current package options:
#'   `raw_data` (logical) and `timeout` (numeric seconds). This return value
#'   can be used to inspect the effective option state after updating it.
#'
#' @examples
#' old <- getOption("okxr.raw_data")
#' old_timeout <- getOption("okxr.timeout")
#' set_okxr_options(raw_data = TRUE)
#' set_okxr_options(timeout = 5)
#' options(okxr.raw_data = old, okxr.timeout = old_timeout)
#'
#' set_okxr_options()  # check current values
#' @export
set_okxr_options <- function(raw_data = NULL, timeout = NULL) {
  if (!is.null(raw_data)) {
    if (!is.logical(raw_data) || length(raw_data) != 1L)
      stop("`raw_data` must be a single TRUE or FALSE value.", call. = FALSE)

    options(okxr.raw_data = raw_data)
  }

  if (!is.null(timeout)) {
    if (!is.numeric(timeout) || length(timeout) != 1L || is.na(timeout) || timeout <= 0)
      stop("`timeout` must be a single positive number.", call. = FALSE)

    options(okxr.timeout = timeout)
  }

  invisible(list(
    raw_data = getOption("okxr.raw_data", FALSE),
    timeout = getOption("okxr.timeout", .okx_default_timeout)
  ))
}

#' Base URL for OKX API
#'
#' Canonical base URL used by all OKX REST requests in **okxr**.
#' Keep this as a single source of truth so higher-level request builders can
#' compose full URLs as `paste0(.okx_base_url, okx_path)`.
#'
#' @details
#' This package assumes the public production host. If you intend to support
#' alternative environments (e.g., sandbox), consider injecting a config value
#' at runtime rather than modifying this constant.
#'
#' @format A length-one character vector.
#' @seealso [`.api_GET_specs`], [`.api_POST_specs`]
#' @family okxr-internal
#' @note Since okxr 0.1.1
#' @keywords internal
#' @noRd
.okx_base_url <- "https://www.okx.com"

#----.API_POST_SPECS----

#' OKX POST endpoint specifications (internal)
#'
#' A named list describing how to call and parse selected **POST** endpoints.
#'
#' Each entry has:
#' - `okx_path` (character): REST path beginning with `/api/…`.
#' - `parser_schema` (`data.frame`): three columns
#'   - `okx`: field name as returned by OKX
#'   - `formal`: human-readable label
#'   - `type`: one of `"string"`, `"numeric"`, `"integer"`, `"time"`
#' - `parser_mode` (character): either `"named"` or `"positional"`.
#'
#' @section Parser modes:
#' - **named**: parse by JSON key (robust to column order).
#' - **positional**: parse by array position (used by endpoints returning
#'   vectors/arrays such as candles; order is critical).
#'
#' @section Included endpoints:
#' - `account_set_leverage`: `/api/v5/account/set-leverage`
#' - `trade_order`: `/api/v5/trade/order`
#' - `trade_cancel_order`: `/api/v5/trade/cancel-order`
#' - `trade_close_position`: `/api/v5/trade/close-position`
#'
#' @examples
#' # Access path for placing an order
#' .api_POST_specs$trade_order$okx_path
#'
#' # Inspect the expected fields for the cancel-order response
#' .api_POST_specs$trade_cancel_order$parser_schema
#'
#' @format A named list of endpoint specification lists.
#' @seealso [`.api_GET_specs`]
#' @family okxr-internal
#' @note Since okxr 0.1.1
#' @keywords internal
#' @noRd
.api_POST_specs <- list(
  
  #----account_set_leverage----
  account_set_leverage = list(
    okx_path     = "/api/v5/account/set-leverage",
    parser_schema       = data.frame(
      okx    = c("mgnMode", "instId", "posSide"),
      formal = c("Margin mode", "Instrument ID", "Position side"),
      type   = c("string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----trade_order----
  trade_order = list(
    okx_path     = "/api/v5/trade/order",
    parser_schema       = data.frame(
      okx    = c("ts", "ordId", "clOrdId", "sCode"),
      formal = c("Timestamp", "Order ID", "Client Order ID", "Code of the execution result"),
      type   = c("time", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----trade_cancel_order----
  trade_cancel_order = list(
    okx_path     = "/api/v5/trade/cancel-order",
    parser_schema       = data.frame(
      okx    = c("ts", "ordId", "clOrdId", "sCode"),
      formal = c("Timestamp", "Order ID", "Client Order ID", "Code of the execution result"),
      type   = c("time", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----trade_close_position----
  trade_close_position = list(
    okx_path     = "/api/v5/trade/close-position",
    parser_schema       = data.frame(
      okx    = c("instId", "posSide", "clOrdId", "tag"),
      formal = c("Instrument ID", "Position side", "Client Order ID", "Order tag"),
      type   = c("string", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  )
  
  
)

#----.API_GET_SPECS----

#' OKX POST endpoint specifications (internal)
#'
#' A named list describing how to call and parse selected **POST** endpoints.
#'
#' Each entry has:
#' - `okx_path` (character): REST path beginning with `/api/…`.
#' - `parser_schema` (`data.frame`): three columns
#'   - `okx`: field name as returned by OKX
#'   - `formal`: human-readable label
#'   - `type`: one of `"string"`, `"numeric"`, `"integer"`, `"time"`
#' - `parser_mode` (character): either `"named"` or `"positional"`.
#'
#' @section Parser modes:
#' - **named**: parse by JSON key (robust to column order).
#' - **positional**: parse by array position (used by endpoints returning
#'   vectors/arrays such as candles; order is critical).
#'
#' @section Included endpoints:
#' - `account_set_leverage`: `/api/v5/account/set-leverage`
#' - `trade_order`: `/api/v5/trade/order`
#' - `trade_cancel_order`: `/api/v5/trade/cancel-order`
#' - `trade_close_position`: `/api/v5/trade/close-position`
#'
#' @examples
#' # Access path for placing an order
#' .api_POST_specs$trade_order$okx_path
#'
#' # Inspect the expected fields for the cancel-order response
#' .api_POST_specs$trade_cancel_order$parser_schema
#'
#' @format A named list of endpoint specification lists.
#' @seealso [`.api_GET_specs`]
#' @family okxr-internal
#' @note Since okxr 0.1.1
#' @keywords internal
#' @noRd
.api_GET_specs <- list(
  
  #----trade_order----
  trade_order = list(
    okx_path     = "/api/v5/trade/order",
    parser_schema       = data.frame(
      okx    = c("cTime", "ordId", "clOrdId", "tag", "instId", "ordType", "px", "sz", "side", "posSide", "tdMode", "accFillSz", "fillPx", "fillSz", "fillTime", "avgPx", "state", "lever"),
      formal = c("Creation time", "Order ID", "Client Order ID", "Order tag", "Instrument ID", "Order type", "Price", "Quantity to buy or sell", "Order side", "Position side", "Trade mode", "Accumulated fill quantity", "Last filled price", "Last filled quantity", "Last filled time", "Average filled price", "State", "Leverage"),
      type   = c("time", "string", "string", "string", "string", "string", "numeric", "numeric", "string", "string", "string", "numeric", "numeric", "numeric", "time", "numeric", "string", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----trade_orders_pending----
  trade_orders_pending = list(
    okx_path     = "/api/v5/trade/orders-pending",
    parser_schema       = data.frame(
      okx    = c("cTime", "ordId", "clOrdId", "tag", "instId", "ordType", "px", "sz", "side", "posSide", "tdMode", "accFillSz", "fillPx", "fillSz", "fillTime", "avgPx", "state", "lever"),
      formal = c("Creation time", "Order ID", "Client Order ID", "Order tag", "Instrument ID", "Order type", "Price", "Quantity to buy or sell", "Order side", "Position side", "Trade mode", "Accumulated fill quantity", "Last filled price", "Last filled quantity", "Last filled time", "Average filled price", "State", "Leverage"),
      type   = c("time", "string", "string", "string", "string", "string", "numeric", "numeric", "string", "string", "string", "numeric", "numeric", "numeric", "time", "numeric", "string", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----trade_orders_history_7d----
  trade_orders_history_7d = list(
    okx_path     = "/api/v5/trade/orders-history",
    parser_schema       = data.frame(
      okx    = c("cTime", "ordId", "clOrdId", "tag", "instId", "ordType", "px", "sz", "side", "posSide", "tdMode", "accFillSz", "fillPx", "fillSz", "fillTime", "avgPx", "state", "lever"),
      formal = c("Creation time", "Order ID", "Client Order ID", "Order tag", "Instrument ID", "Order type", "Price", "Quantity to buy or sell", "Order side", "Position side", "Trade mode", "Accumulated fill quantity", "Last filled price", "Last filled quantity", "Last filled time", "Average filled price", "State", "Leverage"),
      type   = c("time", "string", "string", "string", "string", "string", "numeric", "numeric", "string", "string", "string", "numeric", "numeric", "numeric", "time", "numeric", "string", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----trade_fills----
  trade_fills = list(
    okx_path     = "/api/v5/trade/fills",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("instType", "instId", "tradeId", "ordId", "clOrdId", "billId", "subType", "tag", "fillPx", "fillSz", "fillIdxPx", "fillPnl", "fillPxVol", "fillPxUsd", "fee", "feeCcy", "ts"),
      formal = c("Instrument type", "Instrument ID", "Trade ID", "Order ID", "Client Order ID", "Bill ID", "Transaction type", "Order tag", "Filled price", "Filled size", "Index price at fill", "Filled profit and loss", "Filled implied volatility", "Filled option price in USD", "Fee", "Fee currency", "Trade time"),
      type   = c("string", "string", "string", "string", "string", "string", "string", "string", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "string", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----trade_fills_history----
  trade_fills_history = list(
    okx_path     = "/api/v5/trade/fills-history",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("instType", "instId", "tradeId", "ordId", "clOrdId", "billId", "subType", "tag", "fillPx", "fillSz", "fillIdxPx", "fillPnl", "fillPxVol", "fillPxUsd", "fee", "feeCcy", "ts"),
      formal = c("Instrument type", "Instrument ID", "Trade ID", "Order ID", "Client Order ID", "Bill ID", "Transaction type", "Order tag", "Filled price", "Filled size", "Index price at fill", "Filled profit and loss", "Filled implied volatility", "Filled option price in USD", "Fee", "Fee currency", "Trade time"),
      type   = c("string", "string", "string", "string", "string", "string", "string", "string", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "string", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----copy_trade_settings----
  copy_trade_settings = list(
    okx_path     = "/api/v5/copytrading/copy-settings",
    parser_schema       = data.frame(
      okx    = c("copyMode", "copyState"),
      formal = c("Copy mode", "Current copy state"),
      type   = c("string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----copy_trade_my_leaders----
  copy_trade_my_leaders = list(
    okx_path     = "/api/v5/copytrading/current-lead-traders",
    parser_schema       = data.frame(
      okx    = c("nickName", "uniqueCode"),
      formal = c("Nick name", "Lead trader unique code"),
      type   = c("string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----copy_trade_current_subpos----
  copy_trade_current_subpos = list(
    okx_path     = "/api/v5/copytrading/current-subpositions",
    parser_schema       = data.frame(
      okx    = c("instId", "uniqueCode"),
      formal = c("Instrument ID", "Lead trader unique code"),
      type   = c("string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----copy_trade_historical_subpos----
  copy_trade_historical_subpos = list(
    okx_path     = "/api/v5/copytrading/subpositions-history",
    parser_schema       = data.frame(
      okx    = c("instId", "uniqueCode"),
      formal = c("Instrument ID", "Lead trader unique code"),
      type   = c("string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----asset_balances----
  asset_balances = list(
    okx_path     = "/api/v5/asset/balances",
    parser_schema       = data.frame(
      okx    = c("bal", "availBal", "frozenBal", "ccy"),
      formal = c("Balance", "Available", "Frozen", "Currency"),
      type   = c("numeric", "numeric", "numeric", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----asset_deposit_history----
  asset_deposit_history = list(
    okx_path     = "/api/v5/asset/deposit-history",
    parser_schema       = data.frame(
      okx    = c("ts", "amt", "ccy"),
      formal = c("Timestamp", "Amount", "Currency"),
      type   = c("time", "numeric", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----asset_withdrawal_history----
  asset_withdrawal_history = list(
    okx_path     = "/api/v5/asset/withdrawal-history",
    parser_schema       = data.frame(
      okx    = c("ts", "amt", "ccy"),
      formal = c("Timestamp", "Amount", "Currency"),
      type   = c("time", "numeric", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----asset_currencies----
  asset_currencies = list(
    okx_path     = "/api/v5/asset/currencies",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("ccy", "name", "chain", "ctAddr", "canDep", "canWd", "canInternal", "minDep", "minWd", "maxWd", "wdTickSz", "depEstOpenTime", "wdEstOpenTime"),
      formal = c("Currency", "Currency name", "Chain", "Contract address", "Deposit available", "Withdrawal available", "Internal transfer available", "Minimum deposit", "Minimum withdrawal", "Maximum withdrawal", "Withdrawal tick size", "Estimated deposit open time", "Estimated withdrawal open time"),
      type   = c("string", "string", "string", "string", "logical", "logical", "logical", "numeric", "numeric", "numeric", "numeric", "time", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----asset_deposit_address----
  asset_deposit_address = list(
    okx_path     = "/api/v5/asset/deposit-address",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("ccy", "chain", "addr", "selected", "to", "memo", "tag", "pmtId", "addrEx"),
      formal = c("Currency", "Chain", "Deposit address", "Selected address", "Address owner", "Memo", "Tag", "Payment ID", "Address extension"),
      type   = c("string", "string", "string", "logical", "string", "string", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----account_balance----
  account_balance = list(
    okx_path     = "/api/v5/account/balance",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("uTime", "totalEq", "isoEq", "adjEq", "availEq", "ordFroz", "imr", "mmr", "borrowFroz", "mgnRatio", "notionalUsd", "notionalUsdForBorrow", "notionalUsdForSwap", "notionalUsdForFutures", "notionalUsdForOption", "upl"),
      formal = c("Update time", "Total equity", "Isolated margin equity", "Adjusted / Effective equity", "Account level available equity", "Cross margin frozen for pending orders", "Initial margin requirement", "Maintenance margin requirement", "Potential borrowing IMR of the account", "Maintenance margin ratio", "Notional value of positions", "Notional value for Borrow", "Notional value of positions for Perpetual Futures", "Notional value of positions for Expiry Futures", "Notional value of positions for Option", "Cross-margin info of unrealized profit and loss at the account level"),
      type   = c("time", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----account_positions----
  account_positions = list(
    okx_path     = "/api/v5/account/positions",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("cTime", "uTime", "instId", "lever", "posId", "posSide", "pos", "imr", "mmr", "avgPx", "markPx", "upl", "realizedPnl", "settledPnl", "pnl", "fee", "fundingFee", "liqPenalty"),
      formal = c("Creation time", "Update time", "Instrument ID", "Leverage", "Position ID", "Position side", "Quantity of positions", "Initial margin requirement", "Maintenance margin requirement", "Average open price", "Latest Mark price", "Unrealized profit and loss", "Realized profit and loss", "Accumulated settled profit and loss", "Accumulated pnl of closing order(s)", "Accumulated fee", "Accumulated funding fee", "	Accumulated liquidation penalty"),
      type   = c("time", "time", "string", "numeric", "string", "string", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----account_positions_history----
  account_positions_history = list(
    okx_path     = "/api/v5/account/positions-history",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("cTime", "uTime", "instId", "lever", "posId", "posSide", "pos", "realizedPnl", "fee"),
      formal = c("Creation time", "Update time", "Instrument ID", "Leverage", "Position ID", "Position side", "Quantity of positions", "Realized profit and loss", "Accumulated fee"),
      type   = c("time", "time", "string", "numeric", "string", "string", "numeric", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----account_config----
  account_config = list(
    okx_path     = "/api/v5/account/config",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("uid", "mainUid", "acctLv", "posMode", "autoLoan"),
      formal = c("Account ID", "Main Account ID", "Account mode", "Position mode", "Whether to borrow coins automatically"),
      type   = c("string", "string", "string", "string", "logical"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----account_leverage_info----
  account_leverage_info = list(
    okx_path     = "/api/v5/account/leverage-info",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("instId", "mgnMode", "posSide", "lever"),
      formal = c("Instrument ID", "Margin mode", "Position side", "Leverage"),
      type   = c("string", "string", "string", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_bills----
  account_bills = list(
    okx_path     = "/api/v5/account/bills",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("billId", "instType", "instId", "ccy", "mgnMode", "type", "subType", "bal", "balChg", "posBal", "posBalChg", "sz", "px", "fee", "pnl", "ordId", "from", "to", "ts"),
      formal = c("Bill ID", "Instrument type", "Instrument ID", "Currency", "Margin mode", "Bill type", "Bill subtype", "Balance", "Balance change", "Position balance", "Position balance change", "Quantity", "Price", "Fee", "Profit and loss", "Order ID", "Transfer from", "Transfer to", "Bill time"),
      type   = c("string", "string", "string", "string", "string", "string", "string", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "string", "string", "string", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_bills_archive----
  account_bills_archive = list(
    okx_path     = "/api/v5/account/bills-archive",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("billId", "instType", "instId", "ccy", "mgnMode", "type", "subType", "bal", "balChg", "posBal", "posBalChg", "sz", "px", "fee", "pnl", "ordId", "from", "to", "ts"),
      formal = c("Bill ID", "Instrument type", "Instrument ID", "Currency", "Margin mode", "Bill type", "Bill subtype", "Balance", "Balance change", "Position balance", "Position balance change", "Quantity", "Price", "Fee", "Profit and loss", "Order ID", "Transfer from", "Transfer to", "Bill time"),
      type   = c("string", "string", "string", "string", "string", "string", "string", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "string", "string", "string", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----market_ticker----
  market_ticker = list(
    okx_path     = "/api/v5/market/ticker",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("instType", "instId", "last", "askPx", "bidPx", "ts"),
      formal = c("Instrument type", "Instrument ID", "Last traded price", "Best ask price", "Best bid price", "Ticker data generation time"),
      type   = c("string", "string", "numeric", "numeric", "numeric", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----market_tickers----
  market_tickers = list(
    okx_path     = "/api/v5/market/tickers",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("instType", "instId", "last", "lastSz", "askPx", "askSz", "bidPx", "bidSz", "open24h", "high24h", "low24h", "volCcy24h", "vol24h", "sodUtc0", "sodUtc8", "ts"),
      formal = c("Instrument type", "Instrument ID", "Last traded price", "Last traded size", "Best ask price", "Best ask size", "Best bid price", "Best bid size", "Open price in past 24 hours", "Highest price in past 24 hours", "Lowest price in past 24 hours", "24h volume in currency", "24h volume", "UTC 0 open price", "UTC 8 open price", "Ticker data generation time"),
      type   = c("string", "string", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----market_books----
  market_books = list(
    okx_path     = "/api/v5/market/books",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("asks", "bids", "ts"),
      formal = c("Ask levels", "Bid levels", "Order book generation time"),
      type   = c("string", "string", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----market_trades----
  market_trades = list(
    okx_path     = "/api/v5/market/trades",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("instId", "tradeId", "px", "sz", "side", "source", "ts"),
      formal = c("Instrument ID", "Trade ID", "Trade price", "Trade quantity", "Taker side", "Order source", "Trade time"),
      type   = c("string", "string", "numeric", "numeric", "string", "string", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----market_history_trades----
  market_history_trades = list(
    okx_path     = "/api/v5/market/history-trades",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("instId", "tradeId", "px", "sz", "side", "source", "ts"),
      formal = c("Instrument ID", "Trade ID", "Trade price", "Trade quantity", "Taker side", "Order source", "Trade time"),
      type   = c("string", "string", "numeric", "numeric", "string", "string", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----market_candles----
  market_candles = list(
    okx_path     = "/api/v5/market/candles",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("ts", "o", "h", "l", "c", "vol", "volCcy", "volCcyQuote", "confirm"),
      formal = c("Timestamp", "Open price", "Highest price", "Lowest price", "Close price", "Trading volume (contract)", "Trading volume (currency)", "Trading volume (quote currency)", "The state of candlesticks"),
      type   = c("time", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "integer"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "positional"
  ),
  
  #----market_history_candles----
  market_history_candles = list(
    okx_path     = "/api/v5/market/history-candles",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("ts", "o", "h", "l", "c", "vol", "volCcy", "volCcyQuote", "confirm"),
      formal = c("Timestamp", "Open price", "Highest price", "Lowest price", "Close price", "Trading volume (contract)", "Trading volume (currency)", "Trading volume (quote currency)", "The state of candlesticks"),
      type   = c("time", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "integer"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "positional"
  ),
  
  #----public_instruments----
  public_instruments = list(
    okx_path = "/api/v5/public/instruments",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instType", "instId", "uly", "instFamily", "baseCcy", "quoteCcy", "settleCcy", "ctVal", "ctMult", "ctValCcy", "listTime", "openType", "expTime", "lever", "tickSz", "lotSz", "minSz", "ctType", "state"),
      formal = c("Instrument type", "Instrument ID", "Underlying", "Instrument family", "Base currency", "Quote currency", "Settlement and margin currency", "Contract value", "Contract multiplier", "Contract value currency", "Listing time", "Open type", "Expiry time", "Max Leverage", "Tick size", "Lot size", "Minimum order size", "Contract type", "Instrument status"),
      type   = c("string", "string", "string", "string", "string", "string", "string", "numeric", "numeric", "numeric", "time", "string", "time", "numeric", "numeric", "numeric", "numeric", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_mark_price----
  public_mark_price = list(
    okx_path = "/api/v5/public/mark-price",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("ts", "instId", "markPx"),
      formal = c("Timestamp", "Instrument ID", "Price"),
      type   = c("time", "string", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----public_funding_rate----
  public_funding_rate = list(
    okx_path = "/api/v5/public/funding-rate",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instId", "formulaType", "fundingRate", "fundingTime", "nextFundingTime", "minFundingRate", "maxFundingRate", "interestRate", "impactValue", "premium", "ts"),
      formal = c("Instrument ID", "Formula type", "Current funding rate", "Settlement time", "Forecasted funding time for the next period", "The lower limit of the funding rate", "The upper limit of the funding rate", "Interest rate", "Depth weighted amount", "Premium index", "Data return time"),
      type   = c("string", "string", "numeric", "time", "time", "numeric", "numeric", "numeric", "numeric", "numeric", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----public_funding_rate_history----
  public_funding_rate_history = list(
    okx_path = "/api/v5/public/funding-rate-history",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instId", "formulaType", "fundingRate", "realizedRate", "fundingTime", "method"),
      formal = c("Instrument ID", "Formula type", "Predicted funding rate", "Actual funding rate", "Settlement time", "Funding rate mechanism"),
      type   = c("string", "string", "numeric", "numeric", "time", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----public_open_interest----
  public_open_interest = list(
    okx_path = "/api/v5/public/open-interest",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instId", "oi", "oiCcy", "oiUsd", "ts"),
      formal = c("Instrument ID", "Open interest in number of contracts", "Open interest in number of coin", "Open interest in number of USD", "Data return time"),
      type   = c("string", "numeric", "numeric", "numeric", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_time----
  public_time = list(
    okx_path = "/api/v5/public/time",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("ts"),
      formal = c("System time"),
      type   = c("time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_price_limit----
  public_price_limit = list(
    okx_path = "/api/v5/public/price-limit",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instId", "buyLmt", "sellLmt", "ts"),
      formal = c("Instrument ID", "Highest buy price", "Lowest sell price", "Data return time"),
      type   = c("string", "numeric", "numeric", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  )
)

.public_GET_spec_names <- c(
  "market_ticker",
  "market_tickers",
  "market_books",
  "market_trades",
  "market_history_trades",
  "market_candles",
  "market_history_candles",
  "public_instruments",
  "public_mark_price",
  "public_funding_rate",
  "public_funding_rate_history",
  "public_open_interest",
  "public_time",
  "public_price_limit"
)

.api_GET_specs[.public_GET_spec_names] <- lapply(
  .api_GET_specs[.public_GET_spec_names],
  function(api) {
    api$auth <- FALSE
    api
  }
)
