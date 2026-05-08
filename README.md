# okxr: R Interface to the OKX API

`okxr` is an R package for working with the OKX REST API from R. It provides
typed wrappers for market data, account endpoints, asset history, trading, and
copy trading, with shared request signing and schema-based response parsing.

## Status

`okxr` is available on CRAN. Install the stable release from CRAN or use the
GitHub repository for development versions between CRAN releases.

Current development release: `v0.4.5`

## Installation

Stable CRAN release:

```r
install.packages("okxr")
```

Development release from GitHub:

```r
# install.packages("devtools")
devtools::install_github("OliverLDS/okxr")
```

## Features

* Signed OKX REST requests with HMAC authentication
* Typed parsing into tabular R objects with variable labels
* Shared internal GET/POST generators backed by endpoint specs
* User-facing wrappers for account, asset, market, trade, and copy-trading APIs
* Configurable raw vs parsed return mode via `set_okxr_options()`

## Setup

```r
config <- list(
  api_key = "your_api_key",
  secret_key = "your_secret_key",
  passphrase = "your_passphrase"
)
```

Public market and public reference endpoints can be called without credentials.
Private account, asset, trade, and copy-trading endpoints require signed OKX
API credentials.

Do not store real credentials in committed R scripts, examples, or tests. For
interactive use, load them from environment variables or another local secret
store. If you use OKX simulated trading, set `demo = TRUE` in `config`.

```r
config <- list(
  api_key = Sys.getenv("OKX_API_KEY"),
  secret_key = Sys.getenv("OKX_SECRET_KEY"),
  passphrase = Sys.getenv("OKX_PASSPHRASE"),
  demo = TRUE,
  timeout = 10
)
```

## Return values

By default, wrappers return parsed `data.table` objects with typed columns and
variable labels where schemas are defined. Use `set_okxr_options(raw_data = TRUE)`
to return the raw OKX `data` payload instead.

Network failures, request timeouts, OKX error responses, or empty API `data`
payloads may return `NULL` with a warning. Request timeout defaults to 10
seconds and can be set globally with `set_okxr_options(timeout = 15)` or per
request with `config$timeout`.

## Examples

Public market examples require network access but no OKX credentials. Private
account, trading, asset, and copy-trading examples require valid OKX credentials;
trading examples may have account side effects.

### Market data

```r
get_market_candles(
  inst_id = "BTC-USDT",
  bar = "1m",
  limit = 100
)
```

### Account data

```r
get_account_balance(config = config)
get_account_positions(config = config)
```

### Place an order

```r
post_trade_order(
  inst_id = "BTC-USDT",
  td_mode = "cross",
  side = "buy",
  ord_type = "market",
  sz = "0.01",
  config = config
)
```

### Copy trading

```r
get_copy_trade_my_leaders(config = config)
get_copy_trade_current_subpos(config = config)
```

## Wrapper categories

| Category | Method | Example function |
| --- | --- | --- |
| market | GET | `get_market_candles()` |
| market | GET | `get_market_tickers()` |
| market | GET | `get_market_trades()` |
| market | GET | `get_market_mark_price_candles()` |
| market | GET | `get_market_index_tickers()` |
| market | GET | `get_market_index_candles()` |
| market | GET | `get_market_index_components()` |
| public | GET | `get_public_time()` |
| public | GET | `get_public_underlying()` |
| public | GET | `get_public_estimated_price()` |
| public | GET | `get_public_estimated_settlement_info()` |
| public | GET | `get_public_opt_summary()` |
| public | GET | `get_public_position_tiers()` |
| public | GET | `get_public_discount_rate_interest_free_quota()` |
| public | GET | `get_public_interest_rate_loan_quota()` |
| public | GET | `get_public_insurance_fund()` |
| public | GET | `get_public_block_trades()` |
| public | GET | `get_public_convert_contract_coin()` |
| public | GET | `get_public_instrument_tick_bands()` |
| public | GET | `get_public_premium_history()` |
| public | GET | `get_public_option_trades()` |
| account | GET | `get_account_balance()` |
| account | GET | `get_account_instruments()` |
| account | GET | `get_account_subtypes()` |
| account | GET | `get_account_adjust_leverage_info()` |
| account | GET | `get_account_position_risk()` |
| account | GET | `get_account_max_loan()` |
| account | GET | `get_account_max_size()` |
| account | GET | `get_account_max_avail_size()` |
| account | GET | `get_account_trade_fee()` |
| account | GET | `get_account_interest_rate()` |
| account | GET | `get_account_interest_accrued()` |
| account | GET | `get_account_max_withdrawal()` |
| account | GET | `get_account_risk_state()` |
| account | GET | `get_account_interest_limits()` |
| account | GET | `get_account_greeks()` |
| account | GET | `get_account_position_tiers()` |
| account | GET | `get_account_collateral_assets()` |
| account | GET | `get_account_mmp_config()` |
| account | GET | `get_account_move_positions_history()` |
| account | GET | `get_account_precheck_set_delta_neutral()` |
| account | GET | `get_account_bills_history_archive()` |
| account | GET | `get_account_subaccount_balances()` |
| account | GET | `get_account_subaccount_max_withdrawal()` |
| account | GET | `get_account_set_account_switch_precheck()` |
| account | GET | `get_account_spot_borrow_repay_history()` |
| account | GET | `get_account_bills()` |
| account | POST | `post_account_set_leverage()` |
| account | POST | `post_account_set_position_mode()` |
| account | POST | `post_account_set_fee_type()` |
| account | POST | `post_account_set_greeks()` |
| account | POST | `post_account_set_auto_repay()` |
| account | POST | `post_account_set_auto_loan()` |
| account | POST | `post_account_set_account_level()` |
| account | POST | `post_account_set_collateral_assets()` |
| account | POST | `post_account_position_margin_balance()` |
| account | POST | `post_account_spot_manual_borrow_repay()` |
| account | POST | `post_account_account_level_switch_preset()` |
| account | POST | `post_account_mmp_reset()` |
| account | POST | `post_account_mmp_config()` |
| account | POST | `post_account_move_positions()` |
| asset | GET | `get_asset_balances()` |
| asset | GET | `get_asset_deposit_history()` |
| asset | GET | `get_asset_withdrawal_history()` |
| asset | GET | `get_asset_currencies()` |
| asset | GET | `get_asset_non_tradable_assets()` |
| asset | GET | `get_asset_asset_valuation()` |
| asset | GET | `get_asset_bills()` |
| asset | GET | `get_asset_transfer_state()` |
| asset | GET | `get_asset_convert_history()` |
| asset | POST | `post_asset_transfer()` |
| asset | POST | `post_asset_withdrawal()` |
| asset | POST | `post_asset_cancel_withdrawal()` |
| asset | POST | `post_asset_convert_estimate_quote()` |
| asset | POST | `post_asset_convert_trade()` |
| trade | GET | `get_trade_order()` |
| trade | GET | `get_trade_orders_history()` |
| trade | GET | `get_trade_orders_algo_pending()` |
| trade | GET | `get_trade_easy_convert_history()` |
| trade | GET | `get_trade_one_click_repay_history_v2()` |
| trade | GET | `get_trade_account_rate_limit()` |
| trade | GET | `get_trade_fills()` |
| trade | POST | `post_trade_order()` |
| trade | POST | `post_trade_cancel_order()` |
| trade | POST | `post_trade_batch_orders()` |
| trade | POST | `post_trade_cancel_batch_orders()` |
| trade | POST | `post_trade_amend_order()` |
| trade | POST | `post_trade_amend_batch_orders()` |
| trade | POST | `post_trade_order_precheck()` |
| trade | POST | `post_trade_cancel_all_after()` |
| trade | POST | `post_trade_cancel_algos()` |
| trade | POST | `post_trade_amend_algos()` |
| trade | POST | `post_trade_mass_cancel()` |
| copy trading | GET | `get_copy_trade_my_leaders()` |
| copy trading | GET | `get_copy_trade_settings()` |
| copy trading | GET | `get_copy_trade_current_subpos()` |
| copy trading | GET | `get_copy_trade_historical_subpos()` |
| copy trading | GET | `get_copy_trade_instruments()` |
| copy trading | GET | `get_copy_trade_public_config()` |
| copy trading | GET | `get_copy_trade_public_lead_traders()` |
| copy trading | GET | `get_copy_trade_public_copy_traders()` |
| copy trading | GET | `get_copy_trade_public_preference_currency()` |
| copy trading | GET | `get_copy_trade_public_current_subpositions()` |
| copy trading | GET | `get_copy_trade_public_subpositions_history()` |
| copy trading | GET | `get_copy_trade_public_pnl()` |
| copy trading | GET | `get_copy_trade_public_stats()` |
| copy trading | GET | `get_copy_trade_public_weekly_pnl()` |
| copy trading | GET | `get_copy_trade_profit_sharing_details()` |
| copy trading | GET | `get_copy_trade_total_profit_sharing()` |

## Release notes

See [NEWS.md](NEWS.md) for release history.

## Development status

* [x] GET support for major endpoints
* [x] POST support for order, cancel, leverage, close position
* [x] Copy trading wrappers
* [x] Package metadata and generated documentation aligned for GitHub release
* [x] Automated test suite foundation
* [x] GitHub Actions package check workflow
* [x] CRAN-safe package examples and package-level help
* [x] Unsigned public endpoints and request timeout handling
* [x] CRAN policy hygiene files and release metadata cleanup
* [x] Mocked request/parser robustness tests
* [x] CRAN release-candidate documentation alignment
* [x] Manual CRAN preflight workflow for release checks
* [x] CRAN submission checklist for final manual steps
* [x] Final CRAN submission metadata update
* [x] CRAN reviewer-requested DESCRIPTION and Rd fixes
* [x] First CRAN release published
* [x] First post-CRAN endpoint expansion batch
* [x] Expanded public reference and index market coverage
* [x] Broader account inspection and sub-account GET coverage for v0.3.2
* [x] Broader trade history, algo-order, asset billing, and convert GET coverage for v0.3.3
* [x] Broader copy-trading coverage plus expanded asset history filter support for v0.3.4
* [x] Remaining copy-trading GET endpoints and copy-trading parameter completeness fixes for v0.3.5
* [x] First trade action expansion batch for v0.4.0
* [x] Advanced trade algo and mass-cancel action coverage for v0.4.1
* [x] Account configuration action coverage for v0.4.2
* [x] Account operational action coverage for v0.4.3
* [x] Asset transfer, withdrawal, and convert action coverage for v0.4.4
* [x] POST wrapper validation and cancellation parameter completeness for v0.4.5
* [ ] Websocket support

## License

MIT

## Author

Oliver Zhou
Lily Li
