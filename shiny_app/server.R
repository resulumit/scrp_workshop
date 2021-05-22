# server.R

# load the libraries
library(shiny)
library(lazyeval)
library(DT)
library(dplyr)
library(stringr)


# start the function
function(input, output) {
  
  # start the table
  output$table <- renderDataTable(
    
    # the table
    read.csv("documents.csv") %>% 
      
      filter(doc_type %in% input$doctype) %>% 
      filter(if (length(input$sbox) > 0) str_detect(str_to_lower(doc_title), str_to_lower(input$sbox))) %>%
      filter(doc_year %in% input$yrange) %>%
      
      # select variables
      select("Publication Year" = doc_year, "Document Title" = doc_tag),
      
      # Options: DT
      options = list(pageLength = 20, dom = "t",
                     language = list(zeroRecords = "")),
      
      # Options: datatable
      rownames = FALSE,
      escape = FALSE
    
    # end the table
    )

# end the function
}
