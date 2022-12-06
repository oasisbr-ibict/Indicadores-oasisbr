Sys.setlocale("LC_ALL","C.UTF-8")
source("loadPackages.R", encoding="UTF-8")

library(shiny)
library(shinydashboard)

ui <- fluidPage(
  useShinydashboard(),
  includeCSS("www/oasisbr_app.css"), br(),
  
  tabsetPanel(type = "tabs",
              
#====== ABA ======= INDICADORES GERAIS =========================================
tabPanel("Indicadores gerais", 
  fluidRow(
  column(12,h1("Indicadores gerais")),
  column(12,mod_total_de_documentos_UI("total_de_documentos"),hr()),

       column(12,
         fluidRow(
           column(6,textInput("textoBuscaInput", label=NULL, placeholder = "Filtre os documentos pelos indicadores abaixo",width = "100%")),
           column(3,selectInput("camposInput", label=NULL, choices = c("Todos os campos"="AllFields", "Título"="Title", "Autor"="Author","Assunto"="Subject"),width="100%")),
           column(3,actionButton("buscarButton", "Buscar",width="100%"))
           )
         ),
   
  column(12, uiOutput("resultadosDaBuscaTextoOutput")),
  
),

#====== MODULO GRAFICOS UI
mod_graficos_UI("graficos")
#===============================================================================
),

#====== ABA ====== INDICADORES DE EVOLUÇÃO =====================================
tabPanel("Indicadores de evolução",
         
         fluidRow(
         column(12,h1("Indicadores de evolução")),
         column(12,mod_total_de_documentos_UI("total_de_documentos2"),
                sliderInput("ano_evolucao_input",
                            label = "Ano",
                            min = 2017, max = 2022, value = c(2017, 2022), sep=""),
                   mod_graficos_evolucao_UI("graficos_evolucao")))
         ),

#===============================================================================

#====== ABA === ANÁLISES AVANÇADAS ===
# tabPanel("Análises avançadas",
#          
#          fluidRow(
#            column(12,h1("Análises avançadas")),
#            mod_analises_avancadas_UI("analises_avancadas"))
#          )
#===============================================================================


))

server <- function(input, output, session) {
  
  ## Cria DF reativo com informações gerais
  oasisbrBuscaUser <<- reactive({

    oasisbrDF <- busca_oasisbr(lookfor = "")

    return(oasisbrDF)

  })
  
  ## Cria DF reativo com heatmap - analise avancada
  oasisbrBuscaUser_heatmap <<- reactive({
    
    oasisbrDF_heatmap <- busca_oasisbr_heatmap()
    
    return(oasisbrDF_heatmap)
    
  })
  
  ## Cria DF reativo com indicadores de evolução
  oasisbrBuscaUser_heatmap <<- reactive({
    
    oasisbrDF_evolucao <- busca_oasirbr_evolucao()
    
  })
  
  

#====== MODULO TOTAL DE DOCUMENTOS SERVER
mod_total_de_documentos_Server("total_de_documentos")  

mod_total_de_documentos_Server("total_de_documentos2")  

#====== MODULO GRAFICOS SERVER
#mod_graficos_server("graficos",busca_usuario=input$textoBuscaInput)
mod_graficos_server("graficos",input$textoBuscaInput)

#====== MODULO GRAFICOS DE EVOLUCAO SERVER
mod_graficos_evolucao_Server("graficos_evolucao")

#====== MODULO ANALISES AVANCADAS
mod_analises_avancadas_Server("analises_avancadas")

  
  ## Cria DF reativo para a busca do usuário e atualiza outputs

texto_reactive <<- reactive({
  x <- input$textoBuscaInput
  return(x)
})
  
  observeEvent(input$buscarButton,{
    
    print(paste("Iniciado busca para termo:",isolate(input$textoBuscaInput)))
    
    oasisbrBuscaUser <<- reactive({
      
      start <- Sys.time ()
      x <- busca_oasisbr(lookfor = URLencode(isolate(input$textoBuscaInput)),
                    type=isolate(input$camposInput))
      
      tempo_de_busca <<- (Sys.time () - start)
      return(x)
      
    })
    

    
    ## Cria DF reativo com heatmap - analise avancada
    oasisbrBuscaUser_heatmap <<- reactive({
      
      oasisbrDF_heatmap <- busca_oasisbr_heatmap(q=isolate(input$textoBuscaInput))
      
      return(oasisbrDF_heatmap)
      
    })
    
    mod_graficos_server("graficos",input$textoBuscaInput)
    
    mod_graficos_evolucao_Server("graficos_evolucao")
    
    mod_analises_avancadas_Server("analises_avancadas")
    
   # Criar função para definir objeto em texto
   # mod_texto_resultado_da_busca_server("texto_resultado_da_busca")
    output$resultadosDaBuscaTextoOutput <- renderUI({ HTML(paste('<hr>','Mostrando os resultados de <span class="badge">',scales::comma(oasisbrBuscaUser()$resultCount),'</span> documentos para a busca "<span class="badge">',isolate(input$textoBuscaInput),'</span>".<br>Tempo de busca: ',substr(gsub("","",tempo_de_busca),1,5),' segundos.<hr>',sep="")) })
      
    }) 
    
}

shinyApp(ui, server)
