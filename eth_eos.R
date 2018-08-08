library(readr)
library(xts)


library(ggplot2)
library(MyPlot)

ggplot(eos.xts$'price(USD)')


loadCoinData = function(coin = "eos") {
  suppressWarnings({
    df = read_csv(paste0("https://coinmetrics.io/data/", coin, ".csv"),
              col_types = cols(date = col_date(), .default = col_number())
              )
  })

  df.xts = as.xts(df[, -1], order.by = as.Date(df$date))["2013-04-28::"]
  df.xts
}

eos.info = loadCoinData("eos")
eth.info = loadCoinData("eth")
btc.info = loadCoinData("btc")


aDate = "2018-04::"

mplot(
      btc.info$'price(USD)' / as.vector(first(btc.info$'price(USD)'[aDate])),
      eth.info$'price(USD)' / as.vector(first(eth.info$'price(USD)'[aDate])),
      eos.info$'price(USD)' / as.vector(first(eos.info$'price(USD)'[aDate])),
      period = "2017-10::",
      titles = c("btc", "eth", "eos")
      )








