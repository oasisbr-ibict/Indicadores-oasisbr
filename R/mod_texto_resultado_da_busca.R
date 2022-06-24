mod_texto_resultado_da_busca_UI <- function(id,x) {
  ns <- NS(id)
  
  
  tagList(
    fluidRow(
      
      column(12, uiOutput(ns("resultadosDaBuscaTextoOutput")))
      
    )
  )
}

mod_texto_resultado_da_busca_server <- function(id, base) {
  shiny::moduleServer(
    id,
    function(input, output, session) {
      
      
      output$resultadosDaBuscaTextoOutput <- renderUI({ HTML(paste('Mostrando os resultados de <span class="badge">',scales::comma(oasisbrBuscaUser()$resultCount),'</span> documentos para a busca "<span class="badge">',input$textoBuscaInput,'</span>".<br>Tempo de busca: 0 segundos.<hr>',sep="")) })
      
    }
  )
}