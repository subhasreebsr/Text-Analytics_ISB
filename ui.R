library(shiny)
ui <- shinyUI(
  fluidPage(
    
    titlePanel("Title Panel"),
    
    sidebarLayout(
      
      sidebarPanel(
        helpText('Side Bar'),
        fileInput("textfile1",h3("Standard Englisth Model to be used")),
        fileInput("textfile2",h3("Please upload text file to be analysed")),
        checkboxGroupInput("checkGroup", 
                           h3("Checkbox group"), 
                           choices  = list("Adjectives (Adj)" = 1, 
                                           "Noun" = 2, 
                                           "Proper Noun" = 3,
                                           "Adverb" = 4,
                                           "Verb" = 5),
                           selected = c(1,2,3))),
      #tableOutput("data")
      
      
      
      
      mainPanel(
        helpText = ("Main Panel"),
        tabsetPanel(type = "tabs",tabPanel("Introduction", br(),p("This App will give you the option to upload the text
                                                        file as well as package file"),
                                           p("Your are allowed to upload any text file by using upload option"),
                                           br(),
                                           p("Second Tabl will give you the annoted documents in the form of Table
                                         and with option to display upto 100 rows. You have given the option to down
                                         load the data as well"),
                                           br(),
                                           p("Third Tab will display the two word clouds of uploaded data"),
                                           p("One for all Nouns in the corpus"),
                                           p("One word cloud for all Verbs"),
                                           br(),
                                           p("Fourth tab will display's plot ith top 30 co-occurances at document level as per
                                         the options selected from check boxes."),
                                           br(),
                                           br(),
                                           p("Make sure to upload English Modle first and then the text file"),
                                           p("ENJOY THE APP")),
                    tabPanel("Table of Annotated Documents",dataTableOutput("Annotation_Summary"),
                             downloadButton("download", "Download")),
                    tabPanel("Word Clouds",fluidRow(plotOutput("wordcloud1"),plotOutput("Wordcloud2"))),
                    
                    tabPanel("Top 30 Co-Occurances",plotOutput("Co_occurance")))
        
        
        
      ) 
    )     
  )  
)  



