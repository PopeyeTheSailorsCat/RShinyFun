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
The end user will only be interested in the app where the file app.R is located. R which is supposed to be used by the user. 
Also in this repository there is an MIT license and files related to the launch of the heroku server
## Running Django server locally
To start Django on you local machine you will need python at first.
Install Django running
```commandline
    > pip install Django
```
Make sure what DEBUG in 'server/setting.py' is True.  
After that start server from a console in the project root.
```commandline
    > python manage.py runserver
```
Access server at '127.0.0.1'.
### Setting database at local
 To run server properly, you need to create a database and migrate to her.  
To achieve this you need to create db you want, and set it in DATABASES, located at 'server/settings.py'.
After this, you need to migrate your db to our models:
```commandline
    > python manage.py migrate
```
Now your db and server ready to run.


## Deploy Django server on heroku
Repository already have all needed for running django application on heroku. All you need is to create heroku repo for your project and push this repo there.  
Before pushing make sure DEBUG in 'server/setting.py' is False.
Also add your new server address to ALLOWED_HOSTS in 'server/setting.py'  
In our code we are using Heroku-Postgre('https://www.heroku.com/postgres'), choose a plan you will use. If you want to use another db, check 'Setting databases at local'.  
After pushing run migrate your db on heroku:
```commandline
    > heroku python manage.py migrate
```
## Using application
You can easily access our application on 'https://popeythesailor.shinyapps.io/app_client/'.

## Deploy application on server
We recommend using 'www.shinyapps.io', they have free hosting for small projects and user guide how to start.
## Running application locally
To launch app.R you need to install R(https://www.r-project.org/). After installation, make sure R is in your Path.  
If you are going to use your server write you address to app/config.json.  
After that you need to install shiny package, write in console
```commandline
    > R -e "install.packages("shiny")"
```
 When start a console in project root and write.
```commandline
   > R -e "shiny::runApp('app/app.R')"
```
After what R print adress, and you can open application in your browser.
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
