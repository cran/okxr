#' @importFrom rlang %||%
NULL

#' Set or get okxr options
#'
#' @description
#' Convenience wrapper to set global options for okxr, such as whether to
#' return raw data instead of parsed data.
#'
#' @param raw_data Logical. If `TRUE`, return raw API `data`.
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
#' - `okx_path` (character): REST path beginning with `/api/...`.
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
.trade_cancel_response_schema <- data.frame(
  okx    = c("ts", "ordId", "clOrdId", "sCode", "sMsg"),
  formal = c("Timestamp", "Order ID", "Client Order ID", "Code of the execution result", "Execution message"),
  type   = c("time", "string", "string", "string", "string"),
  stringsAsFactors = FALSE
)

.trade_amend_response_schema <- data.frame(
  okx    = c("ts", "ordId", "clOrdId", "reqId", "sCode", "sMsg", "subCode"),
  formal = c("Timestamp", "Order ID", "Client Order ID", "Client request ID", "Code of the execution result", "Execution message", "Execution sub-code"),
  type   = c("time", "string", "string", "string", "string", "string", "string"),
  stringsAsFactors = FALSE
)

.trade_algo_cancel_response_schema <- data.frame(
  okx    = c("algoId", "algoClOrdId", "clOrdId", "sCode", "sMsg", "tag"),
  formal = c("Algo ID", "Client-supplied Algo ID", "Client Order ID", "Code of the execution result", "Execution message", "Order tag"),
  type   = c("string", "string", "string", "string", "string", "string"),
  stringsAsFactors = FALSE
)

.trade_algo_amend_response_schema <- data.frame(
  okx    = c("algoId", "algoClOrdId", "reqId", "sCode", "sMsg"),
  formal = c("Algo ID", "Client-supplied Algo ID", "Client request ID", "Code of the execution result", "Execution message"),
  type   = c("string", "string", "string", "string", "string"),
  stringsAsFactors = FALSE
)

.account_position_mode_schema <- data.frame(
  okx    = c("posMode"),
  formal = c("Position mode"),
  type   = c("string"),
  stringsAsFactors = FALSE
)

.account_fee_type_schema <- data.frame(
  okx    = c("feeType"),
  formal = c("Fee type"),
  type   = c("string"),
  stringsAsFactors = FALSE
)

.account_greeks_type_schema <- data.frame(
  okx    = c("greeksType"),
  formal = c("Greeks display type"),
  type   = c("string"),
  stringsAsFactors = FALSE
)

.account_auto_flag_schema <- data.frame(
  okx    = c("autoRepay"),
  formal = c("Auto repay enabled"),
  type   = c("logical"),
  stringsAsFactors = FALSE
)

.account_auto_loan_schema <- data.frame(
  okx    = c("autoLoan"),
  formal = c("Auto loan enabled"),
  type   = c("logical"),
  stringsAsFactors = FALSE
)

.account_level_schema <- data.frame(
  okx    = c("acctLv"),
  formal = c("Account mode"),
  type   = c("string"),
  stringsAsFactors = FALSE
)

.account_collateral_assets_schema <- data.frame(
  okx    = c("type", "ccyList", "collateralEnabled"),
  formal = c("Type", "Currency list", "Collateral enabled"),
  type   = c("string", "string", "logical"),
  stringsAsFactors = FALSE
)

.account_margin_balance_schema <- data.frame(
  okx    = c("instId", "posSide", "amt", "type", "leverage", "ccy"),
  formal = c("Instrument ID", "Position side", "Amount", "Margin action type", "Leverage", "Currency"),
  type   = c("string", "string", "string", "string", "string", "string"),
  stringsAsFactors = FALSE
)

.account_borrow_repay_schema <- data.frame(
  okx    = c("ccy", "side", "amt"),
  formal = c("Currency", "Side", "Amount"),
  type   = c("string", "string", "string"),
  stringsAsFactors = FALSE
)

.account_switch_preset_schema <- data.frame(
  okx    = c("curAcctLv", "acctLv", "lever", "riskOffsetType"),
  formal = c("Current account mode", "Target account mode", "Preset leverage", "Risk offset type"),
  type   = c("string", "string", "string", "string"),
  stringsAsFactors = FALSE
)

.account_result_schema <- data.frame(
  okx    = c("result"),
  formal = c("Result"),
  type   = c("logical"),
  stringsAsFactors = FALSE
)

.account_mmp_config_schema <- data.frame(
  okx    = c("instFamily", "timeInterval", "frozenInterval", "qtyLimit"),
  formal = c("Instrument family", "Time interval", "Frozen interval", "Quantity limit"),
  type   = c("string", "string", "string", "string"),
  stringsAsFactors = FALSE
)

.account_move_positions_schema <- data.frame(
  okx    = c("clientId", "blockTdId", "state", "ts", "fromAcct", "toAcct", "legs"),
  formal = c("Client ID", "Block trade ID", "State", "Timestamp", "Source account", "Destination account", "Legs"),
  type   = c("string", "string", "string", "time", "string", "string", "string"),
  stringsAsFactors = FALSE
)

.asset_transfer_response_schema <- data.frame(
  okx    = c("transId", "ccy", "clientId", "from", "amt", "to"),
  formal = c("Transfer ID", "Currency", "Client ID", "Source account", "Amount", "Destination account"),
  type   = c("string", "string", "string", "string", "string", "string"),
  stringsAsFactors = FALSE
)

.asset_withdrawal_response_schema <- data.frame(
  okx    = c("amt", "wdId", "ccy", "clientId", "chain"),
  formal = c("Amount", "Withdrawal ID", "Currency", "Client ID", "Chain"),
  type   = c("string", "string", "string", "string", "string"),
  stringsAsFactors = FALSE
)

.asset_cancel_withdrawal_response_schema <- data.frame(
  okx    = c("wdId"),
  formal = c("Withdrawal ID"),
  type   = c("string"),
  stringsAsFactors = FALSE
)

.asset_convert_estimate_quote_schema <- data.frame(
  okx    = c("quoteTime", "ttlMs", "clQReqId", "quoteId", "baseCcy", "quoteCcy", "side", "origRfqSz", "rfqSz", "rfqSzCcy", "cnvtPx", "baseSz", "quoteSz"),
  formal = c("Quote time", "Quote TTL in milliseconds", "Client quote request ID", "Quote ID", "Base currency", "Quote currency", "Side", "Original RFQ size", "RFQ size", "RFQ size currency", "Conversion price", "Base size", "Quote size"),
  type   = c("time", "numeric", "string", "string", "string", "string", "string", "string", "string", "string", "numeric", "numeric", "numeric"),
  stringsAsFactors = FALSE
)

