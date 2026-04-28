#---- Trade: POST Wrappers ----

#' Place a Trade Order
#'
#' Submits a trade order to the OKX exchange.
#'
#' @param inst_id Instrument ID (e.g., \code{"BTC-USDT"}).
#' @param td_mode Trade mode: \code{"cross"} or \code{"isolated"}.
#' @param side Order side: \code{"buy"} or \code{"sell"}.
#' @param ord_type Order type: \code{"limit"}, \code{"market"}, etc.
#' @param sz Size of the order (quantity to buy/sell).
#' @param pos_side Optional. Position side: \code{"long"} or \code{"short"}.
#' @param px Optional. Price (required for limit orders).
#' @param reduce_only Optional. Logical flag to indicate a reduce-only order.
#' @param tgt_ccy Optional. Quote currency (e.g., \code{"base"}, \code{"quote"}).
#' @param cl_ord_id Optional. Custom client order ID (auto-generated if NULL).
#' @param tag Optional. Tag used for identifying the strategy or bot.
#' @param config A list with API credentials: \code{api_key}, \code{secret_key}, \code{passphrase}.
#' @param tz Timezone for parsing any timestamps (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} containing fields like order ID, client order ID, and timestamp.
#'
#' @export
post_trade_order <- function(
  inst_id,
  td_mode,
  side,
  ord_type,
  sz,
  pos_side = NULL,
  px = NULL,
  reduce_only = NULL,
  tgt_ccy = NULL,
  cl_ord_id = NULL,
  tag = NULL,
  config,
  tz = .okx_default_tz
) {
  if (is.null(cl_ord_id)) {
    cl_ord_id <- .okx_generate_client_order_id()
  }

  body_list <- list(
    instId = inst_id,
    tdMode = td_mode,
    side = side,
    ordType = ord_type,
    clOrdId = cl_ord_id,
    sz = sz
  )
  if (!is.null(pos_side)) body_list$posSide <- pos_side
  if (!is.null(px)) body_list$px <- px
  if (!is.null(reduce_only)) body_list$reduceOnly <- tolower(as.character(reduce_only))
  if (!is.null(tgt_ccy)) body_list$tgtCcy <- tgt_ccy
  if (!is.null(tag)) body_list$tag <- tag

  .posts$trade_order(body_list = body_list, tz = tz, config = config)
}

#' Cancel a Trade Order
#'
#' Submits a cancellation request for a previously placed trade order.
#'
#' @param inst_id Instrument ID (e.g., \code{"BTC-USDT"}).
#' @param ord_id Order ID to cancel. Alternatively, you can modify the function to accept \code{clOrdId}.
#' @param config A list with API credentials: \code{api_key}, \code{secret_key}, \code{passphrase}.
#' @param tz Timezone for parsing any timestamps (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} containing cancellation result and timestamp.
#'
#' @export
post_trade_cancel_order <- function(inst_id, ord_id, config, tz = .okx_default_tz) {
  .posts$trade_cancel_order(body_list = list(instId = inst_id, ordId = ord_id), tz = tz, config = config)
}

#' Close a Position
#'
#' Submits a request to close a position for a given instrument and position side.
#'
#' @param inst_id Instrument ID (e.g., \code{"BTC-USDT"}).
#' @param mgn_mode Margin mode: \code{"cross"} or \code{"isolated"}.
#' @param pos_side Position side to close: \code{"long"} or \code{"short"}.
#' @param tz Timezone for parsing any timestamps (default: \code{"Asia/Hong_Kong"}).
#' @param config A list with API credentials: \code{api_key}, \code{secret_key}, \code{passphrase}.
#'
#' @return A \code{data.frame} with close position confirmation details.
#'
#' @export
post_trade_close_position <- function(inst_id, mgn_mode, pos_side, tz = .okx_default_tz, config) {
  .posts$trade_close_position(body_list = list(instId = inst_id, mgnMode = mgn_mode, posSide = pos_side), tz = tz, config = config)
}
