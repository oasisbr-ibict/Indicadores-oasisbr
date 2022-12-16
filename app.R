Sys.setlocale("LC_ALL","C.UTF-8")
source("loadPackages.R", encoding="UTF-8")

library(shiny)
library(shinydashboard)

ui <- fluidPage(useShinydashboard(),
  includeCSS("www/oasisbr_app.css"), br(),
  
tabsetPanel(type = "tabs",
              
#====== ABA ======= INDICADORES GERAIS =========================================
tabPanel("Indicadores gerais", 

#====== MODULO GRAFICOS UI
mod_graficos_UI("graficos")),
#===============================================================================


#====== ABA ====== INDICADORES DE EVOLUÇÃO =====================================
tabPanel("Indicadores de evolução",
         
fluidRow(column(12,h4("Indicadores de evolução"),
#====== MODULO TOTAL DE DOCUMENTOS UI
mod_total_de_documentos_UI("total_de_documentos2"),
#====== MODULO GRAFICOS DE EVOLUCAO UI     
mod_graficos_evolucao_UI("graficos_evolucao")))),
#===============================================================================


#====== ABA === ANÁLISES AVANÇADAS =============================================
tabPanel("Análises avançadas",
#====== MODULO ANALISES AVANCADAS UI         
mod_analises_avancadas_UI("analises_avancadas")
#===============================================================================
)

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
  oasisbrBuscaUser_evolucao <<- reactive({
    oasisbrDF_evolucao <- busca_oasisbr_evolucao()
  })
  
  ## Cria DF reativo com indicadores de evolução por tipo de documento
  oasisbrBuscaUser_tipodoc_ano <<- reactive({

    if (input$textoBuscaInput=="") {
     
      x <- busca_oasisbr_tipodoc_ano(q="*:*")
       
    } else {
    
    x <- busca_oasisbr_tipodoc_ano(q=isolate(input$textoBuscaInput))
    return(x)
    }

  })
  

#====== MODULO TOTAL DE DOCUMENTOS SERVER
mod_total_de_documentos_Server("total_de_documentos")  

#====== MODULO TOTAL DE DOCUMENTOS2 SERVER
mod_total_de_documentos_Server("total_de_documentos2")  

#====== MODULO GRAFICOS SERVER
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


## Inicia busca pelo termo inserido e atualiza outputs

  observeEvent(input$buscarButton,{
    
    print(paste("Iniciado busca para termo:",isolate(input$textoBuscaInput)))
    
    oasisbrBuscaUser <<- reactive({
      
      start <- Sys.time ()
      x <- busca_oasisbr(lookfor = URLencode(isolate(input$textoBuscaInput)),
                         type = isolate(input$camposInput))
      
      tempo_de_busca <<- (Sys.time () - start)
      return(x)
      
    })

    
    ## Cria DF reativo com heatmap - analise avancada
    oasisbrBuscaUser_heatmap <<- reactive({
      oasisbrDF_heatmap <- busca_oasisbr_heatmap(q=isolate(input$textoBuscaInput))
      return(oasisbrDF_heatmap)
    })
    
#====== ATUALIZA TODOS OS MÓDULOS 
mod_graficos_server("graficos",input$textoBuscaInput)
mod_graficos_evolucao_Server("graficos_evolucao")
mod_analises_avancadas_Server("analises_avancadas")
mod_total_de_documentos_Server("total_de_documentos")  
    
    output$resultadosDaBuscaTextoOutput <- renderUI({ HTML(paste('<hr>','Mostrando os resultados de <span class="badge">',scales::comma(oasisbrBuscaUser()$resultCount),'</span> documentos para a busca "<span class="badge">',isolate(input$textoBuscaInput),'</span>".<br>Tempo de busca: ',substr(gsub("","",tempo_de_busca),1,5),' segundos.<hr>',sep="")) })
    
    }) 
}

shinyApp(ui, server)
