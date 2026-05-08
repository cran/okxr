# okxr news

## okxr 0.4.5

* Expanded `post_trade_cancel_order()` so it accepts either `ord_id` or
  `cl_ord_id`, matching the documented OKX cancellation surface more closely.
* Added shared internal POST validation helpers for required fields,
  exactly-one identifier checks, non-empty batch inputs, and amend-request
  payload validation.
* Added client-side guardrails for empty move-position legs and invalid
  asset transfers with identical source and destination account codes.
* Added mocked tests covering the new POST validation paths and malformed
  request rejection behavior.

## okxr 0.4.4

* Added `post_asset_transfer()` for signed internal and sub-account asset
  transfer workflows.
* Added `post_asset_withdrawal()` and `post_asset_cancel_withdrawal()` for
  funding-account withdrawal submission and cancellation.
* Added `post_asset_convert_estimate_quote()` and
  `post_asset_convert_trade()` for quote-first asset convert workflows.
* Added parser specs and mocked request-body tests for the new asset action
  wrappers.

## okxr 0.4.3

* Added `post_account_position_margin_balance()` for margin add/reduce
  operations on existing positions.
* Added `post_account_spot_manual_borrow_repay()` for manual spot-mode
  borrow and repay requests.
* Added `post_account_account_level_switch_preset()` for storing account-mode
  switch presets before a mode change.
* Added `post_account_mmp_reset()` and `post_account_mmp_config()` for
  options MMP reset and configuration workflows.
* Added `post_account_move_positions()` for move-position requests between
  accounts under the same master account.
* Added parser specs and mocked request-body tests for the new account
  operational action wrappers.

## okxr 0.4.2

* Added `post_account_set_position_mode()` for account position-mode changes.
* Added `post_account_set_fee_type()` and `post_account_set_greeks()` for
  fee display and Greeks display configuration.
* Added `post_account_set_auto_repay()` and `post_account_set_auto_loan()`
  for spot auto-repay and automatic borrowing settings.
* Added `post_account_set_account_level()` and
  `post_account_set_collateral_assets()` for account-mode and collateral
  configuration workflows.
* Added parser specs and mocked request-body tests for the new account action
  wrappers.

## okxr 0.4.1

* Added `post_trade_cancel_algos()` for batch cancellation of supported
  algo orders.
* Added `post_trade_amend_algos()` for modifying supported algo orders with
  documented trigger and TP/SL amendment fields.
* Added `post_trade_mass_cancel()` for options MMP mass-cancel workflows.
* Added parser specs and mocked request-body tests for the new trade action
  wrappers.

## okxr 0.4.0

* Added `post_trade_batch_orders()` and `post_trade_cancel_batch_orders()`
  for grouped order placement and cancellation workflows.
* Added `post_trade_amend_order()` and
  `post_trade_amend_batch_orders()` for modifying live orders with the
  documented amend request fields.
* Added `post_trade_order_precheck()` for signed order validation before
  placement.
* Added `post_trade_cancel_all_after()` for exchange-side cancel-after
  safeguards.
* Refactored internal trade request-body shaping so single-order, batch-order,
  amend, and precheck wrappers share the same field mapping logic.

## okxr 0.3.5

* Added `get_copy_trade_public_lead_traders()` and
  `get_copy_trade_public_preference_currency()` to cover the remaining
  documented public copy-trading GET endpoints in the current package scope.
* Expanded `get_copy_trade_settings()` with the documented `inst_type`
  filter.
* Expanded `get_copy_trade_current_subpos()` and
  `get_copy_trade_historical_subpos()` with `inst_type`, `inst_id`,
  `after`, `before`, and `limit`.
* Broadened parsed copy-trading schemas for settings and private
  subposition/history endpoints so the wrappers return more of the documented
  response fields.

## okxr 0.3.4

* Added `get_copy_trade_instruments()`, `get_copy_trade_config()`,
  `get_copy_trade_public_config()`, `get_copy_trade_public_copy_traders()`,
  `get_copy_trade_public_current_subpositions()`, and
  `get_copy_trade_public_subpositions_history()` for broader copy-trading
  discovery and position inspection.
* Added `get_copy_trade_public_pnl()`,
  `get_copy_trade_public_stats()`,
  `get_copy_trade_public_weekly_pnl()`,
  `get_copy_trade_profit_sharing_details()`,
  `get_copy_trade_unrealized_profit_sharing_details()`,
  `get_copy_trade_total_profit_sharing()`, and
  `get_copy_trade_total_unrealized_profit_sharing()` for public performance
  and private profit-sharing coverage.
* Expanded `get_asset_deposit_history()` and
  `get_asset_withdrawal_history()` to support the documented filter surface
  and richer parsed transfer metadata.
* Expanded `get_trade_fills()` and `get_trade_fills_history()` with
  `begin` and `end` timestamp filters.

## okxr 0.3.3

* Added `get_trade_orders_history()` and
  `get_trade_orders_history_archive()` for broader trade history coverage
  beyond pending orders and the earlier 7-day wrapper.
* Added `get_trade_easy_convert_currency_list()`,
  `get_trade_easy_convert_history()`,
  `get_trade_one_click_repay_currency_list()`,
  `get_trade_one_click_repay_history()`,
  `get_trade_one_click_repay_currency_list_v2()`, and
  `get_trade_one_click_repay_history_v2()` for convert and repay workflow
  inspection.
* Added `get_trade_order_algo()`,
  `get_trade_orders_algo_pending()`, and
  `get_trade_orders_algo_history()` for read-only algo-order inspection.
* Added `get_asset_non_tradable_assets()`,
  `get_asset_asset_valuation()`,
  `get_asset_transfer_state()`,
  `get_asset_bills()`,
  `get_asset_bills_history()`,
  `get_asset_deposit_withdraw_status()`, and
  `get_asset_exchange_list()` for broader funding-account inspection.
* Added `get_asset_convert_currencies()`,
  `get_asset_convert_currency_pair()`, and
  `get_asset_convert_history()` for asset convert metadata and history.

## okxr 0.3.2

* Added `get_account_interest_accrued()` and
  `get_account_interest_limits()` for borrowing-cost and borrowing-limit
  inspection.
* Added `get_account_max_withdrawal()`, `get_account_risk_state()`,
  `get_account_greeks()`, `get_account_position_tiers()`, and
  `get_account_collateral_assets()` for broader account risk and margin
  coverage.
* Added `get_account_mmp_config()`,
  `get_account_move_positions_history()`,
  `get_account_precheck_set_delta_neutral()`, and
  `get_account_set_account_switch_precheck()` for operational account
  inspection and precheck workflows.
* Added `get_account_bills_history_archive()`,
  `get_account_subaccount_balances()`,
  `get_account_subaccount_max_withdrawal()`, and
  `get_account_spot_borrow_repay_history()` for historical export,
  sub-account, and spot borrow/repay coverage.
* Normalized source documentation text to ASCII for safer local package builds
  under restrictive locale settings.

## okxr 0.3.1

* Added `get_market_mark_price_candles()` and
  `get_market_history_mark_price_candles()` for mark-price candlestick data.
* Added `get_market_exchange_rate()`, `get_market_index_components()`,
  `get_market_platform_24_volume()`, `get_market_block_ticker()`, and
  `get_market_block_tickers()` for additional public market data coverage.
* Added `get_public_block_trades()`,
  `get_public_delivery_exercise_history()`,
  `get_public_estimated_settlement_info()`,
  `get_public_settlement_history()`, `get_public_underlying()`,
  `get_public_opt_summary()`, `get_public_position_tiers()`, and
  `get_public_economic_calendar()` for broader public reference coverage.
* Added `get_account_subtypes()`, `get_account_adjust_leverage_info()`, and
  `get_account_max_loan()` for additional account-level inspection endpoints.
* Extended the internal parser with vector-mode support for array-only payloads
  such as `public/underlying`.

## okxr 0.3.0

* Added `get_account_instruments()` for account-scoped instrument metadata.
* Added `get_account_position_risk()` for account and position risk snapshots.
* Added `get_account_max_size()` and `get_account_max_avail_size()` for
  account-level sizing checks before order placement.
* Added `get_account_trade_fee()` and `get_account_interest_rate()` for
  account fee and borrowing-rate inspection.
* Added `get_trade_account_rate_limit()` for rate-limit and fill-ratio
  monitoring.
* Added `get_public_estimated_price()`,
  `get_public_discount_rate_interest_free_quota()`,
  `get_public_interest_rate_loan_quota()`, `get_public_insurance_fund()`,
  `get_public_convert_contract_coin()`, `get_public_instrument_tick_bands()`,
  and `get_public_premium_history()` for public reference and risk metadata.
* Added `get_market_index_tickers()`, `get_market_index_candles()`, and
  `get_market_history_index_candles()` for public index market data.
* Added `get_market_option_instrument_family_trades()` and
  `get_public_option_trades()` for option trade market data.
* Extended tests and package documentation for the first post-CRAN endpoint
  expansion batch.

## okxr 0.2.5

* Updated README status and installation guidance now that `okxr` is available
  on CRAN.
* Distinguished the stable CRAN install path from the GitHub development
  release.
* Added post-acceptance release metadata cleanup for the first CRAN release.

## okxr 0.2.4

* Added an API web reference to `DESCRIPTION` as requested by CRAN.
* Documented the return value for `set_okxr_options()`.
* Removed examples from unexported helper functions to satisfy CRAN
  documentation checks.

## okxr 0.2.3

* Updated CRAN submission notes with successful GitHub Actions check results.
* Bumped release metadata for the final CRAN submission preparation release.

## okxr 0.2.2

* Added a repo-only CRAN submission checklist for the final manual pre-submission
  steps.
* Updated CRAN submission notes to point to the final checklist and preflight
  workflow.
* Updated package-level release metadata for the CRAN polish release.

## okxr 0.2.1

* Added a manual GitHub Actions CRAN preflight workflow that runs
  `R CMD check --as-cran` with LaTeX support.
* Updated CRAN submission notes to separate local package checks from
  environment-dependent incoming, URL, and PDF-manual checks.
* Updated package-level release metadata for the CRAN preflight release.

## okxr 0.2.0

* Marked the package as a CRAN-targeted release candidate.
* Updated README installation and status wording so it no longer describes the
  package as GitHub-release only.
* Clarified public versus private example requirements in package-level
  documentation.
* Rechecked release metadata and package-level documentation for consistency.

## okxr 0.1.9

* Added mocked HTTP tests for successful GET/POST execution, HTTP errors,
  request errors, and private credential validation.
* Hardened response parsing so malformed or unreadable JSON responses warn and
  return `NULL` instead of bubbling parser errors.
* Added parser coverage for malformed response bodies and missing fields.
* Updated release metadata for the robustness-focused CRAN preparation release.

## okxr 0.1.8

* Polished package metadata for future CRAN submission, including title,
  description, language, and import formatting.
* Added CRAN submission support files and spelling allow-list terms for
  package-specific names.
* Expanded build-ignore rules so local check directories, source tarballs, and
  CRAN submission notes are excluded from package builds.
* Updated README release status to describe the package as CRAN-targeted but not
  yet submitted.

## okxr 0.1.7

* Public market and public reference GET endpoints no longer require API
  credentials.
* Added configurable HTTP request timeout handling via `set_okxr_options()` and
  per-request `config$timeout`.
* Improved HTTP failure handling so request errors and timeouts warn and return
  `NULL` consistently.
* Extended tests for unsigned request construction and timeout validation.

## okxr 0.1.6

* Added package-level help documenting credential structure, simulated trading,
  return behavior, and live API example policy.
* Hardened examples for CRAN readiness by avoiding live API calls in runnable
  examples and avoiding persistent global option changes.
* Expanded README guidance for credential handling, simulated trading, return
  values, and network/API failure behavior.

## okxr 0.1.5

* Added `testthat` infrastructure for package-level regression testing.
* Added mocked unit tests for request helpers, config validation, parser behavior,
  raw/parsed result extraction, wrapper query construction, and client order ID
  preservation.
* Added a GitHub Actions `R CMD check` workflow for Linux, macOS, and Windows.
* Kept tests credential-free and network-free so they are suitable for future
  CRAN hardening work.

## okxr 0.1.4

* Added additional OKX REST GET wrappers for market data:
  `get_market_tickers()`, `get_market_books()`, `get_market_trades()`, and
  `get_market_history_trades()`.
* Added public-data wrappers:
  `get_public_time()` and `get_public_price_limit()`.
* Added trade fill wrappers:
  `get_trade_fills()` and `get_trade_fills_history()`.
* Added account bill wrappers:
  `get_account_bills()` and `get_account_bills_archive()`.
* Added funding asset metadata wrappers:
  `get_asset_currencies()` and `get_asset_deposit_address()`.
* Improved parser handling for list-valued response fields by encoding them as
  JSON strings in parsed tables.

## okxr 0.1.3

* Refined internal package structure with shared request helpers for config
  validation, query construction, and default handling.
* Improved parser efficiency and readability by replacing nested assignment loops
  with column-oriented extraction.
* Standardized wrapper signatures and timezone defaults across the package.
* Fixed wrapper inconsistencies, including generated query handling, optional
  instrument filters, and `cl_ord_id` behavior in `post_trade_order()`.
* Updated package metadata for the GitHub release, including author, license,
  and generated documentation.
* Added repository hygiene files for package builds and artifact cleanup.

## okxr 0.1.2

* Added copy-trading GET wrappers:
  `get_copy_trade_settings()`, `get_copy_trade_my_leaders()`,
  `get_copy_trade_current_subpos()`, and `get_copy_trade_historical_subpos()`.
* Added account GET wrappers:
  `get_account_config()` and `get_account_leverage_info()`.
* Added market GET wrappers:
  `get_public_mark_price()` and `get_public_instruments()`.
* Expanded documentation.

## okxr 0.1.1

* Added POST wrappers:
  `post_trade_order()`, `post_trade_cancel_order()`,
  `post_trade_close_position()`, and `post_account_set_leverage()`.
* Added `get_trade_orders_pending()`.
* Improved endpoint specs and roxygen documentation.

## okxr 0.1.0

* Initial GitHub release with core GET/POST endpoint framework, signing, and
  basic market/account/asset wrappers.
