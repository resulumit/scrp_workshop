# ui.R

# load libraries
library(shiny)
library(shinyWidgets)
library(shinyBS)
library(DT)

# Start: page ----
fluidPage(

# Style the font    
  style = "font-size: 100%; width: 100%", 
  
# App title ----
  titlePanel(""),

# Help text ----
  helpText(""),


# Sidebar layout with input and output definitions ----
  sidebarLayout(

# Sidebar panel for inputs ----
  sidebarPanel(
    
# Input: Document Type ----
pickerInput(inputId = "doctype", label = "Document Type",
                choices = c("Law", "Proposal", "Report", "Uncategorised"),
                selected = "",
                options = list(size = 4, `selected-text-format` = "count"),
                multiple = TRUE),
    
# Input: Search ----
textInput(inputId = "sbox", label = "Title", placeholder = "Enter a keyword"),



# Input: Date ----
checkboxGroupInput(inputId = "yrange", label = "Publication Year", choices = c(2021, 2020, 2019),
             selected = c(2021, 2020, 2019))


# End: sidebarPanel ----
),

# Start: MainPanel ----
mainPanel(
    tabPanel("Table", DT::dataTableOutput(outputId = "table")))

# End: sidebarLayout ----
)

# End: fluidpage ----
)
