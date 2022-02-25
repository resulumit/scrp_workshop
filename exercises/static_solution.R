# load the packages -------------------------------------------------------

library(rvest)
library(polite)
library(dplyr)


# scrape the /members/ section for links to personal pages ----------------

the_links <- bow(url = "https://luzpar.netlify.app/members/") %>%
        scrape() %>%
        html_elements(css = "td:nth-child(1) a") %>% 
        html_attr("href") %>% 
        url_absolute(base = "https://luzpar.netlify.app/")


# scrape each page for various variables ----------------------------------

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


# flatten the list and save the data in a csv file ------------------------

as_tibble(do.call(rbind, temp_list)) %>% 
        write.csv("static_data.csv", row.names = FALSE)