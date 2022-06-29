source("loadPackages.R", encoding="UTF-8")

library(shiny)
library(shinydashboard)

ui <- fluidPage(
  useShinydashboard(),
  includeCSS("www/oasisbr_app.css"), br(),
  
  fluidRow(
    column(offset = 1, 10,
  img(src='oasisbr.png', style = "position:float;", width = "300px"),
  column(12,h1("Indicadores gerais")),
  hr(),
  hr(),
  
  valueBox(
    h3(textOutput("totalDocumentosOutput")), 
    "Total de documentos", 
    icon = icon("database")
    ),
  valueBox(
    h3(textOutput("totalInstituicoesOutput")), 
    "Total de instituicoes", 
    icon = icon("building")
  ),

  hr()),


column(offset = 1, 10,
       column(12,
         fluidRow(
           column(6,textInput("textoBuscaInput", label=NULL, placeholder = "Filtre os documentos pelos indicadores abaixo",width = "100%")),
           column(3,selectInput("camposInput", label=NULL, choices = c("Todos os campos"="AllFields", "Título"="Title", "Autor"="Author","Assunto"="Subject"),width="100%")),
           column(3,actionButton("buscarButton", "Buscar",width="100%"))
  )),
  
  ## Texto com resultado da busca
   
  column(12, uiOutput("resultadosDaBuscaTextoOutput")),
  
  ),
#mod_texto_resultado_da_busca_UI("texto_resultado_da_busca")

),
#====== MODULO GRAFICOS 
mod_graficos_UI("graficos")

)

server <- function(input, output, session) {
  
  
  ## Cria DF reativo com informações gerais
  oasisbrBuscaUser <<- reactive({
    tic("Download.")
    busca_oasisbr(lookfor = "")
    toc()


  if ( exists("oasisbrDF")==TRUE ) { print("Servidor funcionando.")

  } else {


    print("Usando DF local")
    oasisbrDF <- fromJSON("oasisbr_indicadores_gerais_31-03-2022.json")

  }

    return(oasisbrDF)

  })
  
  
  ## MODULO SERVER GRAFICOS ===========
  
 mod_graficos_server("graficos")
  
  ## FIM MODULO SERVER GRAFICOS
  
  output$totalDocumentosOutput <- renderText({ scales::comma(total_de_documentos) })
  
  output$totalInstituicoesOutput <- renderText({ scales::comma(total_de_instituicoes) })


  
  ## Cria DF reativo para a busca do usuário e atualiza outputs
  
  observeEvent(input$buscarButton,{
    
    print(paste("Iniciado busca para termo:",input$textoBuscaInput))
    
    oasisbrBuscaUser <<- reactive({
      
      busca_oasisbr(lookfor = URLencode(input$textoBuscaInput),
                    type=input$camposInput)
     # oasisbrDF <- fromJSON(paste("http://localhost/vufind/api/v1/search?lookfor=",URLencode(input$textoBuscaInput),"&type=AllFields&page=0&limit=0&sort=relevance&facet[]=author_facet&facet[]=dc.subject.por.fl_str_mv&facet[]=eu_rights_str_mv&facet[]=dc.publisher.program.fl_str_mv&facet[]=dc.subject.cnpq.fl_str_mv&facet[]=publishDate&facet[]=language&facet[]=format&facet[]=institution&facet[]=dc.contributor.advisor1.fl_str_mv",sep=""))
      
      
    })
    
    mod_graficos_server("graficos")
    
    #mod_texto_resultado_da_busca("texto_resultado_busca")
    # Criar função para definir objeto em texto
   # mod_texto_resultado_da_busca_server("texto_resultado_da_busca")
    output$resultadosDaBuscaTextoOutput <- renderUI({ HTML(paste('Mostrando os resultados de <span class="badge">',scales::comma(oasisbrBuscaUser()$resultCount),'</span> documentos para a busca "<span class="badge">',input$textoBuscaInput,'</span>".<br>Tempo de busca: 0 segundos.<hr>',sep="")) })
      
    }) 
    
}

shinyApp(ui, server)