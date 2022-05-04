Weather = function(){
  data = new.env()
  data$source="https://opendata.cwb.gov.tw/dataset/climate/C-B0024-002"
  data$file="https://www.dropbox.com/s/0iou6fudr8ziync/C-B0024-002.json?dl=1"
  data$dowload_data = function(){
    jsonlite::fromJSON(data$file) -> data$rawData
    weatherStation <- list(
      data=jsonlite::fromJSON("https://www.dropbox.com/s/phufne2m2ktnplu/weatherStation.json?dl=1"),
      source="https://e-service.cwb.gov.tw/wdps/obs/state.htm"
    )
    data$weatherStation <- weatherStation
  }
  return(data)
}