.asset_convert_trade_schema <- data.frame(
  okx    = c("tradeId", "quoteId", "clTReqId", "state", "instId", "baseCcy", "quoteCcy", "side", "fillPx", "fillBaseSz", "fillQuoteSz", "ts"),
  formal = c("Trade ID", "Quote ID", "Client trade request ID", "State", "Instrument ID", "Base currency", "Quote currency", "Side", "Fill price", "Filled base size", "Filled quote size", "Timestamp"),
  type   = c("string", "string", "string", "string", "string", "string", "string", "string", "numeric", "numeric", "numeric", "time"),
  stringsAsFactors = FALSE
)

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

  #----account_set_position_mode----
  account_set_position_mode = list(
    okx_path     = "/api/v5/account/set-position-mode",
    parser_schema = .account_position_mode_schema,
    parser_mode = "named"
  ),

  #----account_set_fee_type----
  account_set_fee_type = list(
    okx_path     = "/api/v5/account/set-fee-type",
    parser_schema = .account_fee_type_schema,
    parser_mode = "named"
  ),

  #----account_set_greeks----
  account_set_greeks = list(
    okx_path     = "/api/v5/account/set-greeks",
    parser_schema = .account_greeks_type_schema,
    parser_mode = "named"
  ),

  #----account_set_auto_repay----
  account_set_auto_repay = list(
    okx_path     = "/api/v5/account/set-auto-repay",
    parser_schema = .account_auto_flag_schema,
    parser_mode = "named"
  ),

  #----account_set_auto_loan----
  account_set_auto_loan = list(
    okx_path     = "/api/v5/account/set-auto-loan",
    parser_schema = .account_auto_loan_schema,
    parser_mode = "named"
  ),

  #----account_set_account_level----
  account_set_account_level = list(
    okx_path     = "/api/v5/account/set-account-level",
    parser_schema = .account_level_schema,
    parser_mode = "named"
  ),

  #----account_set_collateral_assets----
  account_set_collateral_assets = list(
    okx_path     = "/api/v5/account/set-collateral-assets",
    parser_schema = .account_collateral_assets_schema,
    parser_mode = "named"
  ),

  #----account_position_margin_balance----
  account_position_margin_balance = list(
    okx_path     = "/api/v5/account/position/margin-balance",
    parser_schema = .account_margin_balance_schema,
    parser_mode = "named"
  ),

  #----account_spot_manual_borrow_repay----
  account_spot_manual_borrow_repay = list(
    okx_path     = "/api/v5/account/spot-manual-borrow-repay",
    parser_schema = .account_borrow_repay_schema,
    parser_mode = "named"
  ),

  #----account_account_level_switch_preset----
  account_account_level_switch_preset = list(
    okx_path     = "/api/v5/account/account-level-switch-preset",
    parser_schema = .account_switch_preset_schema,
    parser_mode = "named"
  ),

  #----account_mmp_reset----
  account_mmp_reset = list(
    okx_path     = "/api/v5/account/mmp-reset",
    parser_schema = .account_result_schema,
    parser_mode = "named"
  ),

  #----account_mmp_config----
  account_mmp_config = list(
    okx_path     = "/api/v5/account/mmp-config",
    parser_schema = .account_mmp_config_schema,
    parser_mode = "named"
  ),

  #----account_move_positions----
  account_move_positions = list(
    okx_path     = "/api/v5/account/move-positions",
    parser_schema = .account_move_positions_schema,
    parser_mode = "named"
  ),

  #----asset_transfer----
  asset_transfer = list(
    okx_path     = "/api/v5/asset/transfer",
    parser_schema = .asset_transfer_response_schema,
    parser_mode = "named"
  ),

  #----asset_withdrawal----
  asset_withdrawal = list(
    okx_path     = "/api/v5/asset/withdrawal",
    parser_schema = .asset_withdrawal_response_schema,
    parser_mode = "named"
  ),

  #----asset_cancel_withdrawal----
  asset_cancel_withdrawal = list(
    okx_path     = "/api/v5/asset/cancel-withdrawal",
    parser_schema = .asset_cancel_withdrawal_response_schema,
    parser_mode = "named"
  ),

  #----asset_convert_estimate_quote----
  asset_convert_estimate_quote = list(
    okx_path     = "/api/v5/asset/convert/estimate-quote",
    parser_schema = .asset_convert_estimate_quote_schema,
    parser_mode = "named"
  ),

  #----asset_convert_trade----
  asset_convert_trade = list(
    okx_path     = "/api/v5/asset/convert/trade",
    parser_schema = .asset_convert_trade_schema,
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
    parser_schema       = .trade_cancel_response_schema,
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
  ),

  #----trade_batch_orders----
  trade_batch_orders = list(
    okx_path     = "/api/v5/trade/batch-orders",
    parser_schema = data.frame(
      okx    = c("ts", "ordId", "clOrdId", "tag", "sCode", "sMsg"),
      formal = c("Timestamp", "Order ID", "Client Order ID", "Order tag", "Code of the execution result", "Execution message"),
      type   = c("time", "string", "string", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----trade_cancel_batch_orders----
  trade_cancel_batch_orders = list(
    okx_path     = "/api/v5/trade/cancel-batch-orders",
    parser_schema = .trade_cancel_response_schema,
    parser_mode = "named"
  ),

  #----trade_amend_order----
  trade_amend_order = list(
    okx_path     = "/api/v5/trade/amend-order",
    parser_schema = .trade_amend_response_schema,
    parser_mode = "named"
  ),

  #----trade_amend_batch_orders----
  trade_amend_batch_orders = list(
    okx_path     = "/api/v5/trade/amend-batch-orders",
    parser_schema = .trade_amend_response_schema,
    parser_mode = "named"
  ),

  #----trade_cancel_all_after----
  trade_cancel_all_after = list(
    okx_path     = "/api/v5/trade/cancel-all-after",
    parser_schema = data.frame(
      okx    = c("triggerTime", "tag", "ts"),
      formal = c("Trigger time", "Cancel-all-after tag", "Request time"),
      type   = c("numeric", "string", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----trade_order_precheck----
  trade_order_precheck = list(
    okx_path     = "/api/v5/trade/order-precheck",
    parser_schema = data.frame(
      okx    = c("adjEq", "adjEqChg", "availBal", "availBalChg", "imr", "imrChg", "liab", "liabChg", "liabChgCcy", "liqPx", "liqPxDiff", "liqPxDiffRatio", "mgnRatio", "mgnRatioChg", "mmr", "mmrChg", "posBal", "posBalChg", "type"),
      formal = c("Adjusted equity", "Adjusted equity change", "Available balance", "Available balance change", "Initial margin requirement", "Initial margin requirement change", "Liability", "Liability change", "Liability change currency", "Liquidation price", "Liquidation price change", "Liquidation price change ratio", "Margin ratio", "Margin ratio change", "Maintenance margin requirement", "Maintenance margin requirement change", "Position balance", "Position balance change", "Type"),
      type   = c("numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "string", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----trade_mass_cancel----
  trade_mass_cancel = list(
    okx_path     = "/api/v5/trade/mass-cancel",
    parser_schema = data.frame(
      okx    = c("result"),
      formal = c("Result"),
      type   = c("logical"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----trade_cancel_algos----
  trade_cancel_algos = list(
    okx_path     = "/api/v5/trade/cancel-algos",
    parser_schema = .trade_algo_cancel_response_schema,
    parser_mode = "named"
  ),

  #----trade_amend_algos----
  trade_amend_algos = list(
    okx_path     = "/api/v5/trade/amend-algos",
    parser_schema = .trade_algo_amend_response_schema,
    parser_mode = "named"
  )
  
  
)

#----.API_GET_SPECS----

#' OKX POST endpoint specifications (internal)
#'
#' A named list describing how to call and parse selected **POST** endpoints.
#'
#' Each entry has:
#' - `okx_path` (character): REST path beginning with `/api/...`.
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

  #----trade_account_rate_limit----
  trade_account_rate_limit = list(
    okx_path     = "/api/v5/trade/account-rate-limit",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("accRateLimit", "fillRatio", "mainFillRatio", "nextAccRateLimit", "ts"),
      formal = c("Account rate limit", "Sub-account fill ratio", "Main-account fill ratio", "Next account rate limit", "Request time"),
      type   = c("integer", "numeric", "numeric", "integer", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----copy_trade_settings----
  copy_trade_settings = list(
    okx_path     = "/api/v5/copytrading/copy-settings",
    parser_schema       = data.frame(
      okx    = c("ccy", "copyAmt", "copyInstIdType", "copyMgnMode", "copyMode", "copyRatio", "copyState", "copyTotalAmt", "instIds", "slRatio", "slTotalAmt", "subPosCloseType", "tpRatio", "tag"),
      formal = c("Margin currency", "Copy amount", "Copy instrument selection type", "Copy margin mode", "Copy mode", "Copy ratio", "Current copy state", "Maximum total copy amount", "Instrument list", "Stop-loss ratio", "Total stop-loss amount", "Subposition close type", "Take-profit ratio", "Order tag"),
      type   = c("string", "numeric", "string", "string", "string", "numeric", "string", "numeric", "string", "numeric", "numeric", "string", "numeric", "string"),
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
      okx    = c("algoId", "availSubPos", "ccy", "instId", "instType", "lever", "margin", "markPx", "mgnMode", "openAvgPx", "openOrdId", "openTime", "posSide", "slOrdPx", "slTriggerPx", "subPos", "subPosId", "tpOrdPx", "tpTriggerPx", "uniqueCode", "upl", "uplRatio"),
      formal = c("Stop order ID", "Available subposition size", "Margin currency", "Instrument ID", "Instrument type", "Leverage", "Margin", "Mark price", "Margin mode", "Average open price", "Opening order ID", "Open time", "Position side", "Stop-loss order price", "Stop-loss trigger price", "Subposition size", "Subposition ID", "Take-profit order price", "Take-profit trigger price", "Lead trader unique code", "Unrealized profit and loss", "Unrealized profit and loss ratio"),
      type   = c("string", "numeric", "string", "string", "string", "numeric", "numeric", "numeric", "string", "numeric", "string", "time", "string", "numeric", "numeric", "numeric", "string", "numeric", "numeric", "string", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----copy_trade_historical_subpos----
  copy_trade_historical_subpos = list(
    okx_path     = "/api/v5/copytrading/subpositions-history",
    parser_schema       = data.frame(
      okx    = c("ccy", "closeAvgPx", "closeSubPos", "closeTime", "instId", "instType", "lever", "margin", "markPx", "mgnMode", "openAvgPx", "openOrdId", "openTime", "pnl", "pnlRatio", "posSide", "profitSharingAmt", "subPos", "subPosId", "type", "uniqueCode"),
      formal = c("Margin currency", "Average close price", "Closed subposition size", "Close time", "Instrument ID", "Instrument type", "Leverage", "Margin", "Mark price", "Margin mode", "Average open price", "Opening order ID", "Open time", "Profit and loss", "Profit and loss ratio", "Position side", "Profit sharing amount", "Subposition size", "Subposition ID", "Close type", "Lead trader unique code"),
      type   = c("string", "numeric", "numeric", "time", "string", "string", "numeric", "numeric", "numeric", "string", "numeric", "string", "time", "numeric", "numeric", "string", "numeric", "numeric", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----copy_trade_instruments----
  copy_trade_instruments = list(
    okx_path     = "/api/v5/copytrading/instruments",
    parser_schema = data.frame(
      okx    = c("instId", "enabled"),
      formal = c("Instrument ID", "Copy trading enabled"),
      type   = c("string", "logical"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----copy_trade_config----
  copy_trade_config = list(
    okx_path     = "/api/v5/copytrading/config",
    parser_schema = data.frame(
      okx    = c("uniqueCode", "nickName", "portLink", "details"),
      formal = c("Lead trader unique code", "Nick name", "Portfolio link", "Copy trading configuration details"),
      type   = c("string", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----copy_trade_public_config----
  copy_trade_public_config = list(
    okx_path     = "/api/v5/copytrading/public-config",
    auth         = FALSE,
    parser_schema = data.frame(
      okx    = c("maxCopyAmt", "minCopyAmt", "maxCopyTotalAmt", "minCopyRatio", "maxCopyRatio", "maxTpRatio", "maxSlRatio"),
      formal = c("Maximum copy amount", "Minimum copy amount", "Maximum total copy amount", "Minimum copy ratio", "Maximum copy ratio", "Maximum take-profit ratio", "Maximum stop-loss ratio"),
      type   = c("numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----copy_trade_public_copy_traders----
  copy_trade_public_copy_traders = list(
    okx_path     = "/api/v5/copytrading/public-copy-traders",
    auth         = FALSE,
    parser_schema = data.frame(
      okx    = c("ccy", "copyTotalPnl", "copyTraderNumChg", "copyTraderNumChgRatio", "copyTraders"),
      formal = c("Profit currency", "Total copy trader profit and loss", "Copy trader count change", "Copy trader count change ratio", "Copy trader details"),
      type   = c("string", "numeric", "integer", "numeric", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----copy_trade_public_lead_traders----
  copy_trade_public_lead_traders = list(
    okx_path     = "/api/v5/copytrading/public-lead-traders",
    auth         = FALSE,
    parser_schema = data.frame(
      okx    = c("dataVer", "totalPage", "ranks"),
      formal = c("Data version", "Total pages", "Lead trader ranks"),
      type   = c("string", "integer", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----copy_trade_public_current_subpositions----
  copy_trade_public_current_subpositions = list(
    okx_path     = "/api/v5/copytrading/public-current-subpositions",
    auth         = FALSE,
    parser_schema = data.frame(
      okx    = c("ccy", "instId", "instType", "lever", "margin", "markPx", "mgnMode", "openAvgPx", "openTime", "posSide", "subPos", "subPosId", "uniqueCode", "upl", "uplRatio"),
      formal = c("Margin currency", "Instrument ID", "Instrument type", "Leverage", "Margin", "Mark price", "Margin mode", "Average open price", "Open time", "Position side", "Subposition size", "Subposition ID", "Lead trader unique code", "Unrealized profit and loss", "Unrealized profit and loss ratio"),
      type   = c("string", "string", "string", "numeric", "numeric", "numeric", "string", "numeric", "time", "string", "numeric", "string", "string", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----copy_trade_public_subpositions_history----
  copy_trade_public_subpositions_history = list(
    okx_path     = "/api/v5/copytrading/public-subpositions-history",
    auth         = FALSE,
    parser_schema = data.frame(
      okx    = c("ccy", "closeAvgPx", "closeTime", "instId", "instType", "lever", "margin", "mgnMode", "openAvgPx", "openTime", "pnl", "pnlRatio", "posSide", "subPos", "subPosId", "uniqueCode"),
      formal = c("Margin currency", "Average close price", "Close time", "Instrument ID", "Instrument type", "Leverage", "Margin", "Margin mode", "Average open price", "Open time", "Profit and loss", "Profit and loss ratio", "Position side", "Subposition size", "Subposition ID", "Lead trader unique code"),
      type   = c("string", "numeric", "time", "string", "string", "numeric", "numeric", "string", "numeric", "time", "numeric", "numeric", "string", "numeric", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----copy_trade_public_pnl----
  copy_trade_public_pnl = list(
    okx_path     = "/api/v5/copytrading/public-pnl",
    auth         = FALSE,
    parser_schema = data.frame(
      okx    = c("beginTs", "pnl", "pnlRatio"),
      formal = c("Window start time", "Profit and loss", "Profit and loss ratio"),
      type   = c("time", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----copy_trade_public_stats----
  copy_trade_public_stats = list(
    okx_path     = "/api/v5/copytrading/public-stats",
    auth         = FALSE,
    parser_schema = data.frame(
      okx    = c("avgSubPosNotional", "ccy", "curCopyTraderPnl", "investAmt", "lossDays", "profitDays", "winRatio"),
      formal = c("Average subposition notional", "Quote currency", "Current copy trader profit and loss", "Invested amount", "Loss days", "Profit days", "Win ratio"),
      type   = c("numeric", "string", "numeric", "numeric", "integer", "integer", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----copy_trade_public_weekly_pnl----
  copy_trade_public_weekly_pnl = list(
    okx_path     = "/api/v5/copytrading/public-weekly-pnl",
    auth         = FALSE,
    parser_schema = data.frame(
      okx    = c("beginTs", "pnl", "pnlRatio"),
      formal = c("Week start time", "Profit and loss", "Profit and loss ratio"),
      type   = c("time", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----copy_trade_public_preference_currency----
  copy_trade_public_preference_currency = list(
    okx_path     = "/api/v5/copytrading/public-preference-currency",
    auth         = FALSE,
    parser_schema = data.frame(
      okx    = c("ccy", "ratio"),
      formal = c("Currency", "Preference ratio"),
      type   = c("string", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----copy_trade_profit_sharing_details----
  copy_trade_profit_sharing_details = list(
    okx_path     = "/api/v5/copytrading/profit-sharing-details",
    parser_schema = data.frame(
      okx    = c("ccy", "nickName", "profitSharingAmt", "profitSharingId", "portLink", "ts", "instType"),
      formal = c("Settlement currency", "Nick name", "Profit sharing amount", "Profit sharing ID", "Portfolio link", "Settlement time", "Instrument type"),
      type   = c("string", "string", "numeric", "string", "string", "time", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----copy_trade_unrealized_profit_sharing_details----
  copy_trade_unrealized_profit_sharing_details = list(
    okx_path     = "/api/v5/copytrading/unrealized-profit-sharing-details",
    parser_schema = data.frame(
      okx    = c("ccy", "nickName", "portLink", "ts", "unrealizedProfitSharingAmt", "instType"),
      formal = c("Settlement currency", "Nick name", "Portfolio link", "Observation time", "Unrealized profit sharing amount", "Instrument type"),
      type   = c("string", "string", "string", "time", "numeric", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----copy_trade_total_profit_sharing----
  copy_trade_total_profit_sharing = list(
    okx_path     = "/api/v5/copytrading/total-profit-sharing",
    parser_schema = data.frame(
      okx    = c("ccy", "totalProfitSharingAmt", "instType"),
      formal = c("Settlement currency", "Total profit sharing amount", "Instrument type"),
      type   = c("string", "numeric", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----copy_trade_total_unrealized_profit_sharing----
  copy_trade_total_unrealized_profit_sharing = list(
    okx_path     = "/api/v5/copytrading/total-unrealized-profit-sharing",
    parser_schema = data.frame(
      okx    = c("profitSharingTs", "totalUnrealizedProfitSharingAmt"),
      formal = c("Profit sharing snapshot time", "Total unrealized profit sharing amount"),
      type   = c("time", "numeric"),
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
      okx    = c("actualDepBlkConfirm", "amt", "areaCodeFrom", "ccy", "chain", "depId", "from", "fromWdId", "state", "to", "ts", "txId"),
      formal = c("Actual deposit block confirmations", "Amount", "Origin area code", "Currency", "Chain", "Deposit ID", "Origin address", "Source withdrawal ID", "Deposit state", "Destination address", "Timestamp", "Transaction hash"),
      type   = c("numeric", "numeric", "string", "string", "string", "string", "string", "string", "string", "string", "time", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----asset_withdrawal_history----
  asset_withdrawal_history = list(
    okx_path     = "/api/v5/asset/withdrawal-history",
    parser_schema       = data.frame(
      okx    = c("note", "chain", "fee", "feeCcy", "ccy", "clientId", "toAddrType", "amt", "txId", "from", "areaCodeFrom", "to", "areaCodeTo", "state", "ts", "nonTradableAsset", "wdId"),
      formal = c("Withdrawal note", "Chain", "Withdrawal fee", "Fee currency", "Currency", "Client ID", "Destination address type", "Amount", "Transaction hash", "Origin address", "Origin area code", "Destination address", "Destination area code", "Withdrawal state", "Timestamp", "Non-tradable asset", "Withdrawal ID"),
      type   = c("string", "string", "numeric", "string", "string", "string", "string", "numeric", "string", "string", "string", "string", "string", "string", "time", "logical", "string"),
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
  
  #----account_instruments----
  account_instruments = list(
    okx_path = "/api/v5/account/instruments",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instType", "instId", "uly", "instFamily", "baseCcy", "quoteCcy", "settleCcy", "ctVal", "ctMult", "ctValCcy", "listTime", "openType", "expTime", "lever", "tickSz", "lotSz", "minSz", "ctType", "state"),
      formal = c("Instrument type", "Instrument ID", "Underlying", "Instrument family", "Base currency", "Quote currency", "Settlement and margin currency", "Contract value", "Contract multiplier", "Contract value currency", "Listing time", "Open type", "Expiry time", "Max Leverage", "Tick size", "Lot size", "Minimum order size", "Contract type", "Instrument status"),
      type   = c("string", "string", "string", "string", "string", "string", "string", "numeric", "numeric", "numeric", "time", "string", "time", "numeric", "numeric", "numeric", "numeric", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_position_risk----
  account_position_risk = list(
    okx_path = "/api/v5/account/account-position-risk",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("adjEq", "balData", "posData", "ts"),
      formal = c("Adjusted equity", "Balance snapshot data", "Position snapshot data", "Snapshot time"),
      type   = c("numeric", "string", "string", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_max_size----
  account_max_size = list(
    okx_path = "/api/v5/account/max-size",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instId", "ccy", "maxBuy", "maxSell"),
      formal = c("Instrument ID", "Margin currency", "Maximum buy size", "Maximum sell size"),
      type   = c("string", "string", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_max_avail_size----
  account_max_avail_size = list(
    okx_path = "/api/v5/account/max-avail-size",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instId", "availBuy", "availSell"),
      formal = c("Instrument ID", "Maximum available buy amount", "Maximum available sell amount"),
      type   = c("string", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_trade_fee----
  account_trade_fee = list(
    okx_path = "/api/v5/account/trade-fee",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("level", "feeGroup", "delivery", "exercise", "instType", "ts", "taker", "maker", "takerU", "makerU", "takerUSDC", "makerUSDC", "ruleType", "category", "fiat", "settle"),
      formal = c("Fee rate level", "Fee groups", "Delivery fee rate", "Exercise fee rate", "Instrument type", "Data return time", "Taker fee rate", "Maker fee rate", "USDT-margined taker fee rate", "USDT-margined maker fee rate", "USDC or USD stablecoin taker fee rate", "USDC or USD stablecoin maker fee rate", "Trading rule type", "Currency category", "Deprecated fiat fee detail", "Settlement fee rate"),
      type   = c("string", "string", "numeric", "numeric", "string", "time", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "string", "string", "string", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_interest_rate----
  account_interest_rate = list(
    okx_path = "/api/v5/account/interest-rate",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("interestRate", "ccy"),
      formal = c("Hourly borrowing interest rate", "Currency"),
      type   = c("numeric", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_subtypes----
  account_subtypes = list(
    okx_path = "/api/v5/account/subtypes",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("type", "typeDesc", "subTypeDetails"),
      formal = c("Bill type", "Bill type description", "Sub-type details"),
      type   = c("string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_adjust_leverage_info----
  account_adjust_leverage_info = list(
    okx_path = "/api/v5/account/adjust-leverage-info",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("estAvailQuoteTrans", "estAvailTrans", "estLiqPx", "estMaxAmt", "estMgn", "estQuoteMaxAmt", "estQuoteMgn", "existOrd", "maxLever", "minLever"),
      formal = c("Estimated transferable quote margin", "Estimated transferable margin", "Estimated liquidation price", "Estimated maximum amount", "Estimated margin", "Estimated maximum quote amount", "Estimated quote margin", "Existing pending orders", "Maximum leverage", "Minimum leverage"),
      type   = c("numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "logical", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_max_loan----
  account_max_loan = list(
    okx_path = "/api/v5/account/max-loan",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instId", "mgnMode", "mgnCcy", "maxLoan", "ccy", "side"),
      formal = c("Instrument ID", "Margin mode", "Margin currency", "Maximum loan", "Currency", "Order side"),
      type   = c("string", "string", "string", "numeric", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_interest_accrued----
  account_interest_accrued = list(
    okx_path = "/api/v5/account/interest-accrued",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("type", "ccy", "instId", "mgnMode", "interest", "interestRate", "liab", "totalLiab", "interestFreeLiab", "ts"),
      formal = c("Loan type", "Loan currency", "Instrument ID", "Margin mode", "Interest accrued", "Hourly borrowing interest rate", "Liability", "Total liability", "Interest-free liability", "Timestamp"),
      type   = c("string", "string", "string", "string", "numeric", "numeric", "numeric", "numeric", "numeric", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_max_withdrawal----
  account_max_withdrawal = list(
    okx_path = "/api/v5/account/max-withdrawal",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("ccy", "maxWd", "maxWdEx", "spotOffsetMaxWd", "spotOffsetMaxWdEx"),
      formal = c("Currency", "Maximum withdrawal", "Maximum withdrawal including borrowed assets", "Spot offset maximum withdrawal", "Spot offset maximum withdrawal including borrowed assets"),
      type   = c("string", "numeric", "numeric", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_risk_state----
  account_risk_state = list(
    okx_path = "/api/v5/account/risk-state",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("atRisk", "atRiskIdx", "atRiskMgn", "ts"),
      formal = c("Account at risk", "Derivatives risk units", "Margin risk units", "Timestamp"),
      type   = c("logical", "string", "string", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_interest_limits----
  account_interest_limits = list(
    okx_path = "/api/v5/account/interest-limits",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("debt", "interest", "loanAlloc", "nextDiscountTime", "nextInterestTime", "records"),
      formal = c("Current debt in USD", "Current interest in USD", "VIP loan allocation", "Next discount time", "Next accrual time", "Per-currency loan records"),
      type   = c("numeric", "numeric", "numeric", "time", "time", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_greeks----
  account_greeks = list(
    okx_path = "/api/v5/account/greeks",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("thetaBS", "thetaPA", "deltaBS", "deltaPA", "gammaBS", "gammaPA", "vegaBS", "vegaPA", "ccy", "ts"),
      formal = c("Black-Scholes theta", "Coin theta", "Black-Scholes delta", "Coin delta", "Black-Scholes gamma", "Coin gamma", "Black-Scholes vega", "Coin vega", "Currency", "Timestamp"),
      type   = c("numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "string", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_position_tiers----
  account_position_tiers = list(
    okx_path = "/api/v5/account/position-tiers",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("uly", "instFamily", "maxSz", "posType"),
      formal = c("Underlying", "Instrument family", "Maximum position size", "Position limitation type"),
      type   = c("string", "string", "numeric", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_collateral_assets----
  account_collateral_assets = list(
    okx_path = "/api/v5/account/collateral-assets",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("ccy", "collateralEnabled"),
      formal = c("Currency", "Collateral enabled"),
      type   = c("string", "logical"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_mmp_config----
  account_mmp_config = list(
    okx_path = "/api/v5/account/mmp-config",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instFamily", "mmpFrozen", "mmpFrozenUntil", "timeInterval", "frozenInterval", "qtyLimit"),
      formal = c("Instrument family", "MMP frozen", "MMP frozen until", "Monitoring interval", "Frozen interval", "Quantity limit"),
      type   = c("string", "logical", "numeric", "numeric", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_move_positions_history----
  account_move_positions_history = list(
    okx_path = "/api/v5/account/move-positions-history",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("clientId", "blockTdId", "state", "ts", "fromAcct", "toAcct", "legs"),
      formal = c("Client-supplied ID", "Block trade ID", "Transfer state", "Processed time", "Source account", "Destination account", "Position transfer legs"),
      type   = c("string", "string", "string", "time", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_precheck_set_delta_neutral----
  account_precheck_set_delta_neutral = list(
    okx_path = "/api/v5/account/precheck-set-delta-neutral",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("unmatchedInfoCheck"),
      formal = c("Delta-neutral unmatched information"),
      type   = c("string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_bills_history_archive----
  account_bills_history_archive = list(
    okx_path = "/api/v5/account/bills-history-archive",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("fileHref", "state", "ts"),
      formal = c("Download file link", "Download link status", "Request time"),
      type   = c("string", "string", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_subaccount_balances----
  account_subaccount_balances = list(
    okx_path = "/api/v5/account/subaccount/balances",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("uTime", "totalEq", "isoEq", "adjEq", "availEq", "ordFroz", "imr", "mmr", "borrowFroz", "mgnRatio", "notionalUsd", "notionalUsdForBorrow", "notionalUsdForSwap", "notionalUsdForFutures", "notionalUsdForOption", "upl", "delta", "deltaLever", "deltaNeutralStatus", "details"),
      formal = c("Update time", "Total equity", "Isolated margin equity", "Adjusted / Effective equity", "Available equity", "Frozen order margin", "Initial margin requirement", "Maintenance margin requirement", "Potential borrowing IMR", "Maintenance margin ratio", "Notional USD", "Notional USD for borrow", "Notional USD for swaps", "Notional USD for futures", "Notional USD for options", "Unrealized profit and loss", "Delta", "Delta leverage", "Delta neutral status", "Per-currency balance details"),
      type   = c("time", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_subaccount_max_withdrawal----
  account_subaccount_max_withdrawal = list(
    okx_path = "/api/v5/account/subaccount/max-withdrawal",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("ccy", "maxWd", "maxWdEx", "spotOffsetMaxWd", "spotOffsetMaxWdEx"),
      formal = c("Currency", "Maximum withdrawal", "Maximum withdrawal including borrowed assets", "Spot offset maximum withdrawal", "Spot offset maximum withdrawal including borrowed assets"),
      type   = c("string", "numeric", "numeric", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_set_account_switch_precheck----
  account_set_account_switch_precheck = list(
    okx_path = "/api/v5/account/set-account-switch-precheck",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("acctLv", "curAcctLv", "mgnAft", "mgnBf", "posList", "posTierCheck", "riskOffsetType", "sCode", "unmatchedInfoCheck"),
      formal = c("Target account mode", "Current account mode", "Margin after switch", "Margin before switch", "Position list", "Position tier check", "Risk offset type", "Status code", "Unmatched information"),
      type   = c("string", "string", "string", "string", "string", "string", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----account_spot_borrow_repay_history----
  account_spot_borrow_repay_history = list(
    okx_path = "/api/v5/account/spot-borrow-repay-history",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("ccy", "type", "amt", "accBorrowed", "ts"),
      formal = c("Currency", "Event type", "Amount", "Accumulated borrowed amount", "Timestamp"),
      type   = c("string", "string", "numeric", "numeric", "time"),
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

  #----market_option_instrument_family_trades----
  market_option_instrument_family_trades = list(
    okx_path     = "/api/v5/market/option/instrument-family-trades",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instId", "tradeId", "px", "sz", "side", "ts"),
      formal = c("Instrument ID", "Trade ID", "Trade price", "Trade quantity", "Trade side", "Trade time"),
      type   = c("string", "string", "numeric", "numeric", "string", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----market_mark_price_candles----
  market_mark_price_candles = list(
    okx_path     = "/api/v5/market/mark-price-candles",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("ts", "o", "h", "l", "c", "confirm"),
      formal = c("Timestamp", "Open price", "Highest price", "Lowest price", "Close price", "The state of candlesticks"),
      type   = c("time", "numeric", "numeric", "numeric", "numeric", "integer"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "positional"
  ),

  #----market_history_mark_price_candles----
  market_history_mark_price_candles = list(
    okx_path     = "/api/v5/market/history-mark-price-candles",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("ts", "o", "h", "l", "c", "confirm"),
      formal = c("Timestamp", "Open price", "Highest price", "Lowest price", "Close price", "The state of candlesticks"),
      type   = c("time", "numeric", "numeric", "numeric", "numeric", "integer"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "positional"
  ),

  #----market_index_tickers----
  market_index_tickers = list(
    okx_path     = "/api/v5/market/index-tickers",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instId", "idxPx", "high24h", "low24h", "open24h", "sodUtc0", "sodUtc8", "ts"),
      formal = c("Index ID", "Latest index price", "Highest price in the past 24 hours", "Lowest price in the past 24 hours", "Open price in the past 24 hours", "UTC 0 open price", "UTC 8 open price", "Index price update time"),
      type   = c("string", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----market_index_candles----
  market_index_candles = list(
    okx_path     = "/api/v5/market/index-candles",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("ts", "o", "h", "l", "c", "confirm"),
      formal = c("Timestamp", "Open price", "Highest price", "Lowest price", "Close price", "The state of candlesticks"),
      type   = c("time", "numeric", "numeric", "numeric", "numeric", "integer"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "positional"
  ),

  #----market_history_index_candles----
  market_history_index_candles = list(
    okx_path     = "/api/v5/market/history-index-candles",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("ts", "o", "h", "l", "c", "confirm"),
      formal = c("Timestamp", "Open price", "Highest price", "Lowest price", "Close price", "The state of candlesticks"),
      type   = c("time", "numeric", "numeric", "numeric", "numeric", "integer"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "positional"
  ),

  #----market_exchange_rate----
  market_exchange_rate = list(
    okx_path     = "/api/v5/market/exchange-rate",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("usdCny"),
      formal = c("USD to CNY exchange rate"),
      type   = c("numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----market_index_components----
  market_index_components = list(
    okx_path     = "/api/v5/market/index-components",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("index", "last", "ts", "components"),
      formal = c("Index", "Latest index price", "Data generation time", "Index components"),
      type   = c("string", "numeric", "time", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----market_platform_24_volume----
  market_platform_24_volume = list(
    okx_path     = "/api/v5/market/platform-24-volume",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("volCny", "volUsd", "ts"),
      formal = c("24-hour total volume in CNY", "24-hour total volume in USD", "Data return time"),
      type   = c("numeric", "numeric", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----market_block_ticker----
  market_block_ticker = list(
    okx_path     = "/api/v5/market/block-ticker",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instType", "instId", "volCcy24h", "vol24h", "ts"),
      formal = c("Instrument type", "Instrument ID", "24-hour block volume in currency", "24-hour block volume", "Block ticker time"),
      type   = c("string", "string", "numeric", "numeric", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----market_block_tickers----
  market_block_tickers = list(
    okx_path     = "/api/v5/market/block-tickers",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instType", "instId", "volCcy24h", "vol24h", "ts"),
      formal = c("Instrument type", "Instrument ID", "24-hour block volume in currency", "24-hour block volume", "Block ticker time"),
      type   = c("string", "string", "numeric", "numeric", "time"),
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

  #----public_underlying----
  public_underlying = list(
    okx_path = "/api/v5/public/underlying",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("uly"),
      formal = c("Underlying"),
      type   = c("string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "vector"
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
  ),

  #----public_estimated_price----
  public_estimated_price = list(
    okx_path = "/api/v5/public/estimated-price",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instType", "instId", "settlePx", "ts"),
      formal = c("Instrument type", "Instrument ID", "Estimated delivery or exercise price", "Data return time"),
      type   = c("string", "string", "numeric", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_delivery_exercise_history----
  public_delivery_exercise_history = list(
    okx_path = "/api/v5/public/delivery-exercise-history",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("ts", "details"),
      formal = c("Delivery or exercise time", "Delivery or exercise details"),
      type   = c("time", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_estimated_settlement_info----
  public_estimated_settlement_info = list(
    okx_path = "/api/v5/public/estimated-settlement-info",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instId", "nextSettleTime", "estSettlePx", "ts"),
      formal = c("Instrument ID", "Next settlement time", "Estimated settlement price", "Data return time"),
      type   = c("string", "time", "numeric", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_settlement_history----
  public_settlement_history = list(
    okx_path = "/api/v5/public/settlement-history",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("ts", "details"),
      formal = c("Settlement time", "Settlement details"),
      type   = c("time", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_discount_rate_interest_free_quota----
  public_discount_rate_interest_free_quota = list(
    okx_path = "/api/v5/public/discount-rate-interest-free-quota",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("ccy", "colRes", "collateralRestrict", "amt", "discountLv", "minDiscountRate", "details"),
      formal = c("Currency", "Platform level collateral restriction status", "Deprecated collateral restriction flag", "Interest-free quota", "Deprecated discount level", "Minimum discount rate", "Discount tier details"),
      type   = c("string", "string", "logical", "numeric", "string", "numeric", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_opt_summary----
  public_opt_summary = list(
    okx_path = "/api/v5/public/opt-summary",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instType", "instId", "uly", "delta", "gamma", "vega", "theta", "deltaBS", "gammaBS", "vegaBS", "thetaBS", "lever", "markVol", "bidVol", "askVol", "realVol", "volLv", "fwdPx", "ts"),
      formal = c("Instrument type", "Instrument ID", "Underlying", "Delta", "Gamma", "Vega", "Theta", "Delta in BS mode", "Gamma in BS mode", "Vega in BS mode", "Theta in BS mode", "Leverage", "Mark volatility", "Bid volatility", "Ask volatility", "Realized volatility", "ATM implied volatility", "Forward price", "Data update time"),
      type   = c("string", "string", "string", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_position_tiers----
  public_position_tiers = list(
    okx_path = "/api/v5/public/position-tiers",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("uly", "instFamily", "instId", "tier", "maxSz", "minSz", "maxLever", "imr", "mmr", "optMgnFactor", "quoteMaxLoan", "baseMaxLoan"),
      formal = c("Underlying", "Instrument family", "Instrument ID", "Tier", "Maximum size", "Minimum size", "Maximum leverage", "Initial margin requirement", "Maintenance margin requirement", "Option margin factor", "Quote currency maximum loan", "Base currency maximum loan"),
      type   = c("string", "string", "string", "string", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_economic_calendar----
  public_economic_calendar = list(
    okx_path = "/api/v5/public/economic-calendar",
    auth = TRUE,
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("calendarId", "date", "region", "category", "event", "refDate", "actual", "previous", "forecast", "dateSpan", "importance", "uTime", "prevInitial", "ccy", "unit"),
      formal = c("Calendar ID", "Release time", "Region", "Category", "Event", "Reference date", "Actual value", "Previous value", "Forecast value", "Date span flag", "Importance level", "Update time", "Initial previous value", "Currency", "Unit"),
      type   = c("string", "time", "string", "string", "string", "time", "string", "string", "string", "string", "string", "time", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_interest_rate_loan_quota----
  public_interest_rate_loan_quota = list(
    okx_path = "/api/v5/public/interest-rate-loan-quota",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("basic", "vip", "regular", "configCcyList", "config"),
      formal = c("Basic interest-rate table", "VIP interest information", "Regular-user interest information", "Currencies with customized quota configuration", "Customized quota configuration"),
      type   = c("string", "string", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_insurance_fund----
  public_insurance_fund = list(
    okx_path = "/api/v5/public/insurance-fund",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("total", "instFamily", "instType", "details"),
      formal = c("Total security fund balance in USD", "Instrument family", "Instrument type", "Security fund details"),
      type   = c("numeric", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_convert_contract_coin----
  public_convert_contract_coin = list(
    okx_path = "/api/v5/public/convert-contract-coin",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("type", "instId", "px", "sz", "unit"),
      formal = c("Convert type", "Instrument ID", "Order price", "Converted quantity", "Currency unit"),
      type   = c("string", "string", "numeric", "numeric", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_instrument_tick_bands----
  public_instrument_tick_bands = list(
    okx_path = "/api/v5/public/instrument-tick-bands",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instType", "instFamily", "tickBand"),
      formal = c("Instrument type", "Instrument family", "Tick size band"),
      type   = c("string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_premium_history----
  public_premium_history = list(
    okx_path = "/api/v5/public/premium-history",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instId", "premium", "ts"),
      formal = c("Instrument ID", "Premium index", "Data generation time"),
      type   = c("string", "numeric", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_block_trades----
  public_block_trades = list(
    okx_path = "/api/v5/public/block-trades",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("fillVol", "fwdPx", "groupId", "idxPx", "instId", "markPx", "px", "side", "sz", "tradeId", "ts"),
      formal = c("Implied volatility", "Forward price", "Group RFQ ID", "Index price", "Instrument ID", "Mark price", "Trade price", "Trade side", "Trade quantity", "Trade ID", "Trade time"),
      type   = c("numeric", "numeric", "string", "numeric", "string", "numeric", "numeric", "string", "numeric", "string", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),

  #----public_option_trades----
  public_option_trades = list(
    okx_path = "/api/v5/public/option-trades",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("instId", "instFamily", "tradeId", "px", "sz", "side", "optType", "fillVol", "fwdPx", "idxPx", "markPx", "ts"),
      formal = c("Instrument ID", "Instrument family", "Trade ID", "Trade price", "Trade quantity", "Trade side", "Option type", "Implied volatility while trading", "Forward price while trading", "Index price while trading", "Mark price while trading", "Trade time"),
      type   = c("string", "string", "string", "numeric", "numeric", "string", "string", "numeric", "numeric", "numeric", "numeric", "time"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  )
)

.api_GET_specs$trade_orders_history <- list(
  okx_path = "/api/v5/trade/orders-history",
  parser_schema = .api_GET_specs$trade_orders_history_7d$parser_schema,
  parser_mode = "named"
)

.api_GET_specs$trade_orders_history_archive <- list(
  okx_path = "/api/v5/trade/orders-history-archive",
  parser_schema = .api_GET_specs$trade_orders_history_7d$parser_schema,
  parser_mode = "named"
)

.api_GET_specs$trade_easy_convert_currency_list <- list(
  okx_path = "/api/v5/trade/easy-convert-currency-list",
  parser_schema = data.frame(
    okx = c("fromData", "toCcy"),
    formal = c("Source currency data", "Target currency list"),
    type = c("string", "string"),
    stringsAsFactors = FALSE
  ),
  parser_mode = "named"
)

.api_GET_specs$trade_easy_convert_history <- list(
  okx_path = "/api/v5/trade/easy-convert-history",
  parser_schema = data.frame(
    okx = c("fromCcy", "fillFromSz", "toCcy", "fillToSz", "acct", "status", "uTime"),
    formal = c("Source currency", "Filled source size", "Target currency", "Filled target size", "Account type", "Conversion status", "Trade time"),
    type = c("string", "numeric", "string", "numeric", "string", "string", "time"),
    stringsAsFactors = FALSE
  ),
  parser_mode = "named"
)

.api_GET_specs$trade_one_click_repay_currency_list <- list(
  okx_path = "/api/v5/trade/one-click-repay-currency-list",
  parser_schema = data.frame(
    okx = c("debtType", "debtData", "repayData"),
    formal = c("Debt type", "Debt currency data", "Repay currency data"),
    type = c("string", "string", "string"),
    stringsAsFactors = FALSE
  ),
  parser_mode = "named"
)

.api_GET_specs$trade_one_click_repay_history <- list(
  okx_path = "/api/v5/trade/one-click-repay-history",
  parser_schema = data.frame(
    okx = c("debtCcy", "fillDebtSz", "repayCcy", "fillRepaySz", "status", "uTime"),
    formal = c("Debt currency", "Filled debt size", "Repay currency", "Filled repay size", "Repay status", "Trade time"),
    type = c("string", "numeric", "string", "numeric", "string", "time"),
    stringsAsFactors = FALSE
  ),
  parser_mode = "named"
)

.api_GET_specs$trade_one_click_repay_currency_list_v2 <- list(
  okx_path = "/api/v5/trade/one-click-repay-currency-list-v2",
  parser_schema = data.frame(
    okx = c("debtData", "repayData"),
    formal = c("Debt currency data", "Repay currency data"),
    type = c("string", "string"),
    stringsAsFactors = FALSE
  ),
  parser_mode = "named"
)

.api_GET_specs$trade_one_click_repay_history_v2 <- list(
  okx_path = "/api/v5/trade/one-click-repay-history-v2",
  parser_schema = data.frame(
    okx = c("debtCcy", "repayCcyList", "fillDebtSz", "status", "ordIdInfo", "ts"),
    formal = c("Debt currency", "Repay currency list", "Filled debt size", "Repay status", "Repay order details", "Request time"),
    type = c("string", "string", "numeric", "string", "string", "time"),
    stringsAsFactors = FALSE
  ),
  parser_mode = "named"
)

.trade_algo_schema <- data.frame(
  okx = c("algoId", "algoClOrdId", "instType", "instId", "ordType", "state", "side", "posSide", "tdMode", "sz", "cTime", "uTime", "attachAlgoOrds", "linkedOrd", "triggerParams", "failCode"),
  formal = c("Algo order ID", "Client algo order ID", "Instrument type", "Instrument ID", "Algo order type", "Algo order state", "Order side", "Position side", "Trade mode", "Order size", "Creation time", "Update time", "Attached algo orders", "Linked order detail", "Trigger parameters", "Failure code"),
  type = c("string", "string", "string", "string", "string", "string", "string", "string", "string", "numeric", "time", "time", "string", "string", "string", "string"),
  stringsAsFactors = FALSE
)

.api_GET_specs$trade_order_algo <- list(
  okx_path = "/api/v5/trade/order-algo",
  parser_schema = .trade_algo_schema,
  parser_mode = "named"
)

.api_GET_specs$trade_orders_algo_pending <- list(
  okx_path = "/api/v5/trade/orders-algo-pending",
  parser_schema = .trade_algo_schema,
  parser_mode = "named"
)

.api_GET_specs$trade_orders_algo_history <- list(
  okx_path = "/api/v5/trade/orders-algo-history",
  parser_schema = .trade_algo_schema,
  parser_mode = "named"
)

.api_GET_specs$asset_non_tradable_assets <- list(
  okx_path = "/api/v5/asset/non-tradable-assets",
  parser_schema = data.frame(
    okx = c("ccy", "chain", "name", "bal", "canWd", "minWd", "wdAll", "fee", "feeCcy", "burningFeeRate", "needTag", "logoLink", "ctAddr", "wdTickSz"),
    formal = c("Currency", "Chain", "Asset name", "Balance", "Can withdraw", "Minimum withdrawal", "Withdraw-all amount", "Withdrawal fee", "Fee currency", "Burning fee rate", "Requires tag", "Logo URL", "Contract address suffix", "Withdrawal tick size"),
    type = c("string", "string", "string", "numeric", "logical", "numeric", "numeric", "numeric", "string", "numeric", "logical", "string", "string", "numeric"),
    stringsAsFactors = FALSE
  ),
  parser_mode = "named"
)

.api_GET_specs$asset_asset_valuation <- list(
  okx_path = "/api/v5/asset/asset-valuation",
  parser_schema = data.frame(
    okx = c("totalBal", "ts", "details"),
    formal = c("Total balance in valuation currency", "Valuation time", "Valuation details"),
    type = c("numeric", "time", "string"),
    stringsAsFactors = FALSE
  ),
  parser_mode = "named"
)

.api_GET_specs$asset_transfer_state <- list(
  okx_path = "/api/v5/asset/transfer-state",
  parser_schema = data.frame(
    okx = c("transId", "clientId", "ccy", "amt", "type", "from", "to", "subAcct", "state"),
    formal = c("Transfer ID", "Client ID", "Currency", "Transfer amount", "Transfer type", "From account", "To account", "Sub-account", "Transfer state"),
    type = c("string", "string", "string", "numeric", "string", "string", "string", "string", "string"),
    stringsAsFactors = FALSE
  ),
  parser_mode = "named"
)

.asset_bills_schema <- data.frame(
  okx = c("billId", "ccy", "clientId", "balChg", "bal", "type", "notes", "ts"),
  formal = c("Bill ID", "Currency", "Client ID", "Balance change", "Balance", "Bill type", "Notes", "Creation time"),
  type = c("string", "string", "string", "numeric", "numeric", "string", "string", "time"),
  stringsAsFactors = FALSE
)

.api_GET_specs$asset_bills <- list(
  okx_path = "/api/v5/asset/bills",
  parser_schema = .asset_bills_schema,
  parser_mode = "named"
)

.api_GET_specs$asset_bills_history <- list(
  okx_path = "/api/v5/asset/bills-history",
  parser_schema = .asset_bills_schema,
  parser_mode = "named"
)

.api_GET_specs$asset_deposit_withdraw_status <- list(
  okx_path = "/api/v5/asset/deposit-withdraw-status",
  parser_schema = data.frame(
    okx = c("wdId", "txId", "state", "estCompleteTime"),
    formal = c("Withdrawal ID", "Transaction hash", "Detailed status", "Estimated completion time"),
    type = c("string", "string", "string", "string"),
    stringsAsFactors = FALSE
  ),
  parser_mode = "named"
)

.api_GET_specs$asset_exchange_list <- list(
  okx_path = "/api/v5/asset/exchange-list",
  auth = FALSE,
  parser_schema = data.frame(
    okx = c("exchName", "exchId"),
    formal = c("Exchange name", "Exchange ID"),
    type = c("string", "string"),
    stringsAsFactors = FALSE
  ),
  parser_mode = "named"
)

.api_GET_specs$asset_convert_currencies <- list(
  okx_path = "/api/v5/asset/convert/currencies",
  parser_schema = data.frame(
    okx = c("ccy", "min", "max"),
    formal = c("Currency", "Minimum amount (deprecated)", "Maximum amount (deprecated)"),
    type = c("string", "numeric", "numeric"),
    stringsAsFactors = FALSE
  ),
  parser_mode = "named"
)

.api_GET_specs$asset_convert_currency_pair <- list(
  okx_path = "/api/v5/asset/convert/currency-pair",
  parser_schema = data.frame(
    okx = c("instId", "baseCcy", "baseCcyMax", "baseCcyMin", "quoteCcy", "quoteCcyMax", "quoteCcyMin"),
    formal = c("Currency pair", "Base currency", "Base currency maximum", "Base currency minimum", "Quote currency", "Quote currency maximum", "Quote currency minimum"),
    type = c("string", "string", "numeric", "numeric", "string", "numeric", "numeric"),
    stringsAsFactors = FALSE
  ),
  parser_mode = "named"
)

.api_GET_specs$asset_convert_history <- list(
  okx_path = "/api/v5/asset/convert/history",
  parser_schema = data.frame(
    okx = c("clTReqId", "instId", "side", "fillPx", "baseCcy", "quoteCcy", "fillBaseSz", "state", "tradeId", "fillQuoteSz", "ts"),
    formal = c("Client trade request ID", "Currency pair", "Trade side", "Filled price", "Base currency", "Quote currency", "Filled base size", "Trade state", "Trade ID", "Filled quote size", "Trade time"),
    type = c("string", "string", "string", "numeric", "string", "string", "numeric", "string", "string", "numeric", "time"),
    stringsAsFactors = FALSE
  ),
  parser_mode = "named"
)

.public_GET_spec_names <- c(
  "market_ticker",
  "market_tickers",
  "market_books",
  "market_trades",
  "market_history_trades",
  "market_option_instrument_family_trades",
  "market_mark_price_candles",
  "market_history_mark_price_candles",
  "market_index_tickers",
  "market_index_candles",
  "market_history_index_candles",
  "market_exchange_rate",
  "market_index_components",
  "market_platform_24_volume",
  "market_block_ticker",
  "market_block_tickers",
  "market_candles",
  "market_history_candles",
  "public_instruments",
  "public_underlying",
  "public_estimated_price",
  "public_delivery_exercise_history",
  "public_estimated_settlement_info",
  "public_settlement_history",
  "public_discount_rate_interest_free_quota",
  "public_opt_summary",
  "public_position_tiers",
  "public_mark_price",
  "public_interest_rate_loan_quota",
  "public_insurance_fund",
  "public_convert_contract_coin",
  "public_instrument_tick_bands",
  "public_premium_history",
  "public_block_trades",
  "public_funding_rate",
  "public_funding_rate_history",
  "public_open_interest",
  "public_time",
  "public_price_limit",
  "public_option_trades"
)

.api_GET_specs[.public_GET_spec_names] <- lapply(
  .api_GET_specs[.public_GET_spec_names],
  function(api) {
    api$auth <- FALSE
    api
  }
)
