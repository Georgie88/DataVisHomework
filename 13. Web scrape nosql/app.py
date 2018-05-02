<<<<<<< HEAD
# import dependencies
import time
from splinter import Browser
from bs4 import BeautifulSoup
import pandas as pd
from selenium import webdriver
from flask import Flask, render_template, jsonify, redirect
from flask_pymongo import pymongo
import scrape_mars

app = Flask(__name__)

conn = 'mongodb://localhost:27017'
client = pymongo.MongoClient(conn)
db = client.mars_info
collection = db.mars_scrape

# basic app route
@app.route("/")
def index():
    mars_info = db.collection.find_one()
    return render_template("index.html", mars_info=mars_info)

# app route for the webscraper
@app.route("/scrape")
def scrape():
    # create the mongodb and fill it with the webscraper results
    mars_info = db.collection
    mars_data = scrape_mars.scrape()
    #print(mars_data)
    mars_info.update(
        {},
        mars_data,
        upsert=True
    )
    return redirect("http://localhost:5000/", code=302)


if __name__ == "__main__":
=======
# import dependencies
import time
from splinter import Browser
from bs4 import BeautifulSoup
import pandas as pd
from selenium import webdriver
from flask import Flask, render_template, jsonify, redirect
from flask_pymongo import pymongo
import scrape_mars

app = Flask(__name__)

conn = 'mongodb://localhost:27017'
client = pymongo.MongoClient(conn)
db = client.mars_info
collection = db.mars_scrape

# basic app route
@app.route("/")
def index():
    mars_info = db.collection.find_one()
    return render_template("index.html", mars_info=mars_info)

# app route for the webscraper
@app.route("/scrape")
def scrape():
    # create the mongodb and fill it with the webscraper results
    mars_info = db.collection
    mars_data = scrape_mars.scrape()
    #print(mars_data)
    mars_info.update(
        {},
        mars_data,
        upsert=True
    )
    return redirect("http://localhost:5000/", code=302)


if __name__ == "__main__":
>>>>>>> 4f995c4dd8fced7d22bc41f1fa13bf27dad8fde8
    app.run(debug=True)