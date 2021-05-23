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
      plotOutput("way_plot"),
      textOutput("message_to_user")
      
    )  # Inside the sidebarLayout, add a mainPanel
  )
)

# Define server logic to plot various variables against mpg ----
server <- function(input, output,session) {
  
  get_data <- function(add_url){
    url = paste(base_url,add_url,sep="")
    resp = GET(url)
    if (http_type(resp) != "application/json") {
      stop("API did not return json", call. = FALSE)
    }
    pars <-jsonlite::fromJSON(content(resp, "text"), flatten = TRUE)
    print(pars)
    return(pars)
  }
  
  get_petrol_points<-function(road,car,stations){
    petrol_V <- car$petrol_V
    liters_per_km <- (car$liters_per_100_km)/100
    km_car_go_full <- petrol_V/liters_per_km
    km_car_go <- petrol_V*input$percent_of_petrol_tank/(100*liters_per_km)
    sort_stations <-stations[order(stations$location),]
    print(sort_stations)
    print(km_car_go)
    position = 0
    last_saw <-c(0,0,0)
    names(last_saw)<-c("id","on_road","location")
    last_saw<-as.data.frame(t(last_saw))
    visit.names <- names(last_saw)
    visit <- sapply(visit.names,function(x) NULL)
    i <- 1
    while (position+km_car_go<road[ ,3])
      {
      if (i>length(sort_stations$location) || position + km_car_go < sort_stations[i,3]){
        if (last_saw$location != position){
          position <- last_saw$location
          print(position)
          km_car_go <- km_car_go_full
          print(last_saw$location)
          visit <- mapply(c, visit, last_saw, SIMPLIFY = FALSE)
          i=i-2
        }else{
          return(NULL)
        }
      }else{
        last_saw = sort_stations[i,]
      }
      i=i+1    
    }
    return(visit)
  }
  
  get_stations_from_id<-function(id){
    add_url = paste('roads/',toString(id),'/get_stations/',sep="")
    stations <-get_data(add_url)
    return(stations)
  }

  observeEvent(input$calculate_way,{
    road_id <- match(input$roads,road_data()$name)
    car_id <-match(input$cars,car_data()$name)
    stations <-get_stations_from_id(road_id)
    print(road_id)
    print(car_id)
    car <-car_data()[car_id,1:4]
    road <-road_data()[road_id,1:3]
    # print(str(road))
    loc_on_road <- stations$location
    petrol_points <- get_petrol_points(road,car,stations)
    print(petrol_points)
    if (is.null(petrol_points)){
      output$message_to_user <-renderText({ 
        "You cant reach the end of road"
      })
      output$way_plot<-NULL
    }else if(is.null(petrol_points$location)){
      output$message_to_user <-renderText({ 
        "You dont need any station"
      })

      output$way_plot<-NULL
    
    }else{
    print("petrol")
    print(petrol_points$location)
    way <- unlist(list(0,road$length))
    output$way_plot <-renderPlot({
      ggplot(NULL,mapping = aes(x = location, y = 0)) +
        geom_line(data = as.data.frame(way),mapping = aes(x = way, y = 0),size =0.5)+
        geom_point(data = stations, size = 3)+
        geom_point(data = as.data.frame(petrol_points), size=3,color = "red")
      })
    }
  })
  
  
  
  
  
  base_url <- "https://spb-stu-rshiny-lab.herokuapp.com/api/"
  road_data <-reactive(get_data('roads/'))
  car_data <-reactive(get_data('cars/'))
  output$road_output<-renderText({road_data()$name})
  
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
