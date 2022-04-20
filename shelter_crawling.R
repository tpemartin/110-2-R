econWeb::webdriverChromeSession() -> session
session$start_session()
session$go("https://act-adopt.ahiqo.ntpc.gov.tw/")

list_pages = vector("list", 149)
for(.i in 1:149){
  session$executeScript(
    glue::glue("showList({.i});")
  )
  el=session$executeScript(
    htmltools::includeHTML("js/shelter.js")
  )
  el |>
    rvest::read_html() -> .html
  .html |>
    rvest::html_elements(css="div.box") ->
    boxes
  list_details = vector("list", length(boxes))
  for(.x in seq_along(boxes)){
    boxes[[.x]] |>
      rvest::html_element("a") |>
      rvest::html_attr("href") -> href
    
    rvest::read_html(
      paste0(
        "https://act-adopt.ahiqo.ntpc.gov.tw/", href
      )
    ) -> petX
    petX |>
      rvest::html_elements(css=".text-box > p") |>
      rvest::html_text() -> description
    petX |>
      rvest::html_element(css="div.img > img") |>
      rvest::html_attr("src") -> photo
    
    list_details[[.x]] <- list(
      description=description,
      photo=photo
    )
  }
  list_pages[[.i]] <- list_details
}

list_pages |> jsonlite::toJSON() |>
  xfun::write_utf8("animal_shelter.json")

list0 <- jsonlite::fromJSON("animal_shelter.json", simplifyDataFrame = F)

session$delete()
session$kill_chrome()
