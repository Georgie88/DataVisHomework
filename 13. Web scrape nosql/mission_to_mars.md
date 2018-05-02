

```python
#importing depepndencies
import time
from splinter import Browser
from bs4 import BeautifulSoup
import pandas as pd
from selenium import webdriver
```


```python
#open the browser in order to navigate the webpage with splinter
browser = Browser('chrome', headless=False)
```

# NASA Mars News


```python
#setting the url and visiting it
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
```

    Vice President Pence Visits JPL, Previews NASA’s Next Mars Mission Launch
    A week before NASA's next Mars launch, Vice President Mike Pence toured the birthplace of the InSight Mars Lander and numerous other past, present and future space missions.
    

# JPL Mars Space Images - Featured Image


```python
#setting the url and visiting it
url = "https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars"
browser.visit(url)
time.sleep(1)

html = browser.html
soup = BeautifulSoup(html, 'lxml')

image = soup.find('a', class_='button fancybox')
featured_image_url = "https://www.jpl.nasa.gov" + image["data-fancybox-href"]

print(featured_image_url)
```

    https://www.jpl.nasa.gov/spaceimages/images/mediumsize/PIA16225_ip.jpg
    

# Mars Weather


```python
#setting the twitter account url and visiting it
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
```

    Sol 2036 (April 29, 2018), Sunny, high -5C/23F, low -72C/-97F, pressure at 7.28 hPa, daylight 05:24-17:20
    

# Mars Facts


```python
url = "https://space-facts.com/mars/"
mars_table = pd.read_html(url)

mars_fact_df = mars_table[0]
mars_fact_df.columns = ["Characteristic", "Measurement"]

mars_fact_df.head()

mars_html = mars_fact_df.to_html(index=None)
print(mars_html)
```

    <table border="1" class="dataframe">
      <thead>
        <tr style="text-align: right;">
          <th>Characteristic</th>
          <th>Measurement</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Equatorial Diameter:</td>
          <td>6,792 km</td>
        </tr>
        <tr>
          <td>Polar Diameter:</td>
          <td>6,752 km</td>
        </tr>
        <tr>
          <td>Mass:</td>
          <td>6.42 x 10^23 kg (10.7% Earth)</td>
        </tr>
        <tr>
          <td>Moons:</td>
          <td>2 (Phobos &amp; Deimos)</td>
        </tr>
        <tr>
          <td>Orbit Distance:</td>
          <td>227,943,824 km (1.52 AU)</td>
        </tr>
        <tr>
          <td>Orbit Period:</td>
          <td>687 days (1.9 years)</td>
        </tr>
        <tr>
          <td>Surface Temperature:</td>
          <td>-153 to 20 °C</td>
        </tr>
        <tr>
          <td>First Record:</td>
          <td>2nd millennium BC</td>
        </tr>
        <tr>
          <td>Recorded By:</td>
          <td>Egyptian astronomers</td>
        </tr>
      </tbody>
    </table>
    

# Mars Hemisperes


```python
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
```

    https://astrogeology.usgs.gov/search/map/Mars/Viking/cerberus_enhanced
    https://astrogeology.usgs.gov/search/map/Mars/Viking/cerberus_enhanced
    https://astrogeology.usgs.gov/search/map/Mars/Viking/schiaparelli_enhanced
    https://astrogeology.usgs.gov/search/map/Mars/Viking/schiaparelli_enhanced
    https://astrogeology.usgs.gov/search/map/Mars/Viking/syrtis_major_enhanced
    https://astrogeology.usgs.gov/search/map/Mars/Viking/syrtis_major_enhanced
    https://astrogeology.usgs.gov/search/map/Mars/Viking/valles_marineris_enhanced
    https://astrogeology.usgs.gov/search/map/Mars/Viking/valles_marineris_enhanced
    [{'title': 'Cerberus Hemisphere Enhanced', 'img_url': 'http://astropedia.astrogeology.usgs.gov/download/Mars/Viking/cerberus_enhanced.tif/full.jpg'}, {'title': 'Schiaparelli Hemisphere Enhanced', 'img_url': 'http://astropedia.astrogeology.usgs.gov/download/Mars/Viking/cerberus_enhanced.tif/full.jpg'}, {'title': 'Syrtis Major Hemisphere Enhanced', 'img_url': 'http://astropedia.astrogeology.usgs.gov/download/Mars/Viking/schiaparelli_enhanced.tif/full.jpg'}, {'title': 'Valles Marineris Hemisphere Enhanced', 'img_url': 'http://astropedia.astrogeology.usgs.gov/download/Mars/Viking/schiaparelli_enhanced.tif/full.jpg'}]
    


