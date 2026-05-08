#' Set Account Leverage
#'
#' Sets the leverage level for a specific trading instrument and margin mode.
#'
#' @param inst_id Instrument ID (e.g., \code{"BTC-USDT"}).
#' @param lever Leverage level to apply (as a string or numeric, e.g., \code{"10"}).
#' @param mgn_mode Margin mode: \code{"cross"} or \code{"isolated"}.
#' @param pos_side Optional. Position side: \code{"long"} or \code{"short"}. Required for isolated mode.
#' @param tz Timezone used for any timestamp parsing (default: \code{"Asia/Hong_Kong"}).
#' @param config API credential list with keys `api_key`, `secret_key`,
#'   and `passphrase`.
#'
#' @return A \code{data.frame} with leverage update confirmation (including instrument ID and leverage settings).
#'
#' @export
post_account_set_leverage <- function(inst_id, lever, mgn_mode, pos_side = NULL, tz = .okx_default_tz, config) {
  body <- list(instId = inst_id, lever = lever, mgnMode = mgn_mode)
  if (!is.null(pos_side) && mgn_mode == "isolated") {
    body$posSide <- pos_side
  }
  .posts$account_set_leverage(body_list = body, tz = tz, config = config)
}

#' Set Account Position Mode
#'
#' Set the account position mode.
#'
#' @param pos_mode Position mode. Use `long_short_mode` or `net_mode`.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` confirming the applied position mode.
#' @export
post_account_set_position_mode <- function(
  pos_mode,
  tz = .okx_default_tz,
  config
) {
  .posts$account_set_position_mode(
    body_list = list(posMode = pos_mode),
    tz = tz,
    config = config
  )
}

#' Set Account Fee Type
#'
#' Configure the fee charging mode for spot trading.
#'
#' @param fee_type Fee type string, typically `"0"` or `"1"`.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` confirming the applied fee type.
#' @export
post_account_set_fee_type <- function(fee_type, tz = .okx_default_tz, config) {
  .posts$account_set_fee_type(
    body_list = list(feeType = fee_type),
    tz = tz,
    config = config
  )
}

#' Set Account Greeks Display Type
#'
#' Configure whether Greeks are displayed in PA or BS mode.
#'
#' @param greeks_type Greeks display type, typically `"PA"` or `"BS"`.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` confirming the applied Greeks display type.
#' @export
post_account_set_greeks <- function(
  greeks_type,
  tz = .okx_default_tz,
  config
) {
  .posts$account_set_greeks(
    body_list = list(greeksType = greeks_type),
    tz = tz,
    config = config
  )
}

#' Set Account Auto Repay
#'
#' Enable or disable spot-mode auto repay.
#'
#' @param auto_repay Logical. Whether auto repay should be enabled.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` confirming the applied auto-repay setting.
#' @export
post_account_set_auto_repay <- function(
  auto_repay,
  tz = .okx_default_tz,
  config
) {
  .posts$account_set_auto_repay(
    body_list = list(autoRepay = isTRUE(auto_repay)),
    tz = tz,
    config = config
  )
}

#' Set Account Auto Loan
#'
#' Enable or disable automatic borrowing.
#'
#' @param auto_loan Logical. Whether auto loan should be enabled.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` confirming the applied auto-loan setting.
#' @export
post_account_set_auto_loan <- function(
  auto_loan = TRUE,
  tz = .okx_default_tz,
  config
) {
  .posts$account_set_auto_loan(
    body_list = list(autoLoan = isTRUE(auto_loan)),
    tz = tz,
    config = config
  )
}

#' Set Account Level
#'
#' Switch the account mode.
#'
#' @param acct_lv Account level string, such as `"1"`, `"2"`, `"3"`, or `"4"`.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` confirming the applied account level.
#' @export
post_account_set_account_level <- function(
  acct_lv,
  tz = .okx_default_tz,
  config
) {
  .posts$account_set_account_level(
    body_list = list(acctLv = acct_lv),
    tz = tz,
    config = config
  )
}

#' Set Account Collateral Assets
#'
#' Configure whether all or selected assets are treated as collateral.
#'
#' @param type Type of update, typically `"all"` or `"custom"`.
#' @param collateral_enabled Logical. Whether the selected assets should be
#'   collateral-enabled.
#' @param ccy_list Optional character vector of currencies. Required when
#'   `type = "custom"`.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` confirming the applied collateral asset setting.
#' @export
post_account_set_collateral_assets <- function(type, collateral_enabled, ccy_list = NULL, tz = .okx_default_tz, config) {
  body <- list(
    type = type,
    collateralEnabled = isTRUE(collateral_enabled)
  )
  if (!is.null(ccy_list)) {
    body$ccyList <- ccy_list
  }
  .posts$account_set_collateral_assets(
    body_list = body,
    tz = tz,
    config = config
  )
}

