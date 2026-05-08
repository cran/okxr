#---- Trade: POST Wrappers ----

.okx_compact_body <- function(body_list) {
  body_list[!vapply(body_list, is.null, logical(1))]
}

.okx_trade_order_body <- function(
  inst_id,
  td_mode,
  side,
  ord_type,
  sz,
  ccy = NULL,
  cl_ord_id = NULL,
  tag = NULL,
  pos_side = NULL,
  px = NULL,
  reduce_only = NULL,
  tgt_ccy = NULL,
  ban_amend = NULL,
  px_amend_type = NULL,
  trade_quote_ccy = NULL,
  stp_mode = NULL,
  attach_algo_ords = NULL,
  px_usd = NULL,
  px_vol = NULL,
  speed_bump = NULL,
  outcome = NULL,
  is_elp_taker_access = NULL
) {
  .okx_compact_body(list(
    instId = inst_id,
    tdMode = td_mode,
    side = side,
    ordType = ord_type,
    ccy = ccy,
    clOrdId = cl_ord_id,
    tag = tag,
    posSide = pos_side,
    px = px,
    sz = sz,
    reduceOnly = if (is.null(reduce_only)) NULL else tolower(as.character(reduce_only)),
    tgtCcy = tgt_ccy,
    banAmend = if (is.null(ban_amend)) NULL else tolower(as.character(ban_amend)),
    pxAmendType = px_amend_type,
    tradeQuoteCcy = trade_quote_ccy,
    stpMode = stp_mode,
    attachAlgoOrds = attach_algo_ords,
    pxUsd = px_usd,
    pxVol = px_vol,
    speedBump = speed_bump,
    outcome = outcome,
    isElpTakerAccess = if (is.null(is_elp_taker_access)) NULL else tolower(as.character(is_elp_taker_access))
  ))
}

.okx_trade_amend_body <- function(
  inst_id,
  ord_id = NULL,
  cl_ord_id = NULL,
  req_id = NULL,
  new_sz = NULL,
  new_px = NULL,
  cxl_on_fail = NULL,
  new_px_usd = NULL,
  new_px_vol = NULL,
  px_amend_type = NULL,
  attach_algo_ords = NULL,
  speed_bump = NULL
) {
  .okx_compact_body(list(
    instId = inst_id,
    ordId = ord_id,
    clOrdId = cl_ord_id,
    reqId = req_id,
    newSz = new_sz,
    newPx = new_px,
    cxlOnFail = if (is.null(cxl_on_fail)) NULL else tolower(as.character(cxl_on_fail)),
    newPxUsd = new_px_usd,
    newPxVol = new_px_vol,
    pxAmendType = px_amend_type,
    attachAlgoOrds = attach_algo_ords,
    speedBump = speed_bump
  ))
}

.okx_trade_algo_cancel_body <- function(
  inst_id,
  algo_id = NULL,
  algo_cl_ord_id = NULL
) {
  .okx_compact_body(list(
    instId = inst_id,
    algoId = algo_id,
    algoClOrdId = algo_cl_ord_id
  ))
}

.okx_trade_algo_amend_body <- function(
  inst_id,
  algo_id = NULL,
  algo_cl_ord_id = NULL,
  cxl_on_fail = NULL,
  req_id = NULL,
  new_sz = NULL,
  new_tp_trigger_px = NULL,
  new_tp_ord_px = NULL,
  new_sl_trigger_px = NULL,
  new_sl_ord_px = NULL,
  new_tp_trigger_px_type = NULL,
  new_sl_trigger_px_type = NULL,
  new_trigger_px = NULL,
  new_ord_px = NULL,
  new_trigger_px_type = NULL,
  attach_algo_ords = NULL
) {
  .okx_compact_body(list(
    instId = inst_id,
    algoId = algo_id,
    algoClOrdId = algo_cl_ord_id,
    cxlOnFail = if (is.null(cxl_on_fail)) NULL else tolower(as.character(cxl_on_fail)),
    reqId = req_id,
    newSz = new_sz,
    newTpTriggerPx = new_tp_trigger_px,
    newTpOrdPx = new_tp_ord_px,
    newSlTriggerPx = new_sl_trigger_px,
    newSlOrdPx = new_sl_ord_px,
    newTpTriggerPxType = new_tp_trigger_px_type,
    newSlTriggerPxType = new_sl_trigger_px_type,
    newTriggerPx = new_trigger_px,
    newOrdPx = new_ord_px,
    newTriggerPxType = new_trigger_px_type,
    attachAlgoOrds = attach_algo_ords
  ))
}

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

  body_list <- .okx_trade_order_body(
    inst_id = inst_id,
    td_mode = td_mode,
    side = side,
    ord_type = ord_type,
    sz = sz,
    pos_side = pos_side,
    px = px,
    reduce_only = reduce_only,
    tgt_ccy = tgt_ccy,
    cl_ord_id = cl_ord_id,
    tag = tag
  )

  .posts$trade_order(body_list = body_list, tz = tz, config = config)
}

