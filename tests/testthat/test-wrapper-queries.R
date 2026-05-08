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
      market_mark_price_candles = function(query_string, config, tz) query_string,
      market_history_mark_price_candles = function(query_string, config, tz) query_string,
      market_exchange_rate = function(query_string, config, tz) query_string,
      market_index_components = function(query_string, config, tz) query_string,
      market_platform_24_volume = function(query_string, config, tz) query_string,
      market_block_ticker = function(query_string, config, tz) query_string,
      market_block_tickers = function(query_string, config, tz) query_string,
      market_option_instrument_family_trades = function(query_string, config, tz) query_string,
      market_index_tickers = function(query_string, config, tz) query_string,
      market_index_candles = function(query_string, config, tz) query_string,
      market_history_index_candles = function(query_string, config, tz) query_string,
      public_underlying = function(query_string, config, tz) query_string,
      public_estimated_price = function(query_string, config, tz) query_string,
      public_delivery_exercise_history = function(query_string, config, tz) query_string,
      public_estimated_settlement_info = function(query_string, config, tz) query_string,
      public_settlement_history = function(query_string, config, tz) query_string,
      public_discount_rate_interest_free_quota = function(query_string, config, tz) query_string,
      public_opt_summary = function(query_string, config, tz) query_string,
      public_position_tiers = function(query_string, config, tz) query_string,
      public_economic_calendar = function(query_string, config, tz) query_string,
      public_interest_rate_loan_quota = function(query_string, config, tz) query_string,
      public_insurance_fund = function(query_string, config, tz) query_string,
      public_convert_contract_coin = function(query_string, config, tz) query_string,
      public_instrument_tick_bands = function(query_string, config, tz) query_string,
      public_premium_history = function(query_string, config, tz) query_string,
      public_block_trades = function(query_string, config, tz) query_string,
      public_option_trades = function(query_string, config, tz) query_string,
      account_bills = function(query_string, config, tz) query_string,
      account_instruments = function(query_string, config, tz) query_string,
      account_subtypes = function(query_string, config, tz) query_string,
      account_adjust_leverage_info = function(query_string, config, tz) query_string,
      account_max_loan = function(query_string, config, tz) query_string,
      account_position_risk = function(query_string, config, tz) query_string,
      account_max_size = function(query_string, config, tz) query_string,
      account_max_avail_size = function(query_string, config, tz) query_string,
      account_trade_fee = function(query_string, config, tz) query_string,
      account_interest_rate = function(query_string, config, tz) query_string,
      account_interest_accrued = function(query_string, config, tz) query_string,
      account_max_withdrawal = function(query_string, config, tz) query_string,
      account_risk_state = function(query_string, config, tz) query_string,
      account_interest_limits = function(query_string, config, tz) query_string,
      account_greeks = function(query_string, config, tz) query_string,
      account_position_tiers = function(query_string, config, tz) query_string,
      account_collateral_assets = function(query_string, config, tz) query_string,
      account_mmp_config = function(query_string, config, tz) query_string,
      account_move_positions_history = function(query_string, config, tz) query_string,
      account_precheck_set_delta_neutral = function(query_string, config, tz) query_string,
      account_bills_history_archive = function(query_string, config, tz) query_string,
      account_subaccount_balances = function(query_string, config, tz) query_string,
      account_subaccount_max_withdrawal = function(query_string, config, tz) query_string,
      account_set_account_switch_precheck = function(query_string, config, tz) query_string,
      account_spot_borrow_repay_history = function(query_string, config, tz) query_string,
      copy_trade_settings = function(query_string, config, tz) query_string,
      copy_trade_current_subpos = function(query_string, config, tz) query_string,
      copy_trade_historical_subpos = function(query_string, config, tz) query_string,
      copy_trade_instruments = function(query_string, config, tz) query_string,
      copy_trade_config = function(query_string, config, tz) query_string,
      copy_trade_public_config = function(query_string, config, tz) query_string,
      copy_trade_public_copy_traders = function(query_string, config, tz) query_string,
      copy_trade_public_lead_traders = function(query_string, config, tz) query_string,
      copy_trade_public_current_subpositions = function(query_string, config, tz) query_string,
      copy_trade_public_subpositions_history = function(query_string, config, tz) query_string,
      copy_trade_public_pnl = function(query_string, config, tz) query_string,
      copy_trade_public_stats = function(query_string, config, tz) query_string,
      copy_trade_public_weekly_pnl = function(query_string, config, tz) query_string,
      copy_trade_public_preference_currency = function(query_string, config, tz) query_string,
      copy_trade_profit_sharing_details = function(query_string, config, tz) query_string,
      copy_trade_unrealized_profit_sharing_details = function(query_string, config, tz) query_string,
      copy_trade_total_profit_sharing = function(query_string, config, tz) query_string,
      copy_trade_total_unrealized_profit_sharing = function(query_string, config, tz) query_string,
      asset_deposit_history = function(query_string, config, tz) query_string,
      asset_withdrawal_history = function(query_string, config, tz) query_string,
      asset_currencies = function(query_string, config, tz) query_string,
      asset_non_tradable_assets = function(query_string, config, tz) query_string,
      asset_asset_valuation = function(query_string, config, tz) query_string,
      asset_transfer_state = function(query_string, config, tz) query_string,
      asset_bills = function(query_string, config, tz) query_string,
      asset_bills_history = function(query_string, config, tz) query_string,
      asset_deposit_withdraw_status = function(query_string, config, tz) query_string,
      asset_exchange_list = function(query_string, config, tz) query_string,
      asset_convert_currencies = function(query_string, config, tz) query_string,
      asset_convert_currency_pair = function(query_string, config, tz) query_string,
      asset_convert_history = function(query_string, config, tz) query_string,
      trade_orders_history = function(query_string, config, tz) query_string,
      trade_orders_history_archive = function(query_string, config, tz) query_string,
      trade_easy_convert_currency_list = function(query_string, config, tz) query_string,
      trade_easy_convert_history = function(query_string, config, tz) query_string,
      trade_one_click_repay_currency_list = function(query_string, config, tz) query_string,
      trade_one_click_repay_history = function(query_string, config, tz) query_string,
      trade_one_click_repay_currency_list_v2 = function(query_string, config, tz) query_string,
      trade_one_click_repay_history_v2 = function(query_string, config, tz) query_string,
      trade_order_algo = function(query_string, config, tz) query_string,
      trade_orders_algo_pending = function(query_string, config, tz) query_string,
      trade_orders_algo_history = function(query_string, config, tz) query_string,
      trade_fills = function(query_string, config, tz) query_string,
      trade_fills_history = function(query_string, config, tz) query_string,
      trade_account_rate_limit = function(query_string, config, tz) query_string
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
  expect_equal(
    okxr::get_market_mark_price_candles("BTC-USD-SWAP", bar = "1H", limit = 20, standardize_names = FALSE),
    "?instId=BTC-USD-SWAP&bar=1H&limit=20"
  )
  expect_equal(
    okxr::get_market_history_mark_price_candles("BTC-USD-SWAP", before = "200", limit = 20, standardize_names = FALSE),
    "?instId=BTC-USD-SWAP&before=200&limit=20"
  )
  expect_equal(
    okxr::get_market_exchange_rate(),
    ""
  )
  expect_equal(
    okxr::get_market_index_components("BTC-USD"),
    "?index=BTC-USD"
  )
  expect_equal(
    okxr::get_market_platform_24_volume(),
    ""
  )
  expect_equal(
    okxr::get_market_block_ticker("BTC-USD-SWAP"),
    "?instId=BTC-USD-SWAP"
  )
  expect_equal(
    okxr::get_market_block_tickers(inst_type = "SWAP", inst_family = "BTC-USD"),
    "?instType=SWAP&instFamily=BTC-USD"
  )
  expect_equal(
    okxr::get_market_index_tickers(quote_ccy = "USD"),
    "?quoteCcy=USD"
  )
  expect_equal(
    okxr::get_market_index_candles("BTC-USD", bar = "1H", limit = 50, standardize_names = FALSE),
    "?instId=BTC-USD&bar=1H&limit=50"
  )
  expect_equal(
    okxr::get_market_history_index_candles("BTC-USD", before = "200", limit = 20, standardize_names = FALSE),
    "?instId=BTC-USD&before=200&limit=20"
  )
  expect_equal(
    okxr::get_market_option_instrument_family_trades("BTC-USD"),
    "?instFamily=BTC-USD"
  )
  expect_equal(
    okxr::get_public_underlying(inst_type = "FUTURES"),
    "?instType=FUTURES"
  )
  expect_equal(
    okxr::get_public_estimated_price(inst_type = "FUTURES", inst_family = "BTC-USD"),
    "?instType=FUTURES&instFamily=BTC-USD"
  )
  expect_equal(
    okxr::get_public_delivery_exercise_history(inst_type = "OPTION", inst_family = "BTC-USD", limit = 5),
    "?instType=OPTION&instFamily=BTC-USD&limit=5"
  )
  expect_equal(
    okxr::get_public_estimated_settlement_info("XRP-USDT-250307"),
    "?instId=XRP-USDT-250307"
  )
  expect_equal(
    okxr::get_public_settlement_history(inst_family = "XRP-USD", limit = 10),
    "?instFamily=XRP-USD&limit=10"
  )
  expect_equal(
    okxr::get_public_discount_rate_interest_free_quota(ccy = "BTC", discount_lv = "1"),
    "?ccy=BTC&discountLv=1"
  )
  expect_equal(
    okxr::get_public_opt_summary(inst_family = "BTC-USD", exp_time = "250328"),
    "?instFamily=BTC-USD&expTime=250328"
  )
  expect_equal(
    okxr::get_public_position_tiers(inst_type = "SWAP", td_mode = "cross", inst_family = "BTC-USDT"),
    "?instType=SWAP&tdMode=cross&instFamily=BTC-USDT"
  )
  expect_equal(
    okxr::get_public_interest_rate_loan_quota(ccy = "USDT", vip_level = "VIP1"),
    "?ccy=USDT&vipLevel=VIP1"
  )
  expect_equal(
    okxr::get_public_block_trades("BTC-USDT"),
    "?instId=BTC-USDT"
  )
  expect_equal(
    okxr::get_public_insurance_fund(inst_type = "SWAP", inst_family = "BTC-USD", limit = 5),
    "?instType=SWAP&instFamily=BTC-USD&limit=5"
  )
  expect_equal(
    okxr::get_public_convert_contract_coin(inst_id = "BTC-USD-SWAP", sz = "1", type = "1", px = "35000"),
    "?type=1&instId=BTC-USD-SWAP&sz=1&px=35000"
  )
  expect_equal(
    okxr::get_public_instrument_tick_bands(inst_family = "BTC-USD"),
    "?instType=OPTION&instFamily=BTC-USD"
  )
  expect_equal(
    okxr::get_public_premium_history(inst_id = "BTC-USD-SWAP", bar = "1H", limit = 100),
    "?instId=BTC-USD-SWAP&bar=1H&limit=100"
  )
  expect_equal(
    okxr::get_public_option_trades(inst_family = "BTC-USD", opt_type = "P"),
    "?instFamily=BTC-USD&optType=P"
  )
  expect_equal(
    okxr::get_copy_trade_public_config(inst_type = "SWAP"),
    "?instType=SWAP"
  )
  expect_equal(
    okxr::get_copy_trade_public_copy_traders(unique_code = "leader-1", inst_type = "SWAP", limit = 5),
    "?uniqueCode=leader-1&instType=SWAP&limit=5"
  )
  expect_equal(
    okxr::get_copy_trade_public_lead_traders(inst_type = "SWAP", sort_type = "pnl", state = "1", limit = 5),
    "?instType=SWAP&sortType=pnl&state=1&limit=5"
  )
  expect_equal(
    okxr::get_copy_trade_public_current_subpositions(unique_code = "leader-1", before = "200", limit = 10),
    "?uniqueCode=leader-1&before=200&limit=10"
  )
  expect_equal(
    okxr::get_copy_trade_public_subpositions_history(unique_code = "leader-1", after = "100", limit = 10),
    "?uniqueCode=leader-1&after=100&limit=10"
  )
  expect_equal(
    okxr::get_copy_trade_public_pnl(unique_code = "leader-1", last_days = "2", inst_type = "SWAP"),
    "?uniqueCode=leader-1&lastDays=2&instType=SWAP"
  )
  expect_equal(
    okxr::get_copy_trade_public_stats(unique_code = "leader-1", last_days = "4"),
    "?uniqueCode=leader-1&lastDays=4"
  )
  expect_equal(
    okxr::get_copy_trade_public_weekly_pnl(unique_code = "leader-1", inst_type = "SWAP"),
    "?uniqueCode=leader-1&instType=SWAP"
  )
  expect_equal(
    okxr::get_copy_trade_public_preference_currency(unique_code = "leader-1", inst_type = "SWAP"),
    "?uniqueCode=leader-1&instType=SWAP"
  )

  cfg <- list(api_key = "key", secret_key = "secret", passphrase = "pass")
  expect_equal(
    okxr::get_copy_trade_settings(unique_code = "leader-1", inst_type = "SWAP", config = cfg),
    "?uniqueCode=leader-1&instType=SWAP"
  )
  expect_equal(
    okxr::get_copy_trade_current_subpos(inst_type = "SWAP", inst_id = "BTC-USDT-SWAP", after = "100", limit = 10, config = cfg),
    "?instType=SWAP&instId=BTC-USDT-SWAP&after=100&limit=10"
  )
  expect_equal(
    okxr::get_copy_trade_historical_subpos(inst_type = "SWAP", inst_id = "BTC-USDT-SWAP", before = "200", limit = 10, config = cfg),
    "?instType=SWAP&instId=BTC-USDT-SWAP&before=200&limit=10"
  )
  expect_equal(
    okxr::get_copy_trade_instruments(inst_type = "SWAP", config = cfg),
    "?instType=SWAP"
  )
  expect_equal(
    okxr::get_copy_trade_config(config = cfg),
    ""
  )
  expect_equal(
    okxr::get_copy_trade_profit_sharing_details(inst_type = "SWAP", after = "100", limit = 10, config = cfg),
    "?instType=SWAP&after=100&limit=10"
  )
  expect_equal(
    okxr::get_copy_trade_unrealized_profit_sharing_details(inst_type = "SPOT", config = cfg),
    "?instType=SPOT"
  )
  expect_equal(
    okxr::get_copy_trade_total_profit_sharing(inst_type = "SWAP", config = cfg),
    "?instType=SWAP"
  )
  expect_equal(
    okxr::get_copy_trade_total_unrealized_profit_sharing(inst_type = "SWAP", config = cfg),
    "?instType=SWAP"
  )
  expect_equal(
    okxr::get_public_economic_calendar(region = "united_states", importance = "3", config = cfg),
    "?region=united_states&importance=3"
  )
  expect_equal(
    okxr::get_account_instruments(inst_type = "SPOT", inst_id = "BTC-USDT", config = cfg),
    "?instType=SPOT&instId=BTC-USDT"
  )
  expect_equal(
    okxr::get_account_subtypes(type = "1,2", config = cfg),
    "?type=1%2C2"
  )
  expect_equal(
    okxr::get_account_adjust_leverage_info(inst_type = "MARGIN", mgn_mode = "isolated", lever = 3, inst_id = "BTC-USDT", config = cfg),
    "?instType=MARGIN&mgnMode=isolated&lever=3&instId=BTC-USDT"
  )
  expect_equal(
    okxr::get_account_max_loan(mgn_mode = "cross", inst_id = "BTC-USDT", mgn_ccy = "BTC", config = cfg),
    "?mgnMode=cross&instId=BTC-USDT&mgnCcy=BTC"
  )
  expect_equal(
    okxr::get_account_position_risk(inst_type = "SWAP", config = cfg),
    "?instType=SWAP"
  )
  expect_equal(
    okxr::get_account_max_size(
      inst_id = "BTC-USDT",
      td_mode = "isolated",
      ccy = "BTC",
      leverage = 3,
      config = cfg
    ),
    "?instId=BTC-USDT&tdMode=isolated&ccy=BTC&leverage=3"
  )
  expect_equal(
    okxr::get_account_max_avail_size(
      inst_id = "BTC-USDT",
      td_mode = "cash",
      trade_quote_ccy = "USD",
      config = cfg
    ),
    "?instId=BTC-USDT&tdMode=cash&tradeQuoteCcy=USD"
  )
  expect_equal(
    okxr::get_account_trade_fee(inst_type = "SPOT", inst_id = "BTC-USDT", config = cfg),
    "?instType=SPOT&instId=BTC-USDT"
  )
  expect_equal(
    okxr::get_account_interest_rate(ccy = "BTC", config = cfg),
    "?ccy=BTC"
  )
  expect_equal(
    okxr::get_account_interest_accrued(ccy = "BTC", mgn_mode = "cross", limit = 10, config = cfg),
    "?ccy=BTC&mgnMode=cross&limit=10"
  )
  expect_equal(
    okxr::get_account_max_withdrawal(ccy = "BTC,ETH", config = cfg),
    "?ccy=BTC%2CETH"
  )
  expect_equal(
    okxr::get_account_risk_state(config = cfg),
    ""
  )
  expect_equal(
    okxr::get_account_interest_limits(type = "2", ccy = "BTC", config = cfg),
    "?type=2&ccy=BTC"
  )
  expect_equal(
    okxr::get_account_greeks(ccy = "BTC", config = cfg),
    "?ccy=BTC"
  )
  expect_equal(
    okxr::get_account_position_tiers(inst_type = "SWAP", inst_family = "BTC-USDT", config = cfg),
    "?instType=SWAP&instFamily=BTC-USDT"
  )
  expect_equal(
    okxr::get_account_collateral_assets(ccy = "BTC,ETH", collateral_enabled = TRUE, config = cfg),
    "?ccy=BTC%2CETH&collateralEnabled=TRUE"
  )
  expect_equal(
    okxr::get_account_mmp_config(inst_family = "BTC-USD", config = cfg),
    "?instFamily=BTC-USD"
  )
  expect_equal(
    okxr::get_account_move_positions_history(client_id = "move-1", state = "filled", limit = 5, config = cfg),
    "?clientId=move-1&limit=5&state=filled"
  )
  expect_equal(
    okxr::get_account_precheck_set_delta_neutral(stgy_type = 1, config = cfg),
    "?stgyType=1"
  )
  expect_equal(
    okxr::get_account_bills_history_archive(year = 2024, quarter = "Q1", type = "1,2", config = cfg),
    "?year=2024&quarter=Q1&type=1%2C2"
  )
  expect_equal(
    okxr::get_account_subaccount_balances(sub_acct = "desk_1", config = cfg),
    "?subAcct=desk_1"
  )
  expect_equal(
    okxr::get_account_subaccount_max_withdrawal(sub_acct = "desk_1", ccy = "BTC", config = cfg),
    "?subAcct=desk_1&ccy=BTC"
  )
  expect_equal(
    okxr::get_account_set_account_switch_precheck(acct_lv = 3, config = cfg),
    "?acctLv=3"
  )
  expect_equal(
    okxr::get_account_spot_borrow_repay_history(ccy = "USDT", type = "auto_repay", limit = 20, config = cfg),
    "?ccy=USDT&type=auto_repay&limit=20"
  )
  expect_equal(
    okxr::get_account_bills(ccy = "USDT", sub_type = "1", config = cfg),
    "?ccy=USDT&subType=1"
  )
  expect_equal(
    okxr::get_asset_deposit_history(ccy = "BTC", tx_id = "tx-1", state = "2", limit = 20, config = cfg),
    "?ccy=BTC&txId=tx-1&state=2&limit=20"
  )
  expect_equal(
    okxr::get_asset_withdrawal_history(ccy = "USDT", wd_id = "wd-1", client_id = "client-1", limit = 20, config = cfg),
    "?ccy=USDT&wdId=wd-1&clientId=client-1&limit=20"
  )
  expect_equal(
    okxr::get_asset_currencies(ccy = "BTC,ETH", config = cfg),
    "?ccy=BTC%2CETH"
  )
  expect_equal(
    okxr::get_asset_non_tradable_assets(ccy = "ETH", config = cfg),
    "?ccy=ETH"
  )
  expect_equal(
    okxr::get_asset_asset_valuation(ccy = "USD", config = cfg),
    "?ccy=USD"
  )
  expect_equal(
    okxr::get_asset_transfer_state(trans_id = "1", type = "0", config = cfg),
    "?transId=1&type=0"
  )
  expect_equal(
    okxr::get_asset_bills(ccy = "USDT", type = "2", limit = 10, config = cfg),
    "?ccy=USDT&type=2&limit=10"
  )
  expect_equal(
    okxr::get_asset_bills_history(ccy = "USDT", paging_type = "2", limit = 10, config = cfg),
    "?ccy=USDT&limit=10&pagingType=2"
  )
  expect_equal(
    okxr::get_asset_deposit_withdraw_status(wd_id = "200045249", config = cfg),
    "?wdId=200045249"
  )
  expect_equal(
    okxr::get_asset_exchange_list(),
    ""
  )
  expect_equal(
    okxr::get_asset_convert_currencies(config = cfg),
    ""
  )
  expect_equal(
    okxr::get_asset_convert_currency_pair(from_ccy = "USDT", to_ccy = "BTC", convert_mode = "1", config = cfg),
    "?fromCcy=USDT&toCcy=BTC&convertMode=1"
  )
  expect_equal(
    okxr::get_asset_convert_history(cl_t_req_id = "req-1", limit = 10, tag = "desk", config = cfg),
    "?clTReqId=req-1&limit=10&tag=desk"
  )
  expect_equal(
    okxr::get_trade_orders_history(inst_type = "SPOT", ord_type = "ioc", limit = 10, config = cfg),
    "?instType=SPOT&ordType=ioc&limit=10"
  )
  expect_equal(
    okxr::get_trade_orders_history_archive(inst_type = "SPOT", category = "delivery", config = cfg),
    "?instType=SPOT&category=delivery"
  )
  expect_equal(
    okxr::get_trade_easy_convert_currency_list(source = "funding", config = cfg),
    "?source=funding"
  )
  expect_equal(
    okxr::get_trade_easy_convert_history(limit = 20, config = cfg),
    "?limit=20"
  )
  expect_equal(
    okxr::get_trade_one_click_repay_currency_list(debt_type = "1", config = cfg),
    "?debtType=1"
  )
  expect_equal(
    okxr::get_trade_one_click_repay_history(limit = 20, config = cfg),
    "?limit=20"
  )
  expect_equal(
    okxr::get_trade_one_click_repay_currency_list_v2(config = cfg),
    ""
  )
  expect_equal(
    okxr::get_trade_one_click_repay_history_v2(limit = 20, config = cfg),
    "?limit=20"
  )
  expect_equal(
    okxr::get_trade_order_algo(algo_id = "123", config = cfg),
    "?algoId=123"
  )
  expect_equal(
    okxr::get_trade_orders_algo_pending(ord_type = "conditional", inst_id = "BTC-USDT", config = cfg),
    "?ordType=conditional&instId=BTC-USDT"
  )
  expect_equal(
    okxr::get_trade_orders_algo_history(ord_type = "conditional", state = "effective", config = cfg),
    "?ordType=conditional&state=effective"
  )
  expect_equal(
    okxr::get_trade_fills(inst_type = "SPOT", begin = "1000", end = "2000", limit = 10, config = cfg),
    "?instType=SPOT&limit=10&begin=1000&end=2000"
  )
  expect_equal(
    okxr::get_trade_fills_history(inst_type = "SPOT", limit = 10, config = cfg),
    "?instType=SPOT&limit=10"
  )
  expect_equal(
    okxr::get_trade_fills_history(inst_type = "SPOT", begin = "1000", end = "2000", limit = 10, config = cfg),
    "?instType=SPOT&limit=10&begin=1000&end=2000"
  )
  expect_equal(
    okxr::get_trade_account_rate_limit(config = cfg),
    ""
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

test_that("trade POST wrappers reject malformed identifier and batch inputs", {
  cfg <- list(api_key = "key", secret_key = "secret", passphrase = "pass")

  expect_error(
    okxr::post_trade_cancel_order(inst_id = "BTC-USDT", config = cfg),
    "Provide exactly one of `ord_id` or `cl_ord_id`"
  )
  expect_error(
    okxr::post_trade_batch_orders(orders = list(), config = cfg),
    "`orders` must be a non-empty list"
  )
  expect_error(
    okxr::post_trade_cancel_batch_orders(
      orders = list(list(inst_id = "BTC-USDT", ord_id = "1", cl_ord_id = "2")),
      config = cfg
    ),
    "Provide exactly one of `ord_id` or `cl_ord_id`"
  )
  expect_error(
    okxr::post_trade_amend_order(inst_id = "BTC-USDT", ord_id = "1", config = cfg),
    "must include at least one of"
  )
  expect_error(
    okxr::post_trade_amend_batch_orders(
      orders = list(list(inst_id = "BTC-USDT", ord_id = "1")),
      config = cfg
    ),
    "must include at least one of"
  )
  expect_error(
    okxr::post_trade_cancel_algos(
      orders = list(list(inst_id = "BTC-USDT", algo_id = "1", algo_cl_ord_id = "2")),
      config = cfg
    ),
    "Provide exactly one of `algo_id` or `algo_cl_ord_id`"
  )
  expect_error(
    okxr::post_trade_amend_algos(inst_id = "BTC-USDT", algo_id = "1", config = cfg),
    "must include at least one of"
  )
})

test_that("trade POST wrappers build expected request bodies", {
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
      trade_cancel_order = function(body_list, tz, config) body_list,
      trade_batch_orders = function(body_list, tz, config) body_list,
      trade_cancel_batch_orders = function(body_list, tz, config) body_list,
      trade_amend_order = function(body_list, tz, config) body_list,
      trade_amend_batch_orders = function(body_list, tz, config) body_list,
      trade_order_precheck = function(body_list, tz, config) body_list,
      trade_cancel_all_after = function(body_list, tz, config) body_list,
      trade_cancel_algos = function(body_list, tz, config) body_list,
      trade_amend_algos = function(body_list, tz, config) body_list,
      trade_mass_cancel = function(body_list, tz, config) body_list
    ),
    envir = ns
  )

  cfg <- list(api_key = "key", secret_key = "secret", passphrase = "pass")

  cancel_order_body <- okxr::post_trade_cancel_order(
    inst_id = "BTC-USDT",
    cl_ord_id = "cancel-client-1",
    config = cfg
  )
  expect_equal(cancel_order_body$instId, "BTC-USDT")
  expect_equal(cancel_order_body$clOrdId, "cancel-client-1")

  batch_body <- okxr::post_trade_batch_orders(
    orders = list(
      list(inst_id = "BTC-USDT", td_mode = "cash", side = "buy", ord_type = "limit", px = "2.15", sz = "2", cl_ord_id = "b15"),
      list(inst_id = "BTC-USDT", td_mode = "cash", side = "buy", ord_type = "limit", px = "2.15", sz = "2", cl_ord_id = "b16")
    ),
    config = cfg
  )
  expect_equal(batch_body[[1]]$clOrdId, "b15")
  expect_equal(batch_body[[2]]$clOrdId, "b16")

  cancel_batch_body <- okxr::post_trade_cancel_batch_orders(
    orders = list(
      list(inst_id = "BTC-USDT", ord_id = "123"),
      list(inst_id = "BTC-USDT", cl_ord_id = "client-2")
    ),
    config = cfg
  )
  expect_equal(cancel_batch_body[[1]]$ordId, "123")
  expect_equal(cancel_batch_body[[2]]$clOrdId, "client-2")

  amend_body <- okxr::post_trade_amend_order(
    inst_id = "BTC-USDT",
    ord_id = "123",
    req_id = "amend-1",
    new_sz = "2",
    cxl_on_fail = TRUE,
    config = cfg
  )
  expect_equal(amend_body$reqId, "amend-1")
  expect_equal(amend_body$cxlOnFail, "true")

  amend_batch_body <- okxr::post_trade_amend_batch_orders(
    orders = list(
      list(inst_id = "BTC-USDT", ord_id = "123", new_sz = "2"),
      list(inst_id = "BTC-USDT", cl_ord_id = "client-2", new_px = "2.20")
    ),
    config = cfg
  )
  expect_equal(amend_batch_body[[1]]$newSz, "2")
  expect_equal(amend_batch_body[[2]]$newPx, "2.20")

  precheck_body <- okxr::post_trade_order_precheck(
    inst_id = "BTC-USDT",
    td_mode = "cash",
    side = "buy",
    ord_type = "limit",
    px = "2.15",
    sz = "2",
    reduce_only = TRUE,
    config = cfg
  )
  expect_equal(precheck_body$reduceOnly, "true")
  expect_equal(precheck_body$ordType, "limit")

  caa_body <- okxr::post_trade_cancel_all_after(
    time_out = 60,
    tag = "desk1",
    config = cfg
  )
  expect_equal(caa_body$timeOut, "60")
  expect_equal(caa_body$tag, "desk1")

  cancel_algos_body <- okxr::post_trade_cancel_algos(
    orders = list(
      list(inst_id = "BTC-USDT", algo_id = "algo-1"),
      list(inst_id = "BTC-USDT", algo_cl_ord_id = "algo-client-2")
    ),
    config = cfg
  )
  expect_equal(cancel_algos_body[[1]]$algoId, "algo-1")
  expect_equal(cancel_algos_body[[2]]$algoClOrdId, "algo-client-2")

  amend_algos_body <- okxr::post_trade_amend_algos(
    inst_id = "BTC-USDT",
    algo_id = "algo-1",
    req_id = "algo-amend-1",
    new_sz = "2",
    cxl_on_fail = TRUE,
    new_trigger_px = "62000",
    new_ord_px = "-1",
    config = cfg
  )
  expect_equal(amend_algos_body$algoId, "algo-1")
  expect_equal(amend_algos_body$reqId, "algo-amend-1")
  expect_equal(amend_algos_body$cxlOnFail, "true")
  expect_equal(amend_algos_body$newTriggerPx, "62000")

  mass_cancel_body <- okxr::post_trade_mass_cancel(
    inst_type = "OPTION",
    inst_family = "BTC-USD",
    lock_interval = "500",
    config = cfg
  )
  expect_equal(mass_cancel_body$instType, "OPTION")
  expect_equal(mass_cancel_body$instFamily, "BTC-USD")
  expect_equal(mass_cancel_body$lockInterval, "500")
})

test_that("account POST wrappers build expected request bodies", {
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
      account_set_position_mode = function(body_list, tz, config) body_list,
      account_set_fee_type = function(body_list, tz, config) body_list,
      account_set_greeks = function(body_list, tz, config) body_list,
      account_set_auto_repay = function(body_list, tz, config) body_list,
      account_set_auto_loan = function(body_list, tz, config) body_list,
      account_set_account_level = function(body_list, tz, config) body_list,
      account_set_collateral_assets = function(body_list, tz, config) body_list
    ),
    envir = ns
  )

  cfg <- list(api_key = "key", secret_key = "secret", passphrase = "pass")

  pos_mode_body <- okxr::post_account_set_position_mode(
    pos_mode = "long_short_mode",
    config = cfg
  )
  expect_equal(pos_mode_body$posMode, "long_short_mode")

  fee_type_body <- okxr::post_account_set_fee_type(
    fee_type = "1",
    config = cfg
  )
  expect_equal(fee_type_body$feeType, "1")

  greeks_body <- okxr::post_account_set_greeks(
    greeks_type = "PA",
    config = cfg
  )
  expect_equal(greeks_body$greeksType, "PA")

  auto_repay_body <- okxr::post_account_set_auto_repay(
    auto_repay = TRUE,
    config = cfg
  )
  expect_identical(auto_repay_body$autoRepay, TRUE)

  auto_loan_body <- okxr::post_account_set_auto_loan(
    auto_loan = FALSE,
    config = cfg
  )
  expect_identical(auto_loan_body$autoLoan, FALSE)

  acct_lv_body <- okxr::post_account_set_account_level(
    acct_lv = "3",
    config = cfg
  )
  expect_equal(acct_lv_body$acctLv, "3")

  collateral_body <- okxr::post_account_set_collateral_assets(
    type = "custom",
    collateral_enabled = FALSE,
    ccy_list = c("BTC", "ETH"),
    config = cfg
  )
  expect_equal(collateral_body$type, "custom")
  expect_identical(collateral_body$collateralEnabled, FALSE)
  expect_equal(collateral_body$ccyList, c("BTC", "ETH"))
})

