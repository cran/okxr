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
#' @param ccy Character or `NULL`. Currency filter.
#' @param dep_id Character or `NULL`. Deposit ID filter.
#' @param from_wd_id Character or `NULL`. Source withdrawal ID filter.
#' @param tx_id Character or `NULL`. Transaction hash filter.
#' @param type Character or `NULL`. Deposit type filter.
#' @param state Character or `NULL`. Deposit state filter.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} with deposit history rows and detailed transfer metadata.
#'
#' @export
get_asset_deposit_history <- function(ccy = NULL, dep_id = NULL, from_wd_id = NULL, tx_id = NULL, type = NULL, state = NULL, after = NULL, before = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    ccy = ccy,
    depId = dep_id,
    fromWdId = from_wd_id,
    txId = tx_id,
    type = type,
    state = state,
    after = after,
    before = before,
    limit = limit
  )
  .gets$asset_deposit_history(query_string = query_string, tz = tz, config = config)
}

#' Get asset withdrawal history
#'
#' Retrieves a record of all asset withdrawals from your account.
#'
#' @param ccy Character or `NULL`. Currency filter.
#' @param wd_id Character or `NULL`. Withdrawal ID filter.
#' @param client_id Character or `NULL`. Client withdrawal ID filter.
#' @param tx_id Character or `NULL`. Transaction hash filter.
#' @param type Character or `NULL`. Withdrawal type filter.
#' @param state Character or `NULL`. Withdrawal state filter.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} with withdrawal history rows and detailed transfer metadata.
#'
#' @export
get_asset_withdrawal_history <- function(ccy = NULL, wd_id = NULL, client_id = NULL, tx_id = NULL, type = NULL, state = NULL, after = NULL, before = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    ccy = ccy,
    wdId = wd_id,
    clientId = client_id,
    txId = tx_id,
    type = type,
    state = state,
    after = after,
    before = before,
    limit = limit
  )
  .gets$asset_withdrawal_history(query_string = query_string, tz = tz, config = config)
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

#' Get non-tradable assets
#'
#' Retrieve balances and withdrawal metadata for non-tradable assets.
#'
#' @param ccy Character or `NULL`. Currency filter.
#' @param config API credentials as a list with \code{api_key}, \code{secret_key},
#'   and \code{passphrase}.
#' @param tz Timezone string.
#'
#' @return A \code{data.frame} with non-tradable asset rows.
#' @export
get_asset_non_tradable_assets <- function(
  ccy = NULL,
  config,
  tz = .okx_default_tz
) {
  query_string <- .okx_build_query(ccy = ccy)
  .gets$asset_non_tradable_assets(query_string = query_string, tz = tz, config = config)
}

#' Get asset valuation
#'
#' Retrieve total account valuation for funding assets.
#'
#' @param ccy Character or `NULL`. Valuation currency filter.
#' @param config API credentials as a list with \code{api_key}, \code{secret_key},
#'   and \code{passphrase}.
#' @param tz Timezone string.
#'
#' @return A \code{data.frame} with valuation summary rows.
#' @export
get_asset_asset_valuation <- function(
  ccy = NULL,
  config,
  tz = .okx_default_tz
) {
  query_string <- .okx_build_query(ccy = ccy)
  .gets$asset_asset_valuation(query_string = query_string, tz = tz, config = config)
}

#' Get asset transfer state
#'
#' Retrieve the state of a funding transfer.
#'
#' @param trans_id Character or `NULL`. Transfer ID.
#' @param client_id Character or `NULL`. Client-supplied transfer ID.
#' @param type Character or `NULL`. Transfer type.
#' @param config API credentials as a list with \code{api_key}, \code{secret_key},
#'   and \code{passphrase}.
#' @param tz Timezone string.
#'
#' @return A \code{data.frame} with transfer state rows.
#' @export
get_asset_transfer_state <- function(trans_id = NULL, client_id = NULL, type = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(transId = trans_id, clientId = client_id, type = type)
  .gets$asset_transfer_state(query_string = query_string, tz = tz, config = config)
}

#' Get asset bills
#'
#' Retrieve recent funding account bills.
#'
#' @param ccy Character or `NULL`. Currency filter.
#' @param type Character or `NULL`. Bill type filter.
#' @param client_id Character or `NULL`. Client-supplied transfer or withdrawal ID.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of results to request.
#' @param config API credentials as a list with \code{api_key}, \code{secret_key},
#'   and \code{passphrase}.
#' @param tz Timezone string.
#'
#' @return A \code{data.frame} with asset bill rows.
#' @export
get_asset_bills <- function(ccy = NULL, type = NULL, client_id = NULL, after = NULL, before = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    ccy = ccy,
    type = type,
    clientId = client_id,
    after = after,
    before = before,
    limit = limit
  )
  .gets$asset_bills(query_string = query_string, tz = tz, config = config)
}

