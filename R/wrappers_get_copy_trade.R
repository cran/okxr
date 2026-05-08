#' Get copy trading settings
#'
#' Retrieve your account's copy trading configuration.
#'
#' @details
#' Wraps `/api/v5/copytrading/copy-settings`. Returns one row with the
#' current copy mode and copy state for the given `unique_code`.
#'
#' @param unique_code Character. Lead trader unique code.
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param uniqueCode Deprecated alias for `unique_code`.
#' @param instType Deprecated alias for `inst_type`.
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
#' @note Since okxr 0.1.2
#' @export
get_copy_trade_settings <- function(unique_code, inst_type = NULL, config, tz = .okx_default_tz, uniqueCode = unique_code, instType = inst_type) {
  query_string <- .okx_build_query(uniqueCode = uniqueCode, instType = instType)
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
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param inst_id Character or `NULL`. Instrument ID filter.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of rows to request.
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
#' @note Since okxr 0.1.2
#' @export
get_copy_trade_current_subpos <- function(inst_type = NULL, inst_id = NULL, after = NULL, before = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    instId = inst_id,
    after = after,
    before = before,
    limit = limit
  )
  .gets$copy_trade_current_subpos(query_string = query_string, tz = tz, config = config)
}

#' Get historical copy trading subpositions
#'
#' Retrieve your historical copy trading subpositions.
#'
#' @details
#' Wraps `/api/v5/copytrading/subpositions-history`. Returns one row per
#' closed or historical subposition.
#'
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param inst_id Character or `NULL`. Instrument ID filter.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of rows to request.
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
#' @note Since okxr 0.1.2
#' @export
get_copy_trade_historical_subpos <- function(inst_type = NULL, inst_id = NULL, after = NULL, before = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    instId = inst_id,
    after = after,
    before = before,
    limit = limit
  )
  .gets$copy_trade_historical_subpos(query_string = query_string, tz = tz, config = config)
}

#' Get copy trading instruments
#'
#' Retrieve instruments currently available for copy trading.
#'
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with one row per instrument and an `enabled` flag.
#' @export
get_copy_trade_instruments <- function(
  inst_type = NULL,
  config,
  tz = .okx_default_tz
) {
  query_string <- .okx_build_query(instType = inst_type)
  .gets$copy_trade_instruments(query_string = query_string, tz = tz, config = config)
}

#' Get copy trading config
#'
#' Retrieve your account-level copy trading configuration.
#'
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with top-level copy trading configuration fields.
#'   Nested `details` are returned as a JSON string column.
#' @export
get_copy_trade_config <- function(config, tz = .okx_default_tz) {
  .gets$copy_trade_config(query_string = "", tz = tz, config = config)
}

#' Get public copy trading config
#'
#' Retrieve public copy trading limits and ratio bounds.
#'
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with public copy trading configuration fields.
#' @export
get_copy_trade_public_config <- function(
  inst_type = NULL,
  tz = .okx_default_tz
) {
  query_string <- .okx_build_query(instType = inst_type)
  .gets$copy_trade_public_config(query_string = query_string, tz = tz, config = NULL)
}

#' Get public copy trader summary
#'
#' Retrieve public copy trader summary metrics for a lead trader.
#'
#' @param unique_code Character. Lead trader unique code.
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with summary metrics and a JSON-string `copyTraders`
#'   column for nested trader details.
#' @export
get_copy_trade_public_copy_traders <- function(unique_code, inst_type = NULL, limit = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(uniqueCode = unique_code, instType = inst_type, limit = limit)
  .gets$copy_trade_public_copy_traders(query_string = query_string, tz = tz, config = NULL)
}

#' Get public lead trader ranks
#'
#' Retrieve ranked public lead trader summaries.
#'
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param sort_type Character or `NULL`. Rank sort selector.
#' @param state Character or `NULL`. Lead trader state filter.
#' @param min_lead_days Character or `NULL`. Minimum lead-days selector.
#' @param min_assets Character or `NULL`. Minimum assets filter.
#' @param max_assets Character or `NULL`. Maximum assets filter.
#' @param min_aum Character or `NULL`. Minimum assets-under-management filter.
#' @param max_aum Character or `NULL`. Maximum assets-under-management filter.
#' @param data_ver Character or `NULL`. Data version selector used for pagination.
#' @param page Character or `NULL`. Page number.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with top-level ranking metadata and a JSON-string
#'   `ranks` column for nested leader rows.
#' @export
get_copy_trade_public_lead_traders <- function(inst_type = NULL, sort_type = NULL, state = NULL, min_lead_days = NULL, min_assets = NULL, max_assets = NULL, min_aum = NULL, max_aum = NULL, data_ver = NULL, page = NULL, limit = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    sortType = sort_type,
    state = state,
    minLeadDays = min_lead_days,
    minAssets = min_assets,
    maxAssets = max_assets,
    minAum = min_aum,
    maxAum = max_aum,
    dataVer = data_ver,
    page = page,
    limit = limit
  )
  .gets$copy_trade_public_lead_traders(query_string = query_string, tz = tz, config = NULL)
}

