# note --------------------------------------------------------------------

# this script provides the solutions to exercises, or links to them,
# for the workshop (https://github.com/resulumit/scrp_workshop) on 
# web scraping with r, by resul umit

# last updated on: 2022-03-05


# load the packages -------------------------------------------------------

library(rvest)
library(RSelenium)
library(robotstxt)
library(polite)
library(dplyr)


# exercise 1 --------------------------------------------------------------

# get the protocol for the guardian via R
robotstxt(domain = "https://theguardian.com")


# exercise 2 --------------------------------------------------------------

# get list of permissions
robotstxt(domain = "https://theguardian.com")$permissions

# check a path such that it will return FALSE
paths_allowed(domain = "https://theguardian.com", paths = "/sendarticle/")


# exercise 3 --------------------------------------------------------------

# check a website that *i* might wish to scrape for research
robotstxt(domain = "https://www.parliament.uk/")$permissions


# exercise 6 --------------------------------------------------------------

# rhtml file available to download at:
# https://luzpar.netlify.app/exercises/exercise_6.Rhtml


# exercise 7 --------------------------------------------------------------

# rhtml file available to download at:
# https://luzpar.netlify.app/exercises/exercise_7.Rhtml


# exercise 8 --------------------------------------------------------------

# rhtml file available to download at:
# https://luzpar.netlify.app/exercises/exercise_8.Rhtml


# exercise 9 --------------------------------------------------------------

read_html("https://luzpar.netlify.app/states/")


# exercise 10 -------------------------------------------------------------

bow(url = "https://luzpar.netlify.app/states/",
    user_agent = "I am Resul Umit (resulumit@gmail.com)",
    delay = 3) %>%
        scrape()


# exercise 11 -------------------------------------------------------------

bow(url = "https://luzpar.netlify.app/states/") %>%
        scrape() %>% 
        html_element(css = "#top > div.page-body > div:nth-child(2) > div > div.col-lg-12 > div > ul > li:nth-child(1) > a")
            
# exercise 12 -------------------------------------------------------------

bow(url = "https://luzpar.netlify.app/states/") %>%
        scrape() %>% 
        html_elements(css = ".article-style a")


# exercise 13 -------------------------------------------------------------

bow(url = "https://luzpar.netlify.app/states/") %>%
        scrape() %>% 
        html_elements(css = ".article-style li:nth-child(3) a , .article-style li:nth-child(1) a")


# exercise 14 -------------------------------------------------------------

bow(url = "https://luzpar.netlify.app/states/") %>%
        scrape() %>% 
        html_elements(css = ".article-style a") %>% 
        html_text()

# exercise 15 -------------------------------------------------------------

bow(url = "https://luzpar.netlify.app/constituencies/") %>%
        scrape() %>% 
        html_elements(css = "h2 a") %>% 
        html_text()


# exercise 16 -------------------------------------------------------------

bow(url = "https://luzpar.netlify.app/constituencies/") %>%
        scrape() %>% 
        html_elements(css = "h2 a") %>% 
        html_attr(name = "href")


# exercise 17 -------------------------------------------------------------

bow(url = "https://luzpar.netlify.app/constituencies/") %>%
        scrape() %>% 
        html_elements(css = "h2 a") %>% 
        html_attr(name = "href") %>% 
        url_absolute(base = "https://luzpar.netlify.app/constituencies/")


# exercise 18 -------------------------------------------------------------

the_page <- bow(url = "https://luzpar.netlify.app/members/") %>%
        scrape()

df <- data.frame(
        
        "member" = the_page %>%
                html_elements(css = "td:nth-child(1) a") %>% 
                html_text(),
        
        "mp_title" = the_page %>%
                html_elements(css = "td:nth-child(1) a") %>% 
                html_attr("title"),
        
        "link" = the_page %>%
                html_elements(css = "td:nth-child(1) a") %>% 
                html_attr("href") %>%
                url_absolute("https://luzpar.netlify.app/"),
        
        "constituency" = the_page %>%
                html_elements(css = "td+ td a") %>% 
                html_text(),
        
        "constituency_link" = the_page %>%
                html_elements(css = "td+ td a") %>% 
                html_attr("href") %>%
                url_absolute("https://luzpar.netlify.app/"),
        
        "party" = the_page %>%
                html_elements(css = "td~ td+ td") %>% 
                html_text()
        
)


