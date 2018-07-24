
Technologies used
-----------------------------------------------------------------------------------------
Ruby 2.5, MongoDB 3.6, Sinatra

Technologies used
-----------------------------------------------------------------------------------------
Set the path to Windows if not configured.

SETX PATH "%PATH%;C:\MongoDB\Server\3.6\bin"  
SETX PATH "%PATH%;C:\Ruby25-x64\bin"

Needed to install.

1. gem install mongo
2. gem install neatjson
3. gem install sinatra

Database to be executed.

mongod --port 27017

Script to be executed.

ruby app.rb

Endpoints to category
-----------------------------------------------------------------------------------------
localhost:8080/information/00550000006x1XgAAI

{"name":"Gustavo Tsuda Bellentani","badges":49,"trails":4,"points":33.325}

localhost:8080/informations

Params: ["00550000006x1XgAAI", "00550000006x1XgAAI"]

[{"name":"Gustavo Tsuda Bellentani","badges":49,"trails":4,"points":33.325},{"name":"Gustavo Tsuda Bellentani","badges":49,"trails":4,"points":33.325}]
