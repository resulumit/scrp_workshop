# note --------------------------------------------------------------------

# this script provides the solutions to exercises, or links to them,
# for the workshop (https://github.com/resulumit/scrp_workshop) on 
# web scraping with r, by resul umit

# last updated on: 25.02.2022


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

# check a website that *i* might wish to scrape for reseach
robotstxt(domain = "https://www.parliament.uk/")$permissions


# exercise 6 --------------------------------------------------------------

# rhtml file available to download at:
# https://luzpar.netlify.app/exercises/exercise_6.Rhtml


# exercise 7 --------------------------------------------------------------

# rhtml file available to download at:
# https://luzpar.netlify.app/exercises/exercise_7.Rhtml


# exercise 9 on slide 99 --------------------------------------------------

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


# exercise 10 on slide 110 ------------------------------------------------
# note: the code below creates the csv file available at:
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
                "preference" = the_page %>% html_elements("#contact-preference") %>% html_text(),
                
        )
        
        # add data from each iteration to the list        
        temp_list[[i]] <- temp_tibble
        
}

# flatten the list and save the data in a csv file

as_tibble(do.call(rbind, temp_list)) %>% 
        write.csv("static_data.csv", row.names = FALSE)


# selenium additional elements --------------------------------------------
# these are additional to the stuff on the slides

# try searching -----------------------------------------------------------

search_box <- browser$findElement(using = "css", value = "#sbox")
search_box$clickElement()
search_box$sendKeysToElement(list("Luzland", key = "enter"))

search_box <- browser$findElement(using = "css", value = "body > div.container-fluid > div > div.col-sm-4 > form")
search_box$clickElement()


# try years ---------------------------------------------------------------

year_box <- browser$findElement(using = "css", value = "#yrange > div > div:nth-child(1) > label > input[type=checkbox]")
year_box$clickElement()

year_box <- browser$findElement(using = "css", value = "#yrange > div > div:nth-child(2) > label > input[type=checkbox]")
year_box$clickElement()
