test_that("GET wrappers build expected query strings", {
  ns <- asNamespace("okxr")
  old_gets <- get(".gets", envir = ns)
  unlockBinding(".gets", ns)
  on.exit({
    assign(".gets", old_gets, envir = ns)
    lockBinding(".gets", ns)
  }, add = TRUE)
  assign(
    ".gets",
    list(
      market_tickers = function(query_string, config, tz) query_string,
      market_history_trades = function(query_string, config, tz) query_string,
      account_bills = function(query_string, config, tz) query_string,
      asset_currencies = function(query_string, config, tz) query_string,
      trade_fills_history = function(query_string, config, tz) query_string
    ),
    envir = ns
  )

  expect_equal(
    okxr::get_market_tickers(inst_type = "SWAP", inst_family = "BTC-USDT"),
    "?instType=SWAP&instFamily=BTC-USDT"
  )
  expect_equal(
    okxr::get_market_history_trades("BTC-USDT", type = "1", limit = 10),
    "?instId=BTC-USDT&type=1&limit=10"
  )

  cfg <- list(api_key = "key", secret_key = "secret", passphrase = "pass")
  expect_equal(
    okxr::get_account_bills(ccy = "USDT", sub_type = "1", config = cfg),
    "?ccy=USDT&subType=1"
  )
  expect_equal(
    okxr::get_asset_currencies(ccy = "BTC,ETH", config = cfg),
    "?ccy=BTC%2CETH"
  )
  expect_equal(
    okxr::get_trade_fills_history(inst_type = "SPOT", limit = 10, config = cfg),
    "?instType=SPOT&limit=10"
  )
})

test_that("post_trade_order preserves supplied client order id", {
  ns <- asNamespace("okxr")
  old_posts <- get(".posts", envir = ns)
  unlockBinding(".posts", ns)
  on.exit({
    assign(".posts", old_posts, envir = ns)
    lockBinding(".posts", ns)
  }, add = TRUE)
  assign(
    ".posts",
    list(
      trade_order = function(body_list, tz, config) body_list
    ),
    envir = ns
  )

  cfg <- list(api_key = "key", secret_key = "secret", passphrase = "pass")
  body <- okxr::post_trade_order(
    inst_id = "BTC-USDT",
    td_mode = "cash",
    side = "buy",
    ord_type = "market",
    sz = "1",
    cl_ord_id = "custom-id",
    config = cfg
  )

  expect_equal(body$clOrdId, "custom-id")
})
