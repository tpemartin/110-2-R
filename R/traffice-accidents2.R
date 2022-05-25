source("https://raw.githubusercontent.com/tpemartin/110-2-R/main/R/traffic-accident-support.R", encoding = "UTF-8")

download_traffic_data()

within(
  traffic,
  {
    hour <- factor(hour)
    縣市 <- factor(縣市)
  }
) -> traffic

traffic |> 
  split(
    traffic$hour
  ) -> split_traffic

dataFrame_byHour_byCounty <- data.frame(
  時段=character(0),
  時段車禍次數=integer(0),
  時段車禍縣市數目=integer(0),
  車禍次數=integer(0),
  縣市=character(0),
  時段名次=character(0)
)
for(.x in seq_along(split_traffic)){
  split_traffic[[.x]]$縣市 |>
    table() |> 
    sort(decreasing = T) -> accidents_hourX
  
  data.frame(
    時段=names(split_traffic[.x]),
    時段車禍次數=sum(accidents_hourX),
    時段車禍縣市數目=length(accidents_hourX),
    車禍次數=as.integer(accidents_hourX),
    縣市=names(accidents_hourX),
    時段名次=length(accidents_hourX)+1-rank(accidents_hourX, ties.method = "first") 
  ) -> dataFrameOfHourX
  
  dataFrame_byHour_byCounty =
    rbind(
      dataFrame_byHour_byCounty,
      dataFrameOfHourX
    )
}
