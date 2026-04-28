#---- Account: GET Wrappers ----

#' Get account balance
#'
#' Retrieve account-level margin and equity information for your OKX account.
#'
#' @details
#' This wraps `/api/v5/account/balance`. Returns one row per account-level
#' equity snapshot. Timestamps are parsed into `POSIXct` in the given `tz`.
#'
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`. May also include `base_url`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with account balance and margin metrics (e.g.,
#' `totalEq`, `isoEq`, `adjEq`, `availEq`, `ordFroz`, `imr`, `mmr`, `upl`,
#' `mgnRatio`, …). Timestamp columns (`uTime`) are `POSIXct`.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' bal <- get_account_balance(config = cfg)
#' head(bal)
#' }
#'
#' @seealso [get_account_positions()], [get_account_leverage_info()]
#' @family okxr-account
#' @note Since okxr 0.1.1
#' @export
get_account_balance <- function(config, tz = .okx_default_tz) {
  .gets$account_balance(query_string = "", tz = tz, config = config)
}

#' Get account open positions
#'
#' Retrieve all currently open positions under the account.
#'
#' @details
#' Wraps `/api/v5/account/positions`. Returns one row per open position.
#'
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with columns such as `instId`, `posId`, `posSide`, `pos`,
#' `lever`, `avgPx`, `markPx`, `upl`, `realizedPnl`, etc. Timestamps (`cTime`,
#' `uTime`) are `POSIXct`.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' pos <- get_account_positions(config = cfg)
#' pos
#' }
#'
#' @seealso [get_account_balance()], [get_account_positions_history()]
#' @family okxr-account
#' @note Since okxr 0.1.1
#' @export
get_account_positions <- function(config, tz = .okx_default_tz) {
  .gets$account_positions(query_string = "", tz = tz, config = config)
}

#' Get account position history
#'
#' Retrieve historical records of closed or adjusted positions.
#'
#' @details
#' Wraps `/api/v5/account/positions-history`. Includes closed positions and
#' their realized PnL. Returns one row per historical record.
#'
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with columns such as `instId`, `posId`, `posSide`, `pos`,
#' `lever`, `realizedPnl`, `fee`, plus timestamp fields (`cTime`, `uTime`).
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' hist <- get_account_positions_history(config = cfg)
#' tail(hist)
#' }
#'
#' @seealso [get_account_positions()]
#' @family okxr-account
#' @note Since okxr 0.1.1
#' @export
get_account_positions_history <- function(config, tz = .okx_default_tz) {
  .gets$account_positions_history(query_string = "", tz = tz, config = config)
}

#' Get account configuration
#'
#' Retrieve account-level configuration information.
#'
#' @details
#' Wraps `/api/v5/account/config`. Includes account ID, mode, and position
#' mode flags. Returns one row.
#'
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with columns like `uid`, `mainUid`, `acctLv`, `posMode`,
#' `autoLoan`, etc.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' cfg_info <- get_account_config(config = cfg)
#' cfg_info
#' }
#'
#' @seealso [get_account_balance()], [get_account_leverage_info()]
#' @family okxr-account
#' @note Since okxr 0.1.2
#' @export
get_account_config <- function(config, tz = .okx_default_tz) {
  .gets$account_config(query_string = "", tz = tz, config = config)
}

#' Get account leverage settings
#'
#' Retrieve leverage configuration for a given instrument and margin mode.
#'
#' @details
#' Wraps `/api/v5/account/leverage-info`. Requires both `inst_id` and
#' `mgn_mode`. Returns current leverage values (numeric).
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT"`.
#' @param mgn_mode Character. Margin mode. One of `"cross"` or `"isolated"`.
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with columns `instId`, `mgnMode`, `posSide`, and `lever`.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' get_account_leverage_info(
#'   inst_id = "BTC-USDT",
#'   mgn_mode = "cross",
#'   config = cfg
#' )
#' }
#'
#' @seealso [get_account_balance()], [get_account_positions()]
#' @family okxr-account
#' @note Since okxr 0.1.1
#' @export
get_account_leverage_info <- function(inst_id, mgn_mode, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instId = inst_id, mgnMode = mgn_mode)
  .gets$account_leverage_info(query_string = query_string, config = config, tz = tz)
}

#' Get account bills
#'
#' Retrieve account bill details from the last 7 days.
#'
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param ccy Character or `NULL`. Currency filter.
#' @param mgn_mode Character or `NULL`. Margin mode filter.
#' @param ct_type Character or `NULL`. Contract type filter.
#' @param type Character or `NULL`. Bill type filter.
#' @param sub_type Character or `NULL`. Bill subtype filter.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with account bill rows.
#'
#' @export
get_account_bills <- function(inst_type = NULL, ccy = NULL, mgn_mode = NULL, ct_type = NULL, type = NULL, sub_type = NULL, after = NULL, before = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    ccy = ccy,
    mgnMode = mgn_mode,
    ctType = ct_type,
    type = type,
    subType = sub_type,
    after = after,
    before = before,
    limit = limit
  )
  .gets$account_bills(query_string = query_string, config = config, tz = tz)
}

#' Get archived account bills
#'
#' Retrieve archived account bill details.
#'
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param ccy Character or `NULL`. Currency filter.
#' @param mgn_mode Character or `NULL`. Margin mode filter.
#' @param ct_type Character or `NULL`. Contract type filter.
#' @param type Character or `NULL`. Bill type filter.
#' @param sub_type Character or `NULL`. Bill subtype filter.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with archived account bill rows.
#'
#' @export
get_account_bills_archive <- function(inst_type = NULL, ccy = NULL, mgn_mode = NULL, ct_type = NULL, type = NULL, sub_type = NULL, after = NULL, before = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    ccy = ccy,
    mgnMode = mgn_mode,
    ctType = ct_type,
    type = type,
    subType = sub_type,
    after = after,
    before = before,
    limit = limit
  )
  .gets$account_bills_archive(query_string = query_string, config = config, tz = tz)
}
