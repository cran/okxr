#---- Asset: POST Wrappers ----

.okx_asset_compact_body <- function(body_list) {
  body_list[!vapply(body_list, is.null, logical(1))]
}

#' Transfer Assets
#'
#' Transfer assets between funding, trading, and related accounts.
#'
#' @param ccy Currency to transfer.
#' @param amt Transfer amount.
#' @param from Source account code, such as `"6"` for funding or `"18"` for
#'   trading.
#' @param to Destination account code.
#' @param type Optional transfer type code. Defaults to `"0"` for an internal
#'   transfer within the same account.
#' @param sub_acct Optional sub-account name when the transfer type requires it.
#' @param loan_trans Optional logical. Whether the transfer should be treated
#'   as a loan transfer.
#' @param omit_pos_risk Optional logical. Whether to omit position risk checks
#'   where supported by OKX.
#' @param client_id Optional client-supplied transfer request ID.
#' @param tz Timezone used for any timestamp parsing.
#' @param config API credential list.
#'
#' @return A `data.frame` describing the submitted transfer request.
#' @export
post_asset_transfer <- function(ccy, amt, from, to, type = "0", sub_acct = NULL, loan_trans = NULL, omit_pos_risk = NULL, client_id = NULL, tz = .okx_default_tz, config) {
  if (identical(from, to)) {
    stop("`from` and `to` must be different account codes.", call. = FALSE)
  }
  body <- .okx_asset_compact_body(list(
    type = type,
    ccy = ccy,
    amt = amt,
    from = from,
    to = to,
    subAcct = sub_acct,
    loanTrans = if (is.null(loan_trans)) NULL else isTRUE(loan_trans),
    omitPosRisk = if (is.null(omit_pos_risk)) NULL else isTRUE(omit_pos_risk),
    clientId = client_id
  ))
  .posts$asset_transfer(body_list = body, tz = tz, config = config)
}

#' Submit an Asset Withdrawal
#'
#' Submit a withdrawal request from the OKX funding account.
#'
#' @param ccy Currency to withdraw.
#' @param amt Withdrawal amount.
#' @param dest Destination type code from the OKX API.
#' @param to_addr Destination wallet address.
#' @param chain Optional chain identifier, such as `"USDT-ERC20"`.
#' @param to_addr_type Optional destination address type code.
#' @param area_code Optional phone area code when required by OKX.
#' @param rcvr_info Optional named list in the documented `rcvrInfo` shape.
#' @param client_id Optional client-supplied withdrawal request ID.
#' @param tz Timezone used for any timestamp parsing.
#' @param config API credential list.
#'
#' @return A `data.frame` describing the submitted withdrawal request.
#' @export
post_asset_withdrawal <- function(ccy, amt, dest, to_addr, chain = NULL, to_addr_type = NULL, area_code = NULL, rcvr_info = NULL, client_id = NULL, tz = .okx_default_tz, config) {
  body <- .okx_asset_compact_body(list(
    ccy = ccy,
    amt = amt,
    dest = dest,
    toAddr = to_addr,
    chain = chain,
    toAddrType = to_addr_type,
    areaCode = area_code,
    rcvrInfo = rcvr_info,
    clientId = client_id
  ))
  .posts$asset_withdrawal(body_list = body, tz = tz, config = config)
}

#' Cancel an Asset Withdrawal
#'
#' Cancel a pending withdrawal request.
#'
#' @param wd_id Withdrawal request ID.
#' @param tz Timezone used for any timestamp parsing.
#' @param config API credential list.
#'
#' @return A `data.frame` confirming the cancelled withdrawal ID.
#' @export
post_asset_cancel_withdrawal <- function(wd_id, tz = .okx_default_tz, config) {
  .posts$asset_cancel_withdrawal(
    body_list = list(wdId = wd_id),
    tz = tz,
    config = config
  )
}

#' Estimate an Asset Convert Quote
#'
#' Request a quote for an asset conversion without executing the trade.
#'
#' @param base_ccy Base currency.
#' @param quote_ccy Quote currency.
#' @param side Quote side, such as `"buy"` or `"sell"`.
#' @param rfq_sz RFQ size.
#' @param rfq_sz_ccy Currency in which `rfq_sz` is specified.
#' @param cl_q_req_id Optional client quote request ID.
#' @param tag Optional request tag.
#' @param convert_mode Optional OKX convert mode.
#' @param tz Timezone used for any timestamp parsing.
#' @param config API credential list.
#'
#' @return A `data.frame` describing the estimated conversion quote.
#' @export
post_asset_convert_estimate_quote <- function(base_ccy, quote_ccy, side, rfq_sz, rfq_sz_ccy, cl_q_req_id = NULL, tag = NULL, convert_mode = NULL, tz = .okx_default_tz, config) {
  body <- .okx_asset_compact_body(list(
    baseCcy = base_ccy,
    quoteCcy = quote_ccy,
    side = side,
    rfqSz = rfq_sz,
    rfqSzCcy = rfq_sz_ccy,
    clQReqId = cl_q_req_id,
    tag = tag,
    convertMode = convert_mode
  ))
  .posts$asset_convert_estimate_quote(body_list = body, tz = tz, config = config)
}

#' Execute an Asset Convert Trade
#'
#' Execute a confirmed asset conversion against a previously quoted price.
#'
#' @param quote_id Quote ID returned by [post_asset_convert_estimate_quote()].
#' @param base_ccy Base currency.
#' @param quote_ccy Quote currency.
#' @param side Trade side, such as `"buy"` or `"sell"`.
#' @param sz Trade size.
#' @param sz_ccy Currency in which `sz` is specified.
#' @param cl_t_req_id Optional client trade request ID.
#' @param tag Optional request tag.
#' @param convert_mode Optional OKX convert mode.
#' @param tz Timezone used for any timestamp parsing.
#' @param config API credential list.
#'
#' @return A `data.frame` describing the executed conversion trade.
#' @export
post_asset_convert_trade <- function(quote_id, base_ccy, quote_ccy, side, sz, sz_ccy, cl_t_req_id = NULL, tag = NULL, convert_mode = NULL, tz = .okx_default_tz, config) {
  body <- .okx_asset_compact_body(list(
    quoteId = quote_id,
    baseCcy = base_ccy,
    quoteCcy = quote_ccy,
    side = side,
    sz = sz,
    szCcy = sz_ccy,
    clTReqId = cl_t_req_id,
    tag = tag,
    convertMode = convert_mode
  ))
  .posts$asset_convert_trade(body_list = body, tz = tz, config = config)
}
