#---- Asset: GET Wrappers ----

#' Get asset balances
#'
#' Retrieves the available, total, and frozen balance for each asset in the account.
#'
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} with balances per currency.
#'
#' @export
get_asset_balances <- function(config, tz = .okx_default_tz) {
  .gets$asset_balances(query_string = "", tz = tz, config = config)
}

#' Get asset deposit history
#'
#' Retrieves a record of all asset deposits made to your account.
#'
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} with deposit timestamps, amounts, and currencies.
#'
#' @export
get_asset_deposit_history <- function(config, tz = .okx_default_tz) {
  .gets$asset_deposit_history(query_string = "", tz = tz, config = config)
}

#' Get asset withdrawal history
#'
#' Retrieves a record of all asset withdrawals from your account.
#'
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} with withdrawal timestamps, amounts, and currencies.
#'
#' @export
get_asset_withdrawal_history <- function(config, tz = .okx_default_tz) {
  .gets$asset_withdrawal_history(query_string = "", tz = tz, config = config)
}

#' Get funding currencies
#'
#' Retrieve currencies available to the current account.
#'
#' @param ccy Character or `NULL`. Single currency or comma-separated currencies.
#' @param config API credentials as a list with \code{api_key}, \code{secret_key},
#'   and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} with currency and chain metadata.
#'
#' @export
get_asset_currencies <- function(ccy = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(ccy = ccy)
  .gets$asset_currencies(query_string = query_string, tz = tz, config = config)
}

#' Get deposit address
#'
#' Retrieve deposit addresses for a currency.
#'
#' @param ccy Character. Currency, e.g. \code{"BTC"} or \code{"USDT"}.
#' @param config API credentials as a list with \code{api_key}, \code{secret_key},
#'   and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} with deposit address rows.
#'
#' @export
get_asset_deposit_address <- function(ccy, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(ccy = ccy)
  .gets$asset_deposit_address(query_string = query_string, tz = tz, config = config)
}
