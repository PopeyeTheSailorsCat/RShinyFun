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
  
  get_data <- function(add_url){#gettuin data from server API
    url = paste(base_url,add_url,sep="") # concate basic server API adress with specific section
    resp = GET(url)
    if (http_type(resp) != "application/json") {
      stop("API did not return json", call. = FALSE)
    }
    pars <-jsonlite::fromJSON(content(resp, "text"), flatten = TRUE)
    print(pars)
    return(pars)
  }
  
  get_petrol_points<-function(road,car,stations){
    #getting data
    petrol_V <- car$petrol_V
    liters_per_km <- (car$liters_per_100_km)/100
    km_car_go_full <- petrol_V/liters_per_km #with full tank
    km_car_go <- petrol_V*input$percent_of_petrol_tank/(100*liters_per_km) #with start tank
    sort_stations <-stations[order(stations$location),] # to normal algo run
    
    #setting start params
    position = 0
    last_saw <-c(0,0,0)
    names(last_saw)<-c("id","on_road","location")
    last_saw<-as.data.frame(t(last_saw))
    visit.names <- names(last_saw)
    visit <- sapply(visit.names,function(x) NULL)
    i <- 1
    
    # standard greedy algorithm
    while (position+km_car_go<road[ ,3]) #while we dont get to destination
      {# if we cant visit anyone or get to this station
      if (i>length(sort_stations$location) || position + km_car_go < sort_stations[i,3]){
        #if we meet station after last refueling
        # we can refill gas tank
        if (last_saw$location != position){
          position <- last_saw$location #we located at last station
          km_car_go <- km_car_go_full # now we have full tank kms
          visit <- mapply(c, visit, last_saw, SIMPLIFY = FALSE) # add station to visited
          i=i-2 #rechecking with full tank
        }else{
          # we already fill tank here and cant go futher, its the end
          return(NULL) # cant reach the end
        }
      }else{
        #write down last seen station
        last_saw = sort_stations[i,]
      }
      i=i+1 #next station
    }
    return(visit)
  }
  
  get_stations_from_id<-function(id){
    add_url = paste('roads/',toString(id),'/get_stations/',sep="")
    stations <-get_data(add_url)
    return(stations)
  }

  observeEvent(input$calculate_way,{
    #collecting data about trip
    road_id <- match(input$roads,road_data()$name)
    car_id <-match(input$cars,car_data()$name)
    stations <-get_stations_from_id(road_id)
    car <-car_data()[car_id,1:4]
    road <-road_data()[road_id,1:3]
    loc_on_road <- stations$location
    
    petrol_points <- get_petrol_points(road,car,stations) #getting where to stop
    
    #output 
    
    if (is.null(petrol_points)){ #cant reach the end
      output$message_to_user <-renderText({ 
        "You cant reach the end of road"
      })
      output$way_plot<-NULL #clearing
    }else if(is.null(petrol_points$location)){ # can reach without visiting stations
      output$message_to_user <-renderText({ 
        "You dont need any station"
      })

      output$way_plot<-NULL #cleating
    
    }else{
      output$message_to_user <-NULL
    
    #plotting result 
      
    way <- unlist(list(0,road$length))
    output$way_plot <-renderPlot({
      ggplot(NULL,mapping = aes(x = location, y = 0)) +
        geom_line(data = as.data.frame(way),mapping = aes(x = way, y = 0),size =0.5)+
        geom_point(data = stations, size = 3)+
        geom_point(data = as.data.frame(petrol_points), size=3,color = "red")+
        theme(aspect.ratio=1/15,axis.ticks.y=element_blank(),
              axis.title.y=element_blank(),
              axis.text.y=element_blank()) #Long and skinny
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