#' Cancel a Trade Order
#'
#' Submits a cancellation request for a previously placed trade order.
#'
#' @param inst_id Instrument ID (e.g., \code{"BTC-USDT"}).
#' @param ord_id Optional OKX order ID to cancel.
#' @param cl_ord_id Optional client order ID to cancel. Provide this or
#'   `ord_id`.
#' @param config A list with API credentials: \code{api_key}, \code{secret_key}, \code{passphrase}.
#' @param tz Timezone for parsing any timestamps (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} containing cancellation result and timestamp.
#'
#' @export
post_trade_cancel_order <- function(inst_id, ord_id = NULL, cl_ord_id = NULL, config, tz = .okx_default_tz) {
  .okx_assert_exactly_one_present(ord_id, cl_ord_id, names = c("ord_id", "cl_ord_id"))
  .posts$trade_cancel_order(
    body_list = .okx_compact_body(list(instId = inst_id, ordId = ord_id, clOrdId = cl_ord_id)),
    tz = tz,
    config = config
  )
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

#' Place Multiple Trade Orders
#'
#' Submit multiple trade orders in one request.
#'
#' @param orders List of order specs using the snake_case names from
#'   [post_trade_order()].
#' @param config A list with API credentials.
#' @param tz Timezone for parsing response timestamps.
#'
#' @return A `data.frame` with one row per submitted order result.
#' @export
post_trade_batch_orders <- function(orders, config, tz = .okx_default_tz) {
  .okx_assert_non_empty_list(orders, "orders")
  body_list <- lapply(
    seq_along(orders),
    function(i) {
      order <- orders[[i]]
      .okx_assert_has_fields(order, c("inst_id", "td_mode", "side", "ord_type", "sz"), paste0("orders[[", i, "]]"))
      if (is.null(order$cl_ord_id)) {
        order$cl_ord_id <- .okx_generate_client_order_id()
      }
      do.call(.okx_trade_order_body, order)
    }
  )
  .posts$trade_batch_orders(body_list = body_list, tz = tz, config = config)
}

#' Cancel Multiple Trade Orders
#'
#' Submit a batch cancellation request for incomplete orders.
#'
#' @param orders List of cancellation specification lists containing `inst_id`
#'   plus either `ord_id` or `cl_ord_id`.
#' @param config A list with API credentials.
#' @param tz Timezone for parsing response timestamps.
#'
#' @return A `data.frame` with one row per cancellation result.
#' @export
post_trade_cancel_batch_orders <- function(
  orders,
  config,
  tz = .okx_default_tz
) {
  .okx_assert_non_empty_list(orders, "orders")
  body_list <- lapply(
    seq_along(orders),
    function(i) {
      order <- orders[[i]]
      .okx_assert_has_fields(order, "inst_id", paste0("orders[[", i, "]]"))
      .okx_assert_exactly_one_present(order$ord_id, order$cl_ord_id, names = c("ord_id", "cl_ord_id"))
      .okx_compact_body(list(
        instId = order$inst_id,
        ordId = order$ord_id,
        clOrdId = order$cl_ord_id
      ))
    }
  )
  .posts$trade_cancel_batch_orders(body_list = body_list, tz = tz, config = config)
}

#' Amend a Trade Order
#'
#' Submit an amendment request for an incomplete order.
#'
#' @param inst_id Instrument ID.
#' @param ord_id Order ID. Optional if `cl_ord_id` is supplied.
#' @param cl_ord_id Client order ID. Optional if `ord_id` is supplied.
#' @param req_id Optional client amendment request ID.
#' @param new_sz Optional new total order size.
#' @param new_px Optional new price.
#' @param cxl_on_fail Optional logical. Whether to cancel the order if the
#'   amendment fails.
#' @param new_px_usd Optional new option order USD price.
#' @param new_px_vol Optional new option order implied volatility price.
#' @param px_amend_type Optional price amendment mode.
#' @param attach_algo_ords Optional attached TP/SL amendment list.
#' @param speed_bump Optional event-contract speed bump.
#' @param config A list with API credentials.
#' @param tz Timezone for parsing response timestamps.
#'
#' @return A `data.frame` describing the amendment request result.
#' @export
post_trade_amend_order <- function(inst_id, ord_id = NULL, cl_ord_id = NULL, req_id = NULL, new_sz = NULL, new_px = NULL, cxl_on_fail = NULL, new_px_usd = NULL, new_px_vol = NULL, px_amend_type = NULL, attach_algo_ords = NULL, speed_bump = NULL, config, tz = .okx_default_tz) {
  .okx_assert_exactly_one_present(ord_id, cl_ord_id, names = c("ord_id", "cl_ord_id"))
  .okx_assert_any_field_present(
    list(
      new_sz = new_sz,
      new_px = new_px,
      cxl_on_fail = cxl_on_fail,
      new_px_usd = new_px_usd,
      new_px_vol = new_px_vol,
      px_amend_type = px_amend_type,
      attach_algo_ords = attach_algo_ords,
      speed_bump = speed_bump
    ),
    c("new_sz", "new_px", "cxl_on_fail", "new_px_usd", "new_px_vol", "px_amend_type", "attach_algo_ords", "speed_bump"),
    "amendment request"
  )
  body_list <- .okx_trade_amend_body(
    inst_id = inst_id,
    ord_id = ord_id,
    cl_ord_id = cl_ord_id,
    req_id = req_id,
    new_sz = new_sz,
    new_px = new_px,
    cxl_on_fail = cxl_on_fail,
    new_px_usd = new_px_usd,
    new_px_vol = new_px_vol,
    px_amend_type = px_amend_type,
    attach_algo_ords = attach_algo_ords,
    speed_bump = speed_bump
  )
  .posts$trade_amend_order(body_list = body_list, tz = tz, config = config)
}

#' Amend Multiple Trade Orders
#'
#' Submit multiple amendment requests in one request.
#'
#' @param orders List of amendment specs using the names from
#'   [post_trade_amend_order()].
#' @param config A list with API credentials.
#' @param tz Timezone for parsing response timestamps.
#'
#' @return A `data.frame` with one row per amendment result.
#' @export
post_trade_amend_batch_orders <- function(
  orders,
  config,
  tz = .okx_default_tz
) {
  .okx_assert_non_empty_list(orders, "orders")
  body_list <- lapply(
    seq_along(orders),
    function(i) {
      order <- orders[[i]]
      .okx_assert_has_fields(order, "inst_id", paste0("orders[[", i, "]]"))
      .okx_assert_exactly_one_present(order$ord_id, order$cl_ord_id, names = c("ord_id", "cl_ord_id"))
      .okx_assert_any_field_present(
        order,
        c("new_sz", "new_px", "cxl_on_fail", "new_px_usd", "new_px_vol", "px_amend_type", "attach_algo_ords", "speed_bump"),
        paste0("orders[[", i, "]]")
      )
      do.call(.okx_trade_amend_body, order)
    }
  )
  .posts$trade_amend_batch_orders(body_list = body_list, tz = tz, config = config)
}

#' Precheck a Trade Order
#'
#' Submit an order precheck request without placing the order.
#'
#' @param inst_id Instrument ID.
#' @param td_mode Trade mode.
#' @param side Order side.
#' @param ord_type Order type.
#' @param sz Order size.
#' @param ccy Optional margin currency.
#' @param cl_ord_id Optional client order ID.
#' @param tag Optional order tag.
#' @param pos_side Optional position side.
#' @param px Optional order price.
#' @param reduce_only Optional logical reduce-only flag.
#' @param tgt_ccy Optional target currency mode.
#' @param attach_algo_ords Optional attached TP/SL list.
#' @param speed_bump Optional event-contract speed bump.
#' @param outcome Optional event-contract outcome.
#' @param config A list with API credentials.
#' @param tz Timezone for parsing response timestamps.
#'
#' @return A `data.frame` with projected account metrics after the precheck.
#' @export
post_trade_order_precheck <- function(inst_id, td_mode, side, ord_type, sz, ccy = NULL, cl_ord_id = NULL, tag = NULL, pos_side = NULL, px = NULL, reduce_only = NULL, tgt_ccy = NULL, attach_algo_ords = NULL, speed_bump = NULL, outcome = NULL, config, tz = .okx_default_tz) {
  body_list <- .okx_trade_order_body(
    inst_id = inst_id,
    td_mode = td_mode,
    side = side,
    ord_type = ord_type,
    sz = sz,
    ccy = ccy,
    cl_ord_id = cl_ord_id,
    tag = tag,
    pos_side = pos_side,
    px = px,
    reduce_only = reduce_only,
    tgt_ccy = tgt_ccy,
    attach_algo_ords = attach_algo_ords,
    speed_bump = speed_bump,
    outcome = outcome
  )
  .posts$trade_order_precheck(body_list = body_list, tz = tz, config = config)
}

#' Set Cancel-All-After
#'
#' Set or disable the cancel-all-after countdown.
#'
#' @param time_out Character or numeric. Countdown in seconds. `0` disables it.
#' @param tag Optional cancel-all-after tag scope.
#' @param config A list with API credentials.
#' @param tz Timezone for parsing response timestamps.
#'
#' @return A `data.frame` with the configured trigger time and tag.
#' @export
post_trade_cancel_all_after <- function(
  time_out,
  tag = NULL,
  config,
  tz = .okx_default_tz
) {
  body_list <- .okx_compact_body(list(timeOut = as.character(time_out), tag = tag))
  .posts$trade_cancel_all_after(body_list = body_list, tz = tz, config = config)
}

#' Cancel Multiple Algo Orders
#'
#' Cancel up to 10 unfilled algo orders in one request.
#'
#' @param orders List of cancellation specification lists containing `inst_id`
#'   plus either `algo_id` or `algo_cl_ord_id`.
#' @param config A list with API credentials.
#' @param tz Timezone for parsing response timestamps.
#'
#' @return A `data.frame` with one row per algo cancellation result.
#' @export
post_trade_cancel_algos <- function(orders, config, tz = .okx_default_tz) {
  .okx_assert_non_empty_list(orders, "orders")
  body_list <- lapply(
    seq_along(orders),
    function(i) {
      order <- orders[[i]]
      .okx_assert_has_fields(order, "inst_id", paste0("orders[[", i, "]]"))
      .okx_assert_exactly_one_present(order$algo_id, order$algo_cl_ord_id, names = c("algo_id", "algo_cl_ord_id"))
      do.call(.okx_trade_algo_cancel_body, order)
    }
  )
  .posts$trade_cancel_algos(body_list = body_list, tz = tz, config = config)
}

#' Amend an Algo Order
#'
#' Amend a supported unfilled algo order.
#'
#' @param inst_id Instrument ID.
#' @param algo_id Algo order ID. Optional if `algo_cl_ord_id` is supplied.
#' @param algo_cl_ord_id Client-supplied algo ID. Optional if `algo_id` is supplied.
#' @param cxl_on_fail Optional logical. Whether to cancel the order if the
#'   amendment fails.
#' @param req_id Optional client amendment request ID.
#' @param new_sz Optional new quantity after amendment.
#' @param new_tp_trigger_px Optional new take-profit trigger price.
#' @param new_tp_ord_px Optional new take-profit order price.
#' @param new_sl_trigger_px Optional new stop-loss trigger price.
#' @param new_sl_ord_px Optional new stop-loss order price.
#' @param new_tp_trigger_px_type Optional new take-profit trigger price type.
#' @param new_sl_trigger_px_type Optional new stop-loss trigger price type.
#' @param new_trigger_px Optional new trigger price for trigger orders.
#' @param new_ord_px Optional new order price for trigger orders.
#' @param new_trigger_px_type Optional new trigger price type for trigger orders.
#' @param attach_algo_ords Optional attached TP/SL amendment list.
#' @param config A list with API credentials.
#' @param tz Timezone for parsing response timestamps.
#'
#' @return A `data.frame` describing the algo amendment result.
#' @export
post_trade_amend_algos <- function(inst_id, algo_id = NULL, algo_cl_ord_id = NULL, cxl_on_fail = NULL, req_id = NULL, new_sz = NULL, new_tp_trigger_px = NULL, new_tp_ord_px = NULL, new_sl_trigger_px = NULL, new_sl_ord_px = NULL, new_tp_trigger_px_type = NULL, new_sl_trigger_px_type = NULL, new_trigger_px = NULL, new_ord_px = NULL, new_trigger_px_type = NULL, attach_algo_ords = NULL, config, tz = .okx_default_tz) {
  .okx_assert_exactly_one_present(algo_id, algo_cl_ord_id, names = c("algo_id", "algo_cl_ord_id"))
  .okx_assert_any_field_present(
    list(
      cxl_on_fail = cxl_on_fail,
      new_sz = new_sz,
      new_tp_trigger_px = new_tp_trigger_px,
      new_tp_ord_px = new_tp_ord_px,
      new_sl_trigger_px = new_sl_trigger_px,
      new_sl_ord_px = new_sl_ord_px,
      new_tp_trigger_px_type = new_tp_trigger_px_type,
      new_sl_trigger_px_type = new_sl_trigger_px_type,
      new_trigger_px = new_trigger_px,
      new_ord_px = new_ord_px,
      new_trigger_px_type = new_trigger_px_type,
      attach_algo_ords = attach_algo_ords
    ),
    c("cxl_on_fail", "new_sz", "new_tp_trigger_px", "new_tp_ord_px", "new_sl_trigger_px", "new_sl_ord_px", "new_tp_trigger_px_type", "new_sl_trigger_px_type", "new_trigger_px", "new_ord_px", "new_trigger_px_type", "attach_algo_ords"),
    "algo amendment request"
  )
  body_list <- .okx_trade_algo_amend_body(
    inst_id = inst_id,
    algo_id = algo_id,
    algo_cl_ord_id = algo_cl_ord_id,
    cxl_on_fail = cxl_on_fail,
    req_id = req_id,
    new_sz = new_sz,
    new_tp_trigger_px = new_tp_trigger_px,
    new_tp_ord_px = new_tp_ord_px,
    new_sl_trigger_px = new_sl_trigger_px,
    new_sl_ord_px = new_sl_ord_px,
    new_tp_trigger_px_type = new_tp_trigger_px_type,
    new_sl_trigger_px_type = new_sl_trigger_px_type,
    new_trigger_px = new_trigger_px,
    new_ord_px = new_ord_px,
    new_trigger_px_type = new_trigger_px_type,
    attach_algo_ords = attach_algo_ords
  )
  .posts$trade_amend_algos(body_list = body_list, tz = tz, config = config)
}

#' Mass Cancel MMP Orders
#'
#' Cancel all MMP pending orders for an options instrument family.
#'
#' @param inst_type Instrument type. Currently `OPTION`.
#' @param inst_family Instrument family.
#' @param lock_interval Optional lock interval in milliseconds.
#' @param config A list with API credentials.
#' @param tz Timezone for parsing response timestamps.
#'
#' @return A `data.frame` with the request result.
#' @export
post_trade_mass_cancel <- function(inst_type, inst_family, lock_interval = NULL, config, tz = .okx_default_tz) {
  body_list <- .okx_compact_body(list(
    instType = inst_type,
    instFamily = inst_family,
    lockInterval = lock_interval
  ))
  .posts$trade_mass_cancel(body_list = body_list, tz = tz, config = config)
}
