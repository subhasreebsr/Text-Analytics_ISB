suppressPackageStartupMessages({
  if (!require(udpipe)){install.packages("udpipe")}
  if (!require(textrank)){install.packages("textrank")}
  if (!require(lattice)){install.packages("lattice")}
  if (!require(igraph)){install.packages("igraph")}
  if (!require(ggraph)){install.packages("ggraph")}
  if (!require(wordcloud)){install.packages("wordcloud")}
  
  library(udpipe)
  library(textrank)
  library(lattice)
  library(igraph)
  library(ggraph)
  library(ggplot2)
  library(wordcloud)
  library(stringr)
})

#english_model = udpipe_load_model("D:\\My Course\\Residency 2\\Text Analytics\\Session 4\\Session 4 Materials\\Session 4 Materials\\english-ewt-ud-2.4-190531.udpipe")
options(shiny.maxRequestSize=30*1024^2)
server <- shinyServer(function(input,output){
  
  read_english <- reactive({
    
    if (is.null(input$textfile1))
    {return(NULL)}
    else{
      input_text1 = udpipe_load_model(input$textfile1$datapath)
      return(input_text1)
    }
  })
  
  annotatte_1 <- reactive({
    
    if (is.null(input$textfile2))
    {
      return(NULL)
    }
    else{
      
      input_text = readLines(input$textfile2$datapath)
      
      x <- udpipe_annotate(read_english(),x = input_text)
      return(x)
    }
  })
  output$Annotation_Summary <- renderDataTable({
    
    ant <- as.data.frame(annotatte_1())
    
  }
  )
  
  
  
  output$download <- downloadHandler(
    filename = function() {
      paste(input$download, ".csv", sep = ",")
    },
    content = function(file) {
      write.csv(as.data.frame(annotatte_1()), file, row.names = FALSE)
    } )
  
  wordcloud_1 <- reactive({
    
    ant <- as.data.frame(annotatte_1())
    all_verb = ant %>% subset(., upos %in% "VERB") 
    top_verb = txt_freq(all_verb$lemma)
    return(top_verb)
    
  })
  
  
  
  output$wordcloud1 <- renderPlot({
    
    y = wordcloud(words = wordcloud_1()$key, 
                  random.order = FALSE, 
                  colors = brewer.pal(6, "Dark2"))
    
  }
  )
  
  wordcloud_2 <- reactive({
    
    ant <- as.data.frame(annotatte_1())
    all_noun = ant %>% subset(., upos %in% "NOUN") 
    top_noun = txt_freq(all_noun$lemma)
    return(top_noun)
  }
  )
  output$Wordcloud2 <- renderPlot({
    
    y = wordcloud(words = wordcloud_2()$key, 
                  random.order = FALSE, 
                  colors = brewer.pal(6, "Dark2"))
  })
  
  
  ##observeEvent(input$checkGroup, {
  #if (input$checkGroup == c("Adjectives (Adj)","Noun","Proper Noun"))
  #{
  co_occ <- reactive({
    ant <- as.data.frame(annotatte_1())
    test_cooc <- cooccurrence(x = subset(ant, upos %in% c("NOUN", "ADJ","PROPN")), 
                              term = "lemma", 
                              group = c("doc_id"))
    return(test_cooc) 
    
  })
  
  output$Co_occurance  <- renderPlot({
    
    noun_adj <- head(co_occ(),30)
    noun_adj <- igraph::graph_from_data_frame(noun_adj) 
    
    ggraph(noun_adj, layout = "fr") +  
      
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
      geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
      
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
      
      labs(title = "Cooccurrences", subtitle = "Nouns,Adjective and PROPN")
    
  }
  )
  #}
  #if (input$checkGroup == c("Adjectives (Adj)","Noun","Adverb"))
  #{
  #co_oc1 <- reactive({
  #ant <- as.data.frame(annotatte_1())
  #test_cooc <- cooccurrence(ant = subset(ant, upos %in% c("NOUN", "ADJ","ADV")), 
  #term = "lemma", 
  #group = c("doc_id"))
  #return(test_cooc)
  
  # }
  #)
  
  #output$Co_occurance  <- renderPlot({
  
  #noun_adj <- head(co_oc1(), 50)
  #noun_adj <- igraph::graph_from_data_frame(noun_adj) 
  
  #ggraph(noun_adj, layout = "fr") +  
  
  #geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
  #geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
  
  #theme_graph(base_family = "Arial Narrow") +  
  #theme(legend.position = "none") +
  
  #labs(title = "Cooccurrences", subtitle = "Nound,Adjective and Adverb")
  #}
  #)
  #}
  
  
  #}
  #)
}

)


#shinyApp(ui=ui,server=server)