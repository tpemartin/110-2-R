download_traffic_data <- function(){
  json <- jsonlite::fromJSON("https://data.moi.gov.tw/MoiOD/System/DownloadFile.aspx?DATA=01987403-8634-4E3F-B626-E7777014AE43")
  # json$result$records |> View()
  
  traffic <- json$result$records
  traffic$發生時間 |>
    stringr::str_split("年") |> #View()
    purrr::map_chr(
      ~{
        as.integer(.x[[1]])+1911 -> .year
        paste0(.year,"-",.x[[2]])
      }
    ) -> .dateTime
  lubridate::ymd_hms(.dateTime, tz="Asia/Taipei") ->
    traffic$發生時間
  
  purrr::map(
    list(
      lubridate::hour,
      lubridate::minute
    ),
    ~{
      .x(traffic$發生時間)
    }
  ) |>
    setNames(c("hour", "minute"))-> list_hm
  traffic$hour <- list_hm$hour
  traffic$minute <- list_hm$minute
  
  traffic$發生地點 |>
    stringr::str_extract(
      "^[^市]{2}市.{1,3}[區鄉鎮](?!區)"
    ) -> .city1
  traffic$發生地點 |>
    stringr::str_extract(
      "^[^縣]{2}[縣].{1,3}[區鄉鎮市](?!區)"
    ) -> .city2
  dplyr::if_else(
    is.na(.city1), .city2, .city1
  ) -> .city_town
  traffic$縣市 = stringr::str_sub(.city_town, 1,3)
  traffic$區鄉鎮市 = stringr::str_sub(.city_town, 4)
  
  stringr::str_glue("https://www.google.com/maps/search/?api=1&query={traffic$緯度},{traffic$經度}") ->
    traffic$googleMap
  
  traffic -> .GlobalEnv$traffic
  message("Data frame traffic is created in the global environment.")
}
