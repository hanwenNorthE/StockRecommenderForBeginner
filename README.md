# StockRecommenderForBeginner



## To use AI chat, currently we need LM Studio, download it from LM studio website
   After download LM studio, I suggest start with llama 3.2 1b model. 
   Load the model and start the server.
   


## Start the app!
0. start sql server, change the password in application.properties.

    0.5   Check if the schema exist. Run the create_all_tables.sql if needed.
   

1. Make sure you have maven installed

   mvn clean install


2. Start the server
     mvn spring-boot:run

4. go to localhost: 8080 and see if anything shows up.



# Database check tool
1. There is a tool at the bottom of Login page, you can use it to check your data. Or just check data from workbench.
2. Also you can use it to load all data, the sql file I use is same as milestone 3.
