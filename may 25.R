source("https://raw.githubusercontent.com/tpemartin/110-2-R/main/support/weather.R", encoding="UTF-8") # R 4.2+
source("https://raw.githubusercontent.com/tpemartin/110-2-R/main/traffic_accident.R", encoding="UTF-8")

weather = Weather()
weather$dowload_data()



whichStation = 5
# whichDateTimeRow = 6090
# whichDateRow = 254

climateDataList <- vector("list", nrow(traffic))
# for(.x in 1:nrow(traffic)){
  .x = 1
  traffic[.x, ] -> trafficX
  
  # trafficX$經度 trafficX$緯度 ==> whichStation
  # trafficX ==> whichDateTimeRow
  whichDateTimeRow = {
    trafficX$發生時間 -> trafficTime # (1)
    weather[["rawData"]][["cwbdata"]][["resources"]][["resource"]][["data"]][["surfaceObs"]][["location"]][["stationObsTimes"]][["stationObsTime"]][[whichStation]]$dataTime -> availableTimes # (2)
    
    trafficTime |> class()
    availableTimes |> lubridate::ymd_hms() -> availableTimes
    availableTimes |> class()
    
    # --Approach 1---
    ## vectorizing language
    allDistance = abs(availableTimes - trafficTime)
    which.min(allDistance)
    
    # --Approach 2---
    # smallestYdistance <- 10**5 
    # whichDateTimeRow <- 0
    # for(.y in seq_along(availableTimes)){
    #   timeYdistance <- abs(availableTimes[[.y]] - trafficTime)
    #   if(timeYdistance < smallestYdistance){
    #     smallestYdistance <- timeYdistance
    #     whichDateTimeRow <- .y
    #   }
    # }
    # 
    # whichDateTimeRow
  }
  # trafficX ==> whichDateRow
  whichDateRow <- {
    
    
  }
  
  weather[["rawData"]][["cwbdata"]][["resources"]][["resource"]][["data"]][["surfaceObs"]][["location"]][["station"]][whichStation,]
  
  climatedata1 <- list()
  #從中發現竹子湖是第五筆資料 觀察其他氣象資料皆有對稱性 
  weather[["rawData"]][["cwbdata"]][["resources"]][["resource"]][["data"]][["surfaceObs"]][["location"]][["stationObsTimes"]][["stationObsTime"]][[whichStation]][whichDateTimeRow,1]->climatedata1$date
  weather[["rawData"]][["cwbdata"]][["resources"]][["resource"]][["data"]][["surfaceObs"]][["location"]][["stationObsTimes"]][["stationObsTime"]][[whichStation]][whichDateTimeRow,2]->climatedata1$stationPressure
  weather[["rawData"]][["cwbdata"]][["resources"]][["resource"]][["data"]][["surfaceObs"]][["location"]][["stationObsStatistics"]][["temperature"]][["daily"]][[whichStation]][whichDateRow,2:4]->climatedata1$temperature
  
  climateDataList[[.x]] <- climatedata1
# }



# For each accident -------------------------------------------------------

traffic |> head()