test_that("account operational POST wrappers build expected request bodies", {
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
      account_position_margin_balance = function(body_list, tz, config) body_list,
      account_spot_manual_borrow_repay = function(body_list, tz, config) body_list,
      account_account_level_switch_preset = function(body_list, tz, config) body_list,
      account_mmp_reset = function(body_list, tz, config) body_list,
      account_mmp_config = function(body_list, tz, config) body_list,
      account_move_positions = function(body_list, tz, config) body_list
    ),
    envir = ns
  )

  cfg <- list(api_key = "key", secret_key = "secret", passphrase = "pass")

  expect_error(
    okxr::post_account_move_positions(from_acct = "0", to_acct = "sub1", legs = list(), client_id = "move-1", config = cfg),
    "`legs` must be a non-empty list"
  )

  margin_body <- okxr::post_account_position_margin_balance(
    inst_id = "BTC-USDT-SWAP",
    pos_side = "short",
    type = "add",
    amt = "1",
    ccy = "BTC",
    config = cfg
  )
  expect_equal(margin_body$instId, "BTC-USDT-SWAP")
  expect_equal(margin_body$posSide, "short")
  expect_equal(margin_body$type, "add")
  expect_equal(margin_body$ccy, "BTC")

  borrow_body <- okxr::post_account_spot_manual_borrow_repay(
    ccy = "USDT",
    side = "borrow",
    amt = "100",
    config = cfg
  )
  expect_equal(borrow_body$ccy, "USDT")
  expect_equal(borrow_body$side, "borrow")
  expect_equal(borrow_body$amt, "100")

  preset_body <- okxr::post_account_account_level_switch_preset(
    acct_lv = "2",
    lever = "10",
    risk_offset_type = "1",
    config = cfg
  )
  expect_equal(preset_body$acctLv, "2")
  expect_equal(preset_body$lever, "10")
  expect_equal(preset_body$riskOffsetType, "1")

  mmp_reset_body <- okxr::post_account_mmp_reset(
    inst_family = "BTC-USD",
    inst_type = "OPTION",
    config = cfg
  )
  expect_equal(mmp_reset_body$instFamily, "BTC-USD")
  expect_equal(mmp_reset_body$instType, "OPTION")

  mmp_config_body <- okxr::post_account_mmp_config(
    inst_family = "BTC-USD",
    time_interval = "5000",
    frozen_interval = "2000",
    qty_limit = "100",
    config = cfg
  )
  expect_equal(mmp_config_body$instFamily, "BTC-USD")
  expect_equal(mmp_config_body$timeInterval, "5000")
  expect_equal(mmp_config_body$frozenInterval, "2000")
  expect_equal(mmp_config_body$qtyLimit, "100")

  legs <- list(
    list(
      from = list(posId = "pos-1", side = "sell", sz = "1"),
      to = list(posSide = "net", tdMode = "cross")
    )
  )
  move_body <- okxr::post_account_move_positions(
    from_acct = "0",
    to_acct = "sub1",
    legs = legs,
    client_id = "move-1",
    config = cfg
  )
  expect_equal(move_body$fromAcct, "0")
  expect_equal(move_body$toAcct, "sub1")
  expect_equal(move_body$clientId, "move-1")
  expect_equal(move_body$legs[[1]]$from$posId, "pos-1")
  expect_equal(move_body$legs[[1]]$to$tdMode, "cross")
})

test_that("asset POST wrappers build expected request bodies", {
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
      asset_transfer = function(body_list, tz, config) body_list,
      asset_withdrawal = function(body_list, tz, config) body_list,
      asset_cancel_withdrawal = function(body_list, tz, config) body_list,
      asset_convert_estimate_quote = function(body_list, tz, config) body_list,
      asset_convert_trade = function(body_list, tz, config) body_list
    ),
    envir = ns
  )

  cfg <- list(api_key = "key", secret_key = "secret", passphrase = "pass")

  expect_error(
    okxr::post_asset_transfer(ccy = "USDT", amt = "100", from = "6", to = "6", config = cfg),
    "`from` and `to` must be different account codes"
  )

  transfer_body <- okxr::post_asset_transfer(
    ccy = "USDT",
    amt = "100",
    from = "6",
    to = "18",
    type = "1",
    sub_acct = "desk-sub",
    loan_trans = TRUE,
    omit_pos_risk = FALSE,
    client_id = "transfer-1",
    config = cfg
  )
  expect_equal(transfer_body$ccy, "USDT")
  expect_equal(transfer_body$from, "6")
  expect_equal(transfer_body$to, "18")
  expect_identical(transfer_body$loanTrans, TRUE)
  expect_identical(transfer_body$omitPosRisk, FALSE)
  expect_equal(transfer_body$clientId, "transfer-1")

  rcvr_info <- list(
    walletType = "exchange",
    exchId = "binance",
    rcvrFirstName = "Lily",
    rcvrLastName = "Li"
  )
  withdrawal_body <- okxr::post_asset_withdrawal(
    ccy = "USDT",
    amt = "50",
    dest = "4",
    to_addr = "0xabc",
    chain = "USDT-ERC20",
    to_addr_type = "1",
    area_code = "852",
    rcvr_info = rcvr_info,
    client_id = "withdraw-1",
    config = cfg
  )
  expect_equal(withdrawal_body$ccy, "USDT")
  expect_equal(withdrawal_body$toAddr, "0xabc")
  expect_equal(withdrawal_body$chain, "USDT-ERC20")
  expect_equal(withdrawal_body$rcvrInfo$exchId, "binance")
  expect_equal(withdrawal_body$clientId, "withdraw-1")

  cancel_withdrawal_body <- okxr::post_asset_cancel_withdrawal(
    wd_id = "wd-1",
    config = cfg
  )
  expect_equal(cancel_withdrawal_body$wdId, "wd-1")

  estimate_quote_body <- okxr::post_asset_convert_estimate_quote(
    base_ccy = "BTC",
    quote_ccy = "USDT",
    side = "sell",
    rfq_sz = "0.1",
    rfq_sz_ccy = "BTC",
    cl_q_req_id = "quote-1",
    tag = "desk1",
    convert_mode = "cash",
    config = cfg
  )
  expect_equal(estimate_quote_body$baseCcy, "BTC")
  expect_equal(estimate_quote_body$quoteCcy, "USDT")
  expect_equal(estimate_quote_body$rfqSz, "0.1")
  expect_equal(estimate_quote_body$clQReqId, "quote-1")

  convert_trade_body <- okxr::post_asset_convert_trade(
    quote_id = "quote-id-1",
    base_ccy = "BTC",
    quote_ccy = "USDT",
    side = "sell",
    sz = "0.1",
    sz_ccy = "BTC",
    cl_t_req_id = "trade-1",
    tag = "desk1",
    convert_mode = "cash",
    config = cfg
  )
  expect_equal(convert_trade_body$quoteId, "quote-id-1")
  expect_equal(convert_trade_body$baseCcy, "BTC")
  expect_equal(convert_trade_body$szCcy, "BTC")
  expect_equal(convert_trade_body$clTReqId, "trade-1")
})
