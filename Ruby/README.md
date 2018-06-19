
Technologies used
-----------------------------------------------------------------------------------------
Ruby 2.5, Sinatra

Technologies used
-----------------------------------------------------------------------------------------
Set the path to Windows if not configured.

SETX PATH "%PATH%;C:\Ruby25-x64\bin"

Needed to install.

gem install sinatra

Script to be executed.

ruby app.rb

Endpoints to category
-----------------------------------------------------------------------------------------
localhost:8080/information/00550000006x1XgAAI

{"name":"Gustavo Tsuda Bellentani","badges":49,"trails":4,"points":33}

localhost:8080/informations

Params: ["00550000006x1XgAAI", "00550000006x1XgAAI"]

[{"name":"Gustavo Tsuda Bellentani","badges":49,"trails":4,"points":33},{"name":"Gustavo Tsuda Bellentani","badges":49,"trails":4,"points":33}]
