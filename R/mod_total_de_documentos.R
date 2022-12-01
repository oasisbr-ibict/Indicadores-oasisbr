mod_total_de_documentos_UI <- function(id) {
  ns <- NS(id)
  tagList(
    
  fluidRow(
    valueBox(
    h4(textOutput(ns("totalDocumentosOutput"))),
    "Total de documentos", icon = icon("database")))
  
  )
}

mod_total_de_documentos_Server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      
      output$totalDocumentosOutput <- renderText({ scales::comma(total_de_documentos) })
      
      
    }
  )
}