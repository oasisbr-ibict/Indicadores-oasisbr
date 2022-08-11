source("loadPackages.R", encoding="UTF-8")

library(shiny)
library(shinydashboard)

ui <- fluidPage(
  useShinydashboard(),
  includeCSS("www/oasisbr_app.css"), br(),
  
  fluidRow(
    column(offset = 1, 10,
 # img(src='oasisbr.png', style = "position:float;", width = "300px"),
  column(12,h1("Indicadores gerais")),
  hr(),
  hr(),
  
  valueBox(
    h3(textOutput("totalDocumentosOutput")),
    "Total de documentos",
    icon = icon("database")
    ),

  hr()),


column(offset = 1, 10,
       column(12,
         fluidRow(
           column(6,textInput("textoBuscaInput", label=NULL, placeholder = "Filtre os documentos pelos indicadores abaixo",width = "100%")),
           column(3,selectInput("camposInput", label=NULL, choices = c("Todos os campos"="AllFields", "Título"="Title", "Autor"="Author","Assunto"="Subject"),width="100%")),
           column(3,actionButton("buscarButton", "Buscar",width="100%"))
  )),
   
  column(12, uiOutput("resultadosDaBuscaTextoOutput")),
  
  ),
#mod_texto_resultado_da_busca_UI("texto_resultado_da_busca")
),

#====== MODULO GRAFICOS UI
mod_graficos_UI("graficos")
#======
)

server <- function(input, output, session) {
  
  ## Cria DF reativo com informações gerais
  oasisbrBuscaUser <<- reactive({

    oasisbrDF <- busca_oasisbr(lookfor = "")

    return(oasisbrDF)

  })
  
  
#====== MODULO GRAFICOS SERVER
mod_graficos_server("graficos")
#======
  
  output$totalDocumentosOutput <- renderText({ scales::comma(total_de_documentos) })
  
  
  ## Cria DF reativo para a busca do usuário e atualiza outputs
  
  observeEvent(input$buscarButton,{
    
    print(paste("Iniciado busca para termo:",isolate(input$textoBuscaInput)))
    
    oasisbrBuscaUser <<- reactive({
      
      start <- Sys.time ()
      x <- busca_oasisbr(lookfor = URLencode(isolate(input$textoBuscaInput)),
                    type=isolate(input$camposInput))
      
      tempo_de_busca <<- (Sys.time () - start)
      return(x)
      
    })
    
    mod_graficos_server("graficos")
    
   # Criar função para definir objeto em texto
   # mod_texto_resultado_da_busca_server("texto_resultado_da_busca")
    output$resultadosDaBuscaTextoOutput <- renderUI({ HTML(paste('<hr>','Mostrando os resultados de <span class="badge">',scales::comma(oasisbrBuscaUser()$resultCount),'</span> documentos para a busca "<span class="badge">',isolate(input$textoBuscaInput),'</span>".<br>Tempo de busca: ',substr(gsub("","",tempo_de_busca),1,5),' segundos.<hr>',sep="")) })
      
    }) 
    
}

shinyApp(ui, server)