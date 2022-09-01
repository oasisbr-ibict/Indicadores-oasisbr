mod_barra_de_busca_UI <- function(id) {
  ns <- NS(id)
  tagList(
    
    fluidRow(
      
      column(12,
             fluidRow(
               column(6,textInput(ns("textoBuscaInput"), label=NULL, placeholder = "Filtre os documentos pelos indicadores abaixo",width = "100%")),
               column(3,selectInput(ns("camposInput"), label=NULL, choices = c("Todos os campos"="AllFields", "Título"="Title", "Autor"="Author","Assunto"="Subject"),width="100%")),
               column(3,actionButton(ns("buscarButton"), "Buscar",width="100%"))
             )),
      
      column(12, uiOutput(ns("resultadosDaBuscaTextoOutput")))
      
    )
  
  )
}

mod_barra_de_busca_Server <- function(id,y) {
  moduleServer(
    id,
    
    function(input, output, session) {
      
      observeEvent(input$buscarButton,{
        
        print(paste("Iniciado busca para termo:",isolate(input$textoBuscaInput)))
        
        base <<- reactive({
          
          start <- Sys.time ()
          x <- busca_oasisbr(lookfor = URLencode(isolate(input$textoBuscaInput)),
                             type=isolate(input$camposInput))
          
          tempo_de_busca <<- (Sys.time () - start)
          return(x)
          
        })
        
        mod_graficos_server("graficos",base=base)
        
        #mod_graficos_evolucao_Server("graficos_evolucao")
        
        # Criar função para definir objeto em texto
        
        output$resultadosDaBuscaTextoOutput <- renderUI({ HTML(paste('<hr>','Mostrando os resultados de <span class="badge">',scales::comma(oasisbrBuscaUser()$resultCount),'</span> documentos para a busca "<span class="badge">',isolate(input$textoBuscaInput),'</span>".<br>Tempo de busca: ',substr(gsub("","",tempo_de_busca),1,5),' segundos.<hr>',sep="")) })
        
      }) 
      
      
     # output$resultadosDaBuscaTextoOutput <- renderUI({ HTML(paste('<hr>','Mostrando os resultados de <span class="badge">',scales::comma(oasisbrBuscaUser()$resultCount),'</span> documentos para a busca "<span class="badge">',isolate(input$textoBuscaInput),'</span>".<br>Tempo de busca: ',substr(gsub("","",tempo_de_busca),1,5),' segundos.<hr>',sep="")) })
      
    }
  )
}