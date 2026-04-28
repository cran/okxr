# okxr: R Interface to the OKX API

`okxr` is an R package for working with the OKX REST API from R. It provides
typed wrappers for market data, account endpoints, asset history, trading, and
copy trading, with shared request signing and schema-based response parsing.

## Status

`okxr` is a CRAN-targeted release candidate. It has not been submitted to CRAN
yet; until acceptance, install the development release from GitHub.

Current release: `v0.2.4`

## Features

* Signed OKX REST requests with HMAC authentication
* Typed parsing into tabular R objects with variable labels
* Shared internal GET/POST generators backed by endpoint specs
* User-facing wrappers for account, asset, market, trade, and copy-trading APIs
* Configurable raw vs parsed return mode via `set_okxr_options()`

## Installation

```r
# Development release
# install.packages("devtools")
devtools::install_github("OliverLDS/okxr")
```

After CRAN acceptance, installation will use:

```r
install.packages("okxr")
```

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
| public | GET | `get_public_time()` |
| account | GET | `get_account_balance()` |
| account | GET | `get_account_bills()` |
| asset | GET | `get_asset_balances()` |
| asset | GET | `get_asset_currencies()` |
| trade | GET | `get_trade_order()` |
| trade | GET | `get_trade_fills()` |
| trade | POST | `post_trade_order()` |
| trade | POST | `post_trade_cancel_order()` |
| copy trading | GET | `get_copy_trade_my_leaders()` |

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
* [ ] Websocket support

## License

MIT

## Author

Oliver Zhou
