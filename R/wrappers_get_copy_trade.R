#' Get copy trading settings
#'
#' Retrieve your account's copy trading configuration.
#'
#' @details
#' Wraps `/api/v5/copytrading/copy-settings`. Returns one row with the
#' current copy mode and copy state for the given `unique_code`.
#'
#' @param unique_code Character. Lead trader unique code.
#' @param uniqueCode Deprecated alias for `unique_code`.
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with fields like `copyMode` and `copyState`.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' get_copy_trade_settings(unique_code = "1129E65755274C36", config = cfg)
#' }
#'
#' @seealso [get_copy_trade_my_leaders()], [get_copy_trade_current_subpos()]
#' @family okxr-copytrading
#' @note Since okxr 0.1.2
#' @export
get_copy_trade_settings <- function(unique_code, config, tz = .okx_default_tz, uniqueCode = unique_code) {
  query_string <- .okx_build_query(uniqueCode = uniqueCode)
  .gets$copy_trade_settings(query_string = query_string, tz = tz, config = config)
}

#' Get my lead traders
#'
#' Retrieve the list of lead traders you are currently copying.
#'
#' @details
#' Wraps `/api/v5/copytrading/current-lead-traders`. Returns one row per
#' lead trader followed by your account.
#'
#' @param inst_type Character or `NULL`. Filter by instrument type
#'   (e.g., `"SWAP"`, `"MARGIN"`, `"SPOT"`). If `NULL`, returns all.
#' @param instType Deprecated alias for `inst_type`.
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with fields such as `nickName` and `uniqueCode`.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' get_copy_trade_my_leaders(inst_type = "SWAP", config = cfg)
#' }
#'
#' @seealso [get_copy_trade_settings()], [get_copy_trade_current_subpos()]
#' @family okxr-copytrading
#' @note Since okxr 0.1.2
#' @export
get_copy_trade_my_leaders <- function(inst_type = NULL, config, tz = .okx_default_tz, instType = inst_type) {
  query_string <- .okx_build_query(instType = instType)
  .gets$copy_trade_my_leaders(query_string = query_string, tz = tz, config = config)
}

#' Get current copy trading subpositions
#'
#' Retrieve your currently active subpositions under copy trading.
#'
#' @details
#' Wraps `/api/v5/copytrading/current-subpositions`. Returns one row per
#' subposition, associated with the relevant lead trader.
#'
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with fields like `instId` and `uniqueCode`.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' get_copy_trade_current_subpos(config = cfg)
#' }
#'
#' @seealso [get_copy_trade_historical_subpos()]
#' @family okxr-copytrading
#' @note Since okxr 0.1.2
#' @export
get_copy_trade_current_subpos <- function(config, tz = .okx_default_tz) {
  .gets$copy_trade_current_subpos(query_string = "", tz = tz, config = config)
}

#' Get historical copy trading subpositions
#'
#' Retrieve your historical copy trading subpositions.
#'
#' @details
#' Wraps `/api/v5/copytrading/subpositions-history`. Returns one row per
#' closed or historical subposition.
#'
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with fields like `instId` and `uniqueCode`.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' hist <- get_copy_trade_historical_subpos(config = cfg)
#' head(hist)
#' }
#'
#' @seealso [get_copy_trade_current_subpos()]
#' @family okxr-copytrading
#' @note Since okxr 0.1.2
#' @export
get_copy_trade_historical_subpos <- function(config, tz = .okx_default_tz) {
  .gets$copy_trade_historical_subpos(query_string = "", tz = tz, config = config)
}