#' Adjust Position Margin Balance
#'
#' Increase or reduce margin for an existing position.
#'
#' @param inst_id Instrument ID.
#' @param pos_side Position side.
#' @param type Margin adjustment type, typically `"add"` or `"reduce"`.
#' @param amt Amount to add or reduce.
#' @param ccy Optional currency for isolated margin orders.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` describing the applied margin adjustment.
#' @export
post_account_position_margin_balance <- function(inst_id, pos_side, type, amt, ccy = NULL, tz = .okx_default_tz, config) {
  body <- list(
    instId = inst_id,
    posSide = pos_side,
    type = type,
    amt = amt
  )
  if (!is.null(ccy)) {
    body$ccy <- ccy
  }
  .posts$account_position_margin_balance(body_list = body, tz = tz, config = config)
}

#' Submit Spot Manual Borrow or Repay
#'
#' Manually borrow or repay under spot mode.
#'
#' @param ccy Currency.
#' @param side Action side, typically `"borrow"` or `"repay"`.
#' @param amt Amount.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` describing the executed borrow/repay request.
#' @export
post_account_spot_manual_borrow_repay <- function(ccy, side, amt, tz = .okx_default_tz, config) {
  .posts$account_spot_manual_borrow_repay(
    body_list = list(ccy = ccy, side = side, amt = amt),
    tz = tz,
    config = config
  )
}

#' Preset Account Level Switch
#'
#' Preset required values before switching account mode.
#'
#' @param acct_lv Target account level.
#' @param lever Optional leverage preset.
#' @param risk_offset_type Optional deprecated risk offset type field.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` describing the stored preset values.
#' @export
post_account_account_level_switch_preset <- function(acct_lv, lever = NULL, risk_offset_type = NULL, tz = .okx_default_tz, config) {
  body <- list(acctLv = acct_lv)
  if (!is.null(lever)) {
    body$lever <- lever
  }
  if (!is.null(risk_offset_type)) {
    body$riskOffsetType <- risk_offset_type
  }
  .posts$account_account_level_switch_preset(body_list = body, tz = tz, config = config)
}

#' Reset MMP Status
#'
#' Reset market maker protection status for an instrument family.
#'
#' @param inst_family Instrument family.
#' @param inst_type Optional instrument type. Defaults to `"OPTION"` on OKX.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` with the request result.
#' @export
post_account_mmp_reset <- function(inst_family, inst_type = NULL, tz = .okx_default_tz, config) {
  body <- list(instFamily = inst_family)
  if (!is.null(inst_type)) {
    body$instType <- inst_type
  }
  .posts$account_mmp_reset(body_list = body, tz = tz, config = config)
}

#' Configure MMP
#'
#' Set market maker protection thresholds for an options instrument family.
#'
#' @param inst_family Instrument family.
#' @param time_interval Time window in milliseconds.
#' @param frozen_interval Frozen interval in milliseconds.
#' @param qty_limit Quantity limit in number of contracts.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` describing the applied MMP configuration.
#' @export
post_account_mmp_config <- function(inst_family, time_interval, frozen_interval, qty_limit, tz = .okx_default_tz, config) {
  .posts$account_mmp_config(
    body_list = list(
      instFamily = inst_family,
      timeInterval = time_interval,
      frozenInterval = frozen_interval,
      qtyLimit = qty_limit
    ),
    tz = tz,
    config = config
  )
}

#' Move Positions Between Accounts
#'
#' Move positions between accounts under the same master account.
#'
#' @param from_acct Source account name.
#' @param to_acct Destination account name.
#' @param legs List of move-position leg objects in the documented OKX shape.
#' @param client_id Client-supplied request ID.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` describing the move-position request result.
#' @export
post_account_move_positions <- function(from_acct, to_acct, legs, client_id, tz = .okx_default_tz, config) {
  .okx_assert_non_empty_list(legs, "legs")
  .posts$account_move_positions(
    body_list = list(
      fromAcct = from_acct,
      toAcct = to_acct,
      legs = legs,
      clientId = client_id
    ),
    tz = tz,
    config = config
  )
}