#' Get asset bills history
#'
#' Retrieve historical funding account bills.
#'
#' @param ccy Character or `NULL`. Currency filter.
#' @param type Character or `NULL`. Bill type filter.
#' @param client_id Character or `NULL`. Client-supplied transfer or withdrawal ID.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of results to request.
#' @param paging_type Character or `NULL`. Paging type selector.
#' @param config API credentials as a list with \code{api_key}, \code{secret_key},
#'   and \code{passphrase}.
#' @param tz Timezone string.
#'
#' @return A \code{data.frame} with historical asset bill rows.
#' @export
get_asset_bills_history <- function(ccy = NULL, type = NULL, client_id = NULL, after = NULL, before = NULL, limit = NULL, paging_type = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    ccy = ccy,
    type = type,
    clientId = client_id,
    after = after,
    before = before,
    limit = limit,
    pagingType = paging_type
  )
  .gets$asset_bills_history(query_string = query_string, tz = tz, config = config)
}

#' Get deposit or withdrawal status
#'
#' Retrieve detailed status for a deposit or withdrawal.
#'
#' @param wd_id Character or `NULL`. Withdrawal ID.
#' @param tx_id Character or `NULL`. Deposit transaction hash.
#' @param ccy Character or `NULL`. Currency filter used with \code{tx_id}.
#' @param to Character or `NULL`. Destination address used with \code{tx_id}.
#' @param chain Character or `NULL`. Chain identifier used with \code{tx_id}.
#' @param config API credentials as a list with \code{api_key}, \code{secret_key},
#'   and \code{passphrase}.
#' @param tz Timezone string.
#'
#' @return A \code{data.frame} with detailed deposit/withdraw status rows.
#' @export
get_asset_deposit_withdraw_status <- function(wd_id = NULL, tx_id = NULL, ccy = NULL, to = NULL, chain = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    wdId = wd_id,
    txId = tx_id,
    ccy = ccy,
    to = to,
    chain = chain
  )
  .gets$asset_deposit_withdraw_status(query_string = query_string, tz = tz, config = config)
}

#' Get exchange list
#'
#' Retrieve the public exchange list used by asset withdrawal metadata.
#'
#' @param tz Timezone string.
#'
#' @return A \code{data.frame} with exchange identifiers and names.
#' @export
get_asset_exchange_list <- function(tz = .okx_default_tz) {
  .gets$asset_exchange_list(query_string = "", tz = tz, config = NULL)
}

#' Get convert currencies
#'
#' Retrieve currencies supported by the asset convert API.
#'
#' @param config API credentials as a list with \code{api_key}, \code{secret_key},
#'   and \code{passphrase}.
#' @param tz Timezone string.
#'
#' @return A \code{data.frame} with supported convert currencies.
#' @export
get_asset_convert_currencies <- function(config, tz = .okx_default_tz) {
  .gets$asset_convert_currencies(query_string = "", tz = tz, config = config)
}

#' Get convert currency pair
#'
#' Retrieve convert metadata for a currency pair.
#'
#' @param from_ccy Character. Currency to convert from.
#' @param to_ccy Character. Currency to convert to.
#' @param convert_mode Character or `NULL`. Convert mode selector.
#' @param config API credentials as a list with \code{api_key}, \code{secret_key},
#'   and \code{passphrase}.
#' @param tz Timezone string.
#'
#' @return A \code{data.frame} with currency-pair convert metadata.
#' @export
get_asset_convert_currency_pair <- function(from_ccy, to_ccy, convert_mode = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(fromCcy = from_ccy, toCcy = to_ccy, convertMode = convert_mode)
  .gets$asset_convert_currency_pair(query_string = query_string, tz = tz, config = config)
}

#' Get convert history
#'
#' Retrieve historical asset convert trades.
#'
#' @param cl_t_req_id Character or `NULL`. Client trade request ID.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of results to request.
#' @param tag Character or `NULL`. Broker tag filter.
#' @param config API credentials as a list with \code{api_key}, \code{secret_key},
#'   and \code{passphrase}.
#' @param tz Timezone string.
#'
#' @return A \code{data.frame} with convert history rows.
#' @export
get_asset_convert_history <- function(cl_t_req_id = NULL, after = NULL, before = NULL, limit = NULL, tag = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    clTReqId = cl_t_req_id,
    after = after,
    before = before,
    limit = limit,
    tag = tag
  )
  .gets$asset_convert_history(query_string = query_string, tz = tz, config = config)
}
