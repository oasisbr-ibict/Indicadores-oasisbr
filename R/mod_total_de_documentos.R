mod_total_de_documentos_UI <- function(id) {
  ns <- NS(id)
  tagList(
    
  fluidRow(splitLayout(
    valueBox(
      h4(textOutput(ns("totalDocumentosOutput"))),
      "Total de documentos", icon = icon("database"), width = "100%",color = "blue"
      ),
    
    valueBox(
      h4(textOutput(ns("artigos_output"))),
      "Artigos", icon = icon("newspaper"), width = "100%"
      ),
  
    valueBox(
      h4(textOutput(ns("teses_dissertacoes_output"))),
      "Teses e dissertações", icon = icon("book-open"), width = "100%"
      ),
  valueBox(
      h4(textOutput(ns("conjunto_dados_output"))),
      "Conjunto de dados", icon = icon("table"), width = "100%"
      ),
  
  valueBox(
    h4(textOutput(ns("livros_capitulos_output"))),
    "Livros e capítulos de livros", icon = icon("book"), width = "100%"
  )
  )
  )
  
  )
}

mod_total_de_documentos_Server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      
      # Objeto reativo para tipos de documento
      tipos_doc <- reactive({
        
        x <- tipos_de_documento(oasisbrBuscaUser())
        return(x)
        
      })
      
      output$totalDocumentosOutput <- renderText({ scales::comma(oasisbrBuscaUser()$resultCount)})
      
      output$teses_dissertacoes_output <- renderText({ total_documento(tipos_doc(),c("masterThesis","doctoralThesis")) })
      
      output$artigos_output <- renderText({ total_documento(tipos_doc(),c("article")) })
      
      output$conjunto_dados_output <- renderText({ total_documento(tipos_doc(),c("dataset")) })
      
      output$livros_capitulos_output <- renderText({ total_documento(tipos_doc(),c("book","bookPart")) })
      
      
    }
  )
}