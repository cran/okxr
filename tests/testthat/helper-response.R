mock_okx_response <- function(data, code = "0", msg = "") {
  body <- jsonlite::toJSON(
    list(code = code, msg = msg, data = data),
    auto_unbox = TRUE,
    null = "null"
  )

  structure(
    list(
      url = "https://www.okx.com/mock",
      status_code = 200L,
      headers = list(`content-type` = "application/json"),
      all_headers = list(list(headers = list(`content-type` = "application/json"))),
      cookies = data.frame(),
      content = charToRaw(body),
      date = Sys.time(),
      times = c()
    ),
    class = "response"
  )
}

mock_http_response <- function(status_code = 200L, body = list(code = "0", msg = "", data = list())) {
  structure(
    list(
      url = "https://www.okx.com/mock",
      status_code = status_code,
      headers = list(`content-type` = "application/json"),
      all_headers = list(list(headers = list(`content-type` = "application/json"))),
      cookies = data.frame(),
      content = charToRaw(jsonlite::toJSON(body, auto_unbox = TRUE, null = "null")),
      date = Sys.time(),
      times = c()
    ),
    class = "response"
  )
}

mock_text_response <- function(text, status_code = 200L) {
  structure(
    list(
      url = "https://www.okx.com/mock",
      status_code = status_code,
      headers = list(`content-type` = "application/json"),
      all_headers = list(list(headers = list(`content-type` = "application/json"))),
      cookies = data.frame(),
      content = charToRaw(text),
      date = Sys.time(),
      times = c()
    ),
    class = "response"
  )
}
