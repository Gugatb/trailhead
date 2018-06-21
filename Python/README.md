
Technologies used
-----------------------------------------------------------------------------------------
Python 3, Flask, MongoDB 3.6

Settings and notes
-----------------------------------------------------------------------------------------
Set the path to Windows if not configured.

SETX PATH "%PATH%;C:\Python\Python36\Scripts"  
SETX PATH "%PATH%;C:\Ruby25-x64\bin"

Needed to install.

1. py -m pip install --user virtualenv
2. pip install flask flask-jsonpify flask-sqlalchemy flask-restful
3. pip install pymongo

Script to be executed.

py app.py

Endpoints to category
-----------------------------------------------------------------------------------------
localhost:8080/information/00550000006x1XgAAI

{"name":"Gustavo Tsuda Bellentani","badges":49,"trails":4,"points":33}

localhost:8080/informations

Params: ["00550000006x1XgAAI", "00550000006x1XgAAI"]

[{"name":"Gustavo Tsuda Bellentani","badges":49,"trails":4,"points":33},{"name":"Gustavo Tsuda Bellentani","badges":49,"trails":4,"points":33}]
