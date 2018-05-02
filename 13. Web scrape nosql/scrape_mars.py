#importing depepndencies
import time
from splinter import Browser
from bs4 import BeautifulSoup
import pandas as pd
from selenium import webdriver

#browser = Browser('chrome', headless=False)

def scrape():

    browser = Browser('chrome', headless=False)

    #Scrape the NASA Mars News Site
    url = "https://mars.nasa.gov/news/"
    browser.visit(url)
    time.sleep(1)

    html = browser.html
    soup = BeautifulSoup(html, "lxml")

    title = soup.find_all("div", class_="content_title") #("div", class_="content_title").next_element.get_text()
    news_title = title[0].next_element.text.strip()
    paragraph = soup.find_all("div", class_="article_teaser_body")
    news_p = paragraph[0].text.strip()

    print(news_title)
    print(news_p)

    #Scrape JPL's Featured Space Image
    url = "https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars"
    browser.visit(url)
    time.sleep(1)

    html = browser.html
    soup = BeautifulSoup(html, 'lxml')

    image = soup.find('a', class_='button fancybox')
    featured_image_url = "https://www.jpl.nasa.gov" + image["data-fancybox-href"]

    print(featured_image_url)

    #Scrape Mars Weather twitter account
    url = "https://twitter.com/marswxreport?lang=en"
    browser.visit(url)
    time.sleep(1)

    html = browser.html
    soup = BeautifulSoup(html, 'lxml')

    weather = soup.find_all('p', class_='TweetTextSize TweetTextSize--normal js-tweet-text tweet-text')

    for i in weather:
        j = i.text.split()
        if j[0] != "Sol":
            continue
        else:
            mars_weather = i.text
            break

    print(mars_weather)

    #Scrape Mars Facts webpage
    url = "https://space-facts.com/mars/"
    mars_table = pd.read_html(url)

    mars_fact_df = mars_table[0]
    mars_fact_df.columns = ["Characteristic", "Measurement"]

    mars_fact_df.head()

    mars_html = mars_fact_df.to_html(index=None)
    print(mars_html)

    #Scrape USGS Astrogeology site here to obtain high resolution images for each of Mar's hemispheres
    url = "https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars"
    base_url = "https://astrogeology.usgs.gov"
    browser.visit(url)
    time.sleep(1)

    html = browser.html
    soup = BeautifulSoup(html, 'lxml')

    url_list = []
    title_list =[]
    jpg_url_list =[]
    hemisphere_image_urls = []

    results = soup.find('div', class_="collapsible results")
    links = results.find_all('a', class_="itemLink product-item")
    titles= results.find_all('h3')

    for link in links:
        url_list.append(base_url+link["href"])
        
    for title in titles:
        title_list.append(title.text)
        
    for url in url_list:
        print(url)    
        browser.visit(url)
        time.sleep(1)
        
        html = browser.html
        soup = BeautifulSoup(html, 'lxml')
        
        downloads = soup.find('div', class_="downloads")
        jpg = downloads.find_all('a')
        jpg_url = jpg[0]["href"]
        jpg_url_list.append(jpg_url)
        
    # print(url_list)
    # print(title_list)
    # print(jpg_url_list)    

    for i in range(0,len(title_list)):
        hemisphere_image_urls.append({"title": title_list[i], "img_url": jpg_url_list[i]})

    print(hemisphere_image_urls)

    #creating the dictionnary with all the scraped data
    mars_info = {}

    mars_info["news_title"] = news_title
    mars_info["news_p"] = news_p
    mars_info["feat_img"] = featured_image_url
    mars_info["weather"] = mars_weather
    mars_info["facts"] = mars_html
    mars_info["hemispheres"] = hemisphere_image_urls

    print(mars_info)

    return mars_info