# exercise 19 -------------------------------------------------------------

# note that the code below creates the csv file available at:
# https://luzpar.netlify.app/exercises/static_data.csv

# scrape the /members/ section for links to personal pages

the_links <- bow(url = "https://luzpar.netlify.app/members/") %>%
        scrape() %>%
        html_elements(css = "td:nth-child(1) a") %>% 
        html_attr("href") %>% 
        url_absolute(base = "https://luzpar.netlify.app/")


# scrape each page for various variables

# create an empty list to be filled
temp_list <- list()

# start the for loop: for each page in the list
for (i in 1:length(the_links)) {
        
        # get the page source                
        the_page <- bow(the_links[i]) %>% scrape()
        
        # create a temporary tibble with information from each page        
        temp_tibble <- tibble(
                
                "mp" = the_page %>% html_elements("#top > div.page-body > article > div.article-container.pt-3 > h1") %>% html_text(),
                "party" = the_page %>% html_elements("#party") %>% html_text(),
                "constituency" = the_page %>% html_elements("#party+ a") %>% html_text(),
                "state" = the_page %>% html_elements("#state") %>% html_text(),
                "mp_since" = the_page %>% html_elements("#since") %>% html_text(),
                "attendance" = the_page %>% html_elements("#attendance") %>% html_text(),
                "speeches" = the_page %>% html_elements("#speeches") %>% html_text(),
                "first_committee" = the_page %>% html_elements("#committee-work tr:nth-child(2) td:nth-child(1)") %>% html_text(),
                "second_committee" = the_page %>% html_elements("#committee-work tr~ tr+ tr td:nth-child(1)") %>% html_text(),
                "vote_share" = the_page %>% html_elements("#election-results tr:nth-child(2) td~ td+ td") %>% html_text(),
                "winning_margin" = the_page %>% html_elements("#margin") %>% html_text(),
                "challenger_party" = the_page %>% html_elements("#election-results tr:nth-child(3) td:nth-child(1)") %>% html_text(),
                "challenger_share" = the_page %>% html_elements("#election-results tr:nth-child(3) td~ td+ td") %>% html_text(),
                "email" = the_page %>% html_elements("#email a") %>% html_text(),
                "phone" = the_page %>% html_elements("#phone span") %>% html_text(),
                "website" = the_page %>% html_elements("#website a") %>% html_attr("href"),
                "preference" = the_page %>% html_elements("#contact-preference") %>% html_text()
                
        )
        
        # add data from each iteration to the list        
        temp_list[[i]] <- temp_tibble
        
}

# flatten the list and save the data in a csv file
df_mps <- as_tibble(do.call(rbind, temp_list)) 

# view and (optionally) print it
View(df_mps)
write.csv(df_mps, "static_data.csv", row.names = FALSE)


# exercise 20 -------------------------------------------------------------

driver <- rsDriver(chromever = "98.0.4758.102")


# exercise 21 -------------------------------------------------------------

browser <- driver$client


# exercise 22 -------------------------------------------------------------

browser$navigate(url = "https://luzpar.netlify.app")
browser$navigate(url = "https://www.theguardian.com/")

# exercise 23 -------------------------------------------------------------

browser$goBack()
browser$goForward()


# exercise 24 -------------------------------------------------------------

# see the available methods
# by typing the following into your console (without the number sign):
# browser$

# read the description for two methods
browser$getTitle
browser$screenshot


# exercise 25 -------------------------------------------------------------

# get the title of the current page
browser$getTitle()

# take a screenshot of the page and view it in rstudio
browser$screenshot(display = TRUE, useViewer = TRUE)


# exercise 26 -------------------------------------------------------------

read_html("https://luzpar.netlify.app/members/") 


