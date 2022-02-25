
library(shiny)

ui <- fluidPage(
  h1("Indicadores oasisbr"),
  
  h2("Total de documentos"),
  h2(totalDocumentos),
  
  h1("Documentos por programa de pós-graduação - PPG (TOP 10)"),
  plotlyOutput("programPlotlyOutput"),
  
  hr(),
  
  h1("Documentos por área do conhecimento do CNPq (TOP 10)"),
  plotlyOutput("subject_cnpqPlotlyOutput"),
  
  hr(),
  
  h1("Documentos por palavra-chave (TOP 30)"),
  wordcloud2Output("palavraChavePlotOutput"),
  
  hr(),
  
  
  h1("Autores com mais documentos (TOP 10)"),
  plotlyOutput("authorPlotOutput"),
  
  hr(),
  
  h1("Documentos por ano de publicação (TOP 10)"),
  plotlyOutput("publishDatePlotlyOutput"),

  hr()
  

)

server <- function(input, output, session) {
  
  output$authorPlotOutput <- renderPlotly({authorPlotly})
  
  output$palavraChavePlotOutput <- renderWordcloud2({palavraChavePlot})
  
  output$subject_cnpqPlotlyOutput <- renderPlotly({subject_cnpqPlotly})
  
  output$publishDatePlotlyOutput <- renderPlotly({publishDatePlotly})
  
  output$programPlotlyOutput <- renderPlotly({programPlotly})
  
}

shinyApp(ui, server)