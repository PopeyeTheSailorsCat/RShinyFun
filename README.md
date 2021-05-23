The third laboratory work in a cycle on the subject of User Interface Development
# RShinyFun
This is a student project in which we create an R Shiny application, and a Django server to work with this application. Interaction is carried out via the REST API. The server is deployed on Heroku.
The interaction between this repository and the heroku repository is carried out via Jenkins with the push project build.
Programming language is Python 3.7

## Repository content
In this repository, we have three main folders:  
  * Shiny Application folder(app)  
  * Django server folder(server)
* django application folder (old_town_road).    
  
In the normal case, the R and Django folders should be separated, but for the sake of clarity of the project, they are in the same place.   
The end user will only be interested in the app where the file shiny.R is located. R which is supposed to be used by the user. 
Also in this repository there is an MIT license and files related to the launch of the heroku server

## Running application  
To launch shiny.R you need to install R(https://www.r-project.org/).
Also, we recommend installing RStudio. In this guide we  think you using Rstudio. After all installation open folder app as RStudio project. When write this in you console
```commandline
   > library(shiny)
   > runApp("shiny.R")
```
After that, a window will open in which you will see.  
![PIC_1](https://github.com/Brightest-Sunshine/pictures-for-README-files/blob/master/pics/RShiny1.jpg)

(if you see the message 'waiting for information', then wait a bit, the server processes your request)

Select the road you want to drive, and the car you are driving from the list.
Use the slider to indicate how much gasoline you have in the tank(as a percentage).
Then click calculate

![PIC_2](https://github.com/Brightest-Sunshine/pictures-for-README-files/blob/master/pics/RShiny2.jpg)

At the end, you can see the stations (marked in red) where you need to stop for refueling.

![PIC_3](https://github.com/Brightest-Sunshine/pictures-for-README-files/blob/master/pics/RShiny3.jpg)

# Development team
1. Mamaeva Anastasia

     work email: mamaeva.as@edu.spbstu.ru
    
2. Vedenichev Dmitry

     work email: vedenichev.da@edu.spbstu.ru 
