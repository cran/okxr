test_that(".okx_build_query drops null/empty values and URL-encodes", {
  expect_equal(okxr:::.okx_build_query(), "")
  expect_equal(okxr:::.okx_build_query(instId = "BTC-USDT"), "?instId=BTC-USDT")
  expect_equal(
    okxr:::.okx_build_query(instId = "BTC-USDT", empty = "", missing = NULL),
    "?instId=BTC-USDT"
  )
  expect_equal(
    okxr:::.okx_build_query(instId = "BTC USDT", ordType = "post_only,fok"),
    "?instId=BTC%20USDT&ordType=post_only%2Cfok"
  )
  expect_error(okxr:::.okx_build_query(instId = c("BTC-USDT", "ETH-USDT")), "length 1")
})

test_that(".okx_validate_config validates required credentials", {
  cfg <- list(api_key = "key", secret_key = "secret", passphrase = "pass")
  expect_invisible(okxr:::.okx_validate_config(cfg))
  expect_error(okxr:::.okx_validate_config("bad"), "`config` must be a list")
  expect_error(
    okxr:::.okx_validate_config(list(api_key = "key")),
    "secret_key, passphrase"
  )
})

test_that(".okx_datetime_to_ms parses expected timestamp format", {
  expect_equal(
    okxr:::.okx_datetime_to_ms("1970-01-01 00:00:01", tz = "UTC"),
    1000L
  )
  expect_null(okxr:::.okx_datetime_to_ms(NULL))
  expect_error(okxr:::.okx_datetime_to_ms("bad", tz = "UTC"), "parseable")
})

test_that(".okx_extract_result respects raw_data flag", {
  parsed <- list(data_raw = list(a = 1), data_dt = data.frame(a = 1))
  expect_equal(okxr:::.okx_extract_result(parsed, raw_data = TRUE), parsed$data_raw)
  expect_equal(okxr:::.okx_extract_result(parsed, raw_data = FALSE), parsed$data_dt)
  expect_null(okxr:::.okx_extract_result(NULL))
})

test_that(".okx_request_timeout validates timeout sources", {
  timeout <- okxr:::.okx_request_timeout(list(timeout = 3))
  expect_s3_class(timeout, "request")
  expect_error(okxr:::.okx_request_timeout(list(timeout = 0)), "positive")
  expect_error(okxr:::.okx_request_timeout(list(timeout = "bad")), "positive")
})

test_that(".build_request can build unsigned public requests without config", {
  req <- okxr:::.build_request(
    httr_method = "GET",
    base_url = "https://www.okx.com",
    api_path = "/api/v5/public/time",
    query_string = "",
    auth = FALSE
  )

  expect_equal(req$url, "https://www.okx.com/api/v5/public/time")
  expect_null(req$headers)
})

test_that(".execute_get_action handles unsigned success, HTTP error, and request error", {
  called <- new.env(parent = emptyenv())
  called$url <- NULL
  called$has_headers <- FALSE

  testthat::local_mocked_bindings(
    GET = function(url, ...) {
      called$url <- url
      called$has_headers <- length(list(...)) > 1L
      mock_http_response()
    },
    .package = "httr"
  )

  res <- okxr:::.execute_get_action("/api/v5/public/time", "", auth = FALSE)
  expect_s3_class(res, "response")
  expect_equal(called$url, "https://www.okx.com/api/v5/public/time")
  expect_false(called$has_headers)

  testthat::local_mocked_bindings(
    GET = function(url, ...) mock_http_response(status_code = 500L),
    .package = "httr"
  )
  expect_warning(
    expect_null(okxr:::.execute_get_action("/api/v5/public/time", "", auth = FALSE)),
    "Request failed: 500"
  )

  testthat::local_mocked_bindings(
    GET = function(url, ...) stop("timeout"),
    .package = "httr"
  )
  expect_warning(
    expect_null(okxr:::.execute_get_action("/api/v5/public/time", "", auth = FALSE)),
    "timeout"
  )
})

test_that(".execute_get_action validates credentials for private requests before HTTP", {
  testthat::local_mocked_bindings(
    GET = function(url, ...) stop("should not call HTTP"),
    .package = "httr"
  )

  expect_error(
    okxr:::.execute_get_action("/api/v5/account/balance", "", config = list(), auth = TRUE),
    "Missing required config field"
  )
})

test_that(".execute_post_action handles success, HTTP error, and request error", {
  cfg <- list(api_key = "key", secret_key = "secret", passphrase = "pass")
  called <- new.env(parent = emptyenv())
  called$body <- NULL
  called$encode <- NULL

  testthat::local_mocked_bindings(
    POST = function(url, ..., body = NULL, encode = NULL) {
      called$body <- body
      called$encode <- encode
      mock_http_response()
    },
    .package = "httr"
  )

  res <- okxr:::.execute_post_action("/api/v5/trade/order", list(instId = "BTC-USDT"), cfg)
  expect_s3_class(res, "response")
  expect_match(called$body, "BTC-USDT")
  expect_equal(called$encode, "raw")

  testthat::local_mocked_bindings(
    POST = function(url, ..., body = NULL, encode = NULL) mock_http_response(status_code = 429L),
    .package = "httr"
  )
  expect_warning(
    expect_null(okxr:::.execute_post_action("/api/v5/trade/order", list(), cfg)),
    "Request failed: 429"
  )

  testthat::local_mocked_bindings(
    POST = function(url, ..., body = NULL, encode = NULL) stop("connection failed"),
    .package = "httr"
  )
  expect_warning(
    expect_null(okxr:::.execute_post_action("/api/v5/trade/order", list(), cfg)),
    "connection failed"
  )
})