#' Get public current copy trading subpositions
#'
#' Retrieve public current subpositions for a lead trader.
#'
#' @param unique_code Character. Lead trader unique code.
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with one row per current public subposition.
#' @export
get_copy_trade_public_current_subpositions <- function(unique_code, inst_type = NULL, after = NULL, before = NULL, limit = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    uniqueCode = unique_code,
    instType = inst_type,
    after = after,
    before = before,
    limit = limit
  )
  .gets$copy_trade_public_current_subpositions(query_string = query_string, tz = tz, config = NULL)
}

#' Get public historical copy trading subpositions
#'
#' Retrieve public historical subpositions for a lead trader.
#'
#' @param unique_code Character. Lead trader unique code.
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with one row per historical public subposition.
#' @export
get_copy_trade_public_subpositions_history <- function(unique_code, inst_type = NULL, after = NULL, before = NULL, limit = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    uniqueCode = unique_code,
    instType = inst_type,
    after = after,
    before = before,
    limit = limit
  )
  .gets$copy_trade_public_subpositions_history(query_string = query_string, tz = tz, config = NULL)
}

#' Get public copy trading pnl
#'
#' Retrieve public pnl time windows for a lead trader.
#'
#' @param unique_code Character. Lead trader unique code.
#' @param last_days Character or numeric. OKX lookback selector.
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with pnl windows and ratios.
#' @export
get_copy_trade_public_pnl <- function(unique_code, last_days, inst_type = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(uniqueCode = unique_code, lastDays = last_days, instType = inst_type)
  .gets$copy_trade_public_pnl(query_string = query_string, tz = tz, config = NULL)
}

#' Get public copy trading stats
#'
#' Retrieve public copy trading performance stats for a lead trader.
#'
#' @param unique_code Character. Lead trader unique code.
#' @param last_days Character or numeric. OKX lookback selector.
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with copy trading summary statistics.
#' @export
get_copy_trade_public_stats <- function(unique_code, last_days, inst_type = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(uniqueCode = unique_code, lastDays = last_days, instType = inst_type)
  .gets$copy_trade_public_stats(query_string = query_string, tz = tz, config = NULL)
}

#' Get public copy trading weekly pnl
#'
#' Retrieve public weekly pnl series for a lead trader.
#'
#' @param unique_code Character. Lead trader unique code.
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with weekly pnl windows and ratios.
#' @export
get_copy_trade_public_weekly_pnl <- function(unique_code, inst_type = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(uniqueCode = unique_code, instType = inst_type)
  .gets$copy_trade_public_weekly_pnl(query_string = query_string, tz = tz, config = NULL)
}

#' Get public preference currencies
#'
#' Retrieve the most frequently traded currencies for a lead trader.
#'
#' @param unique_code Character. Lead trader unique code.
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with preferred currencies and their ratios.
#' @export
get_copy_trade_public_preference_currency <- function(unique_code, inst_type = NULL, tz = .okx_default_tz) {
  query_string <- .okx_build_query(uniqueCode = unique_code, instType = inst_type)
  .gets$copy_trade_public_preference_currency(query_string = query_string, tz = tz, config = NULL)
}

#' Get profit sharing details
#'
#' Retrieve realized profit sharing detail rows.
#'
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with realized profit sharing rows.
#' @export
get_copy_trade_profit_sharing_details <- function(inst_type = NULL, after = NULL, before = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instType = inst_type, after = after, before = before, limit = limit)
  .gets$copy_trade_profit_sharing_details(query_string = query_string, tz = tz, config = config)
}

#' Get unrealized profit sharing details
#'
#' Retrieve unrealized profit sharing detail rows.
#'
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with unrealized profit sharing rows.
#' @export
get_copy_trade_unrealized_profit_sharing_details <- function(inst_type = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instType = inst_type)
  .gets$copy_trade_unrealized_profit_sharing_details(query_string = query_string, tz = tz, config = config)
}

#' Get total profit sharing
#'
#' Retrieve total realized profit sharing by instrument type.
#'
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with total realized profit sharing rows.
#' @export
get_copy_trade_total_profit_sharing <- function(inst_type = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instType = inst_type)
  .gets$copy_trade_total_profit_sharing(query_string = query_string, tz = tz, config = config)
}

#' Get total unrealized profit sharing
#'
#' Retrieve total unrealized profit sharing by instrument type.
#'
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with total unrealized profit sharing rows.
#' @export
get_copy_trade_total_unrealized_profit_sharing <- function(inst_type = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instType = inst_type)
  .gets$copy_trade_total_unrealized_profit_sharing(query_string = query_string, tz = tz, config = config)
}
