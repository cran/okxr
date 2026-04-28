# okxr news

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
