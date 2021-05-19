library(shiny)
library(httr)
library(jsonlite)
library(rlist)
library(ggplot2)
# Define UI for miles per gallon app ----
ui <- fluidPage(
  
  # App title ----
  headerPanel("Old town road"),
  
  titlePanel("Choose your car and road so we can do some math"),  # Add a title panel
  sidebarLayout(  # Make the layout a sidebarLayout
    sidebarPanel(
      selectInput("roads","Waiting for data","road_data"),
      selectInput("cars","Waiting for data", "car_data"),
      sliderInput("percent_of_petrol_tank","How much in percent yours tank is fill?"
                  , min =0,max=100,value=50),
      actionButton("calculate_way", "Calculate where to stop"),
     
    ),  # Inside the sidebarLayout, add a sidebarPanel
    mainPanel(
      # write your code here:
      
    )  # Inside the sidebarLayout, add a mainPanel
  )
)

# Define server logic to plot various variables against mpg ----
server <- function(input, output,session) {
  get_data <- function(add_url){
    # url = modify_url(base_url,path = add_url)
    url = paste(base_url,add_url,sep="")
    resp = GET(url)
    if (http_type(resp) != "application/json") {
      stop("API did not return json", call. = FALSE)
    }
    pars <-jsonlite::fromJSON(content(resp, "text"), flatten = TRUE)#simplifyVector = FALSE)
    print(pars)
    return(pars)
  }
  
  get_stations_from_id<-function(id){
    add_url = paste('roads/',toString(id),'/get_stations/',sep="")
    stations <-get_data(add_url)
    return(stations)
  }
  
  
  
  base_url <- "http://127.0.0.1:8000/api/"
  road_data <-reactive(get_data('roads/'))
  car_data <-reactive(get_data('cars/'))
  # station_to_road_data <-reactive((get_data))
  output$road_output<-renderText({road_data()$name})
  # selected_road_id <-
  
  
  observe({
    x <- road_data()$name

    # Can use character(0) to remove all choices
    if (is.null(x))
      x <- character(0)
    
    # Can also set the label and select items
    updateSelectInput(session, "roads",
                      label = "Select Road",
                      choices = x,
                      selected = tail(x, 1)
    )
    
    y <- car_data()$name
    if (is.null(y))
      y <-character(0)
    
    updateSelectInput(session, "cars",
                      label = "Select Car",
                      choices = y,
                      selected = tail(y, 1)
    )
  })
  
}



shinyApp(ui, server)