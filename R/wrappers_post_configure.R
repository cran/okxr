#' Set Account Leverage
#'
#' Sets the leverage level for a specific trading instrument and margin mode.
#'
#' @param inst_id Instrument ID (e.g., \code{"BTC-USDT"}).
#' @param lever Leverage level to apply (as a string or numeric, e.g., \code{"10"}).
#' @param mgn_mode Margin mode: \code{"cross"} or \code{"isolated"}.
#' @param pos_side Optional. Position side: \code{"long"} or \code{"short"}. Required for isolated mode.
#' @param tz Timezone used for any timestamp parsing (default: \code{"Asia/Hong_Kong"}).
#' @param config A list containing API credentials: \code{api_key}, \code{secret_key}, and \code{passphrase}.
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