# exercise 27 -------------------------------------------------------------

# navigate to the page
browser$navigate(url = "https://luzpar.netlify.app/members/")

# get page source
browser$getPageSource()[[1]] 


# exercise 27 -------------------------------------------------------------

# rvest
read_html("https://luzpar.netlify.app/members/") %>% 
        html_elements("td:nth-child(1) a") %>% 
        html_text()


# rselenium and rvest
browser$navigate(url = "https://luzpar.netlify.app/members/")
browser$getPageSource()[[1]] %>% 
        read_html() %>% 
        html_elements("td:nth-child(1) a") %>% 
        html_text()


# exercise 29 -------------------------------------------------------------

# navigate to the website
browser$navigate(url = "https://luzpar.netlify.app/constituencies/")

# find the button
the_button <- browser$findElement(using = "css", value = ".page-link")

# check if you really found it (optional)
the_button$highlightElement()

# click on it
the_button$clickElement()

# exercise 30 -------------------------------------------------------------

# find the button
the_button <- browser$findElement(using = "css", value = ".page-item+ .page-item .page-link")

# check if you really found it (optional)
the_button$highlightElement()

# click on it
the_button$clickElement()


# exercise 31 -------------------------------------------------------------

# navigate to the website
browser$navigate(url = "https://duckduckgo.com/")

# find the bar
the_bar <- browser$findElement(using = "css", value = "#search_form_input_homepage")

# check if you really found it
the_bar$highlightElement()

# click on it
the_bar$clickElement()

# conduct a search
the_bar$sendKeysToElement(list("Luzland", key = "enter"))


# exercise 32 -------------------------------------------------------------

# find the body
the_body <- browser$findElement(using = "css", value = "body")

# scroll down
the_body$sendKeysToElement(list(key = "page_down"))

# scroll up
the_body$sendKeysToElement(list(key = "page_up"))


# exercise 33 -------------------------------------------------------------

# go back
browser$goBack()

# try to conduct a new search
# note that this won't work
the_bar$sendKeysToElement(list("Lucerne", key = "enter"))

# find the bar again, and click on it
the_bar <- browser$findElement(using = "css", value = "#search_form_input_homepage")
the_bar$clickElement()

# conduct a new search now
the_bar$sendKeysToElement(list("Lucerne", key = "enter"))


# exercise 34 -------------------------------------------------------------

# navigate to the desired page and wait a little
browser$navigate("https://luzpar.netlify.app/documents/")
Sys.sleep(4)

# switch to the frame with the app
app_frame <- browser$findElement("css", "iframe")
browser$switchToFrame(Id = app_frame)

# find and open the drop down menu
drop_down <- browser$findElement(using = "css", value = ".bs-placeholder")
drop_down$clickElement()

# choose document type: law
report <- browser$findElement(using = 'css', "[id='bs-select-1-2']")
report$clickElement()

# choose document type: proposal
proposal <- browser$findElement(using = 'css', "[id='bs-select-1-1']")
proposal$clickElement()

# close the drop down menu
drop_down$clickElement()

# find and un-check year: 2019
year_box <- browser$findElement(using = "css", value = "#yrange > div > div:nth-child(3) > label > input[type=checkbox]")
year_box$clickElement()

# get the page source and separate the links
the_links <- browser$getPageSource()[[1]] %>% 
        read_html() %>% 
        html_elements("td a") %>% 
        html_attr("href")

# create an empty list to be filled
temp_list <- list()

# write a loop
for (i in 1:length(the_links)) {
        
        the_page <- bow(url = the_links[i]) %>%
                scrape()
        
        
        # create a temporary tibble with information from each page        
        temp_tibble <- tibble(
                
                "tags" = the_page %>% html_elements(".article-categories") %>% html_text(),
                "credits" = the_page %>% html_elements(".article-header-caption a") %>% html_text()
                
        )
        
        # add data from each iteration to the list        
        temp_list[[i]] <- temp_tibble
        
}

# flatten the list and print it in the console
as_tibble(do.call(rbind, temp_list))