```python
#creating the dictionnary with all the scraped data
mars_info = {}

mars_info["news_title"] = news_title
mars_info["news_p"] = news_p
mars_info["feat_img"] = featured_image_url
mars_info["weather"] = mars_weather
mars_info["facts"] = mars_html
mars_info["hemispheres"] = hemisphere_image_urls

print(mars_info)
```

    {'news_title': 'Vice President Pence Visits JPL, Previews NASA’s Next Mars Mission Launch', 'news_p': "A week before NASA's next Mars launch, Vice President Mike Pence toured the birthplace of the InSight Mars Lander and numerous other past, present and future space missions.", 'feat_img': 'https://www.jpl.nasa.gov/spaceimages/images/mediumsize/PIA16225_ip.jpg', 'weather': 'Sol 2036 (April 29, 2018), Sunny, high -5C/23F, low -72C/-97F, pressure at 7.28 hPa, daylight 05:24-17:20', 'facts': '<table border="1" class="dataframe">\n  <thead>\n    <tr style="text-align: right;">\n      <th>Characteristic</th>\n      <th>Measurement</th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>Equatorial Diameter:</td>\n      <td>6,792 km</td>\n    </tr>\n    <tr>\n      <td>Polar Diameter:</td>\n      <td>6,752 km</td>\n    </tr>\n    <tr>\n      <td>Mass:</td>\n      <td>6.42 x 10^23 kg (10.7% Earth)</td>\n    </tr>\n    <tr>\n      <td>Moons:</td>\n      <td>2 (Phobos &amp; Deimos)</td>\n    </tr>\n    <tr>\n      <td>Orbit Distance:</td>\n      <td>227,943,824 km (1.52 AU)</td>\n    </tr>\n    <tr>\n      <td>Orbit Period:</td>\n      <td>687 days (1.9 years)</td>\n    </tr>\n    <tr>\n      <td>Surface Temperature:</td>\n      <td>-153 to 20 °C</td>\n    </tr>\n    <tr>\n      <td>First Record:</td>\n      <td>2nd millennium BC</td>\n    </tr>\n    <tr>\n      <td>Recorded By:</td>\n      <td>Egyptian astronomers</td>\n    </tr>\n  </tbody>\n</table>', 'hemispheres': [{'title': 'Cerberus Hemisphere Enhanced', 'img_url': 'http://astropedia.astrogeology.usgs.gov/download/Mars/Viking/cerberus_enhanced.tif/full.jpg'}, {'title': 'Schiaparelli Hemisphere Enhanced', 'img_url': 'http://astropedia.astrogeology.usgs.gov/download/Mars/Viking/cerberus_enhanced.tif/full.jpg'}, {'title': 'Syrtis Major Hemisphere Enhanced', 'img_url': 'http://astropedia.astrogeology.usgs.gov/download/Mars/Viking/schiaparelli_enhanced.tif/full.jpg'}, {'title': 'Valles Marineris Hemisphere Enhanced', 'img_url': 'http://astropedia.astrogeology.usgs.gov/download/Mars/Viking/schiaparelli_enhanced.tif/full.jpg'}]}
    
