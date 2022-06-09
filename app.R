source("loadPackages.R", encoding="UTF-8")

library(shiny)
library(shinydashboard)

ui <- fluidPage(
  useShinydashboard(),
  includeCSS("www/oasisbr_app.css"),
  br(),
  column(offset = 1, 10,
         
  #column(12,img(src='oasisbr.png', style = "float:right;", width = "600px", position="float")),
  img(src='oasisbr.png', style = "position:float;", width = "300px"),
  column(12,h1("Indicadores gerais")),
  hr(),
  hr(),
 # hr(),
  valueBox(
    h3(textOutput("totalDocumentosOutput")), 
    "Total de documentos", 
    icon = icon("database")
    ),
hr(),
  column(12,
         fluidRow(
           column(6,textInput("textoBuscaInput", label=NULL, placeholder = "Filtre os documentos pelos indicadores abaixo",width = "100%")),
           column(3,selectInput("camposInput", label=NULL, choices = c("Todos os campos"="todos", "Título"="titulo", "Autor"="autor","Assunto"="assunto"),width="100%")),
           column(3,actionButton("buscarButton", "Buscar",width="100%"))
  )),
  
  column(12,uiOutput("resultadosDaBuscaTextoOutput")),
  
  #uiOutput("fieldUi"),
  #actionButton("addField", "Adicionar campo"),
  
 box(
    title = "Documentos por área do conhecimento do CNPq", width = 12, solidHeader = TRUE, status = "primary",
    column(12,numericInput("subjectTopInput","Termos exibidos",10, width = "20%")),
    column(12,addSpinner(plotlyOutput("subject_cnpqPlotlyOutput"),spin="folding-cube",color="green"))
  ),
 
 box(
   title = "Documentos por palavra-chave", width = 12, solidHeader = TRUE, status = "primary",
   column(12,numericInput("wordCloudTopInput","Termos exibidos",30,width="20%")),
   column(12,addSpinner(wordcloud2Output("palavraChavePlotOutput"),spin="folding-cube",color="green"))
 ),
 
 box(
   title = "Documentos por ano de publicação", width = 12, solidHeader = TRUE, status = "primary",
   column(12,sliderInput("anoPublicacaoSliderInput","Ano de publicação",min = 1980, max = 2022, value = c(2011, 2021),width="20%",sep="")),
   column(12,addSpinner(plotlyOutput("publishDatePlotlyOutput"),spin="folding-cube",color="green"))
 ),
  
 box(
   title = "Documentos por programa de pós-graduação - PPG", width = 12, solidHeader = TRUE, status = "primary",
   column(12,numericInput("programTopInput","Termos exibidos",10,width="20%")),
   column(12,addSpinner(plotlyOutput("programPlotlyOutput"),spin="folding-cube",color="green"))
 ),
  
 box(
   title = "Autores com mais documentos", width = 12, solidHeader = TRUE, status = "primary",
   column(12,numericInput("authorTopInput","Termos exibidos",10,width="20%")),
   column(12,addSpinner(plotlyOutput("authorPlotOutput"),spin="folding-cube",color="green"))
 ),
 
 box(
   title = "Documentos por tipo", width = 12, solidHeader = TRUE, status = "primary",
   column(12,addSpinner(plotlyOutput("tipoDocumentoPlotlyOutput"),spin="folding-cube",color="green")),
 ),
 
 box(
   title = "Documentos por idioma", width = 12, solidHeader = TRUE, status = "primary",
   column(12,addSpinner(plotlyOutput("idiomaPlotlyOutput"),spin="folding-cube",color="green")),
 ),
  
 box(
   title = "Documentos por tipo de acesso", width = 12, solidHeader = TRUE, status = "primary",
   column(12,addSpinner(plotlyOutput("tipoAcessoPlotlyOutput"),spin="folding-cube",color="green")),
 )

)
)

server <- function(input, output, session) {
  
  ###############################################################
  # Track the number of input boxes to render
  counter <- reactiveValues(n = 0)
  
  observeEvent(input$addField, {counter$n <- counter$n + 1})
  observeEvent(input$rm_btn, {
    if (counter$n > 0) counter$n <- counter$n - 1
  })
  
  
  textboxes <- reactive({
    
    n <- counter$n
    
    if (n > 0) {
      lapply(seq_len(n), function(i) {
        textInput(inputId = paste0("textin", i),
                  label = paste0("Textbox", i), value = "Hello World!")
      })
    }
    
  })
  
  
  conditionBox <- reactive({
    
    n <- counter$n
    
    if (n > 0) {
      lapply(seq_len(n), function(i) {
        selectInput(inputId = paste0("conditionInput", i),
                    label = paste0("Condicão ", i),
                    choices = c("Todos os campos","Título","Assunto","Autor"))
      })
    }
    
  })
  
  output$fieldUi <- renderUI({
    fluidRow(
      textboxes(),
    conditionBox() )
    })
  ####################################################################
  
  
  ## Cria DF reativo com informações gerais
  oasisbrBuscaUser <- reactive({
    tic("Download.")
    
   # print("Usando DF local")
  #  oasisbrDF <- fromJSON("data/oasisbr_indicadores_gerais_31-03-2022.json")
    
    oasisbrDF <- fromJSON("http://oasisbr.ibict.br/vufind/api/v1/search?&type=AllFields&page=0&limit=0&sort=relevance&facet[]=author_facet&facet[]=dc.subject.por.fl_str_mv&facet[]=eu_rights_str_mv&facet[]=dc.publisher.program.fl_str_mv&facet[]=dc.subject.cnpq.fl_str_mv&facet[]=publishDate&facet[]=language&facet[]=format&facet[]=institution&facet[]=dc.contributor.advisor1.fl_str_mv")
    toc()
    
    
  if ( exists("oasisbrDF")==TRUE ) { print("Servidor funcionando.")
    
  } else {
    
    
    print("Usando DF local")
    oasisbrDF <- fromJSON("oasisbr_indicadores_gerais_31-03-2022.json")
    
  }
    
    return(oasisbrDF)
    
  })
  
  
 # totalDocumentos <- oasisbrBuscaUser()$resultCount
  
  ## Outputs para informações gerais
  
  output$totalDocumentosOutput <- renderText({ scales::comma(total_de_documentos) })
  
  output$authorPlotOutput <- renderPlotly({ renderAuthorPlot(oasisbrBuscaUser(),input$authorTopInput) })
  
  output$palavraChavePlotOutput <- renderWordcloud2({ wordCloudPlot(oasisbrBuscaUser(),input$wordCloudTopInput) })
  
  output$subject_cnpqPlotlyOutput <- renderPlotly({ renderSubjectPlot(oasisbrBuscaUser(),input$subjectTopInput)})
  
  output$publishDatePlotlyOutput <- renderPlotly({renderAnoPublicacaoPlot(oasisbrBuscaUser(),input$anoPublicacaoSliderInput[1],input$anoPublicacaoSliderInput[2])})
  
  output$programPlotlyOutput <- renderPlotly({renderProgramPlot(oasisbrBuscaUser(),input$programTopInput)})
  
  output$idiomaPlotlyOutput <- renderPlotly({renderIdiomaPlot(oasisbrBuscaUser())})
  
  output$tipoDocumentoPlotlyOutput <- renderPlotly({renderTipoDocumentoPlot(oasisbrBuscaUser())})
  
  output$tipoAcessoPlotlyOutput <- renderPlotly({renderTipoAcessoPlot(oasisbrBuscaUser())})
  
  ## Cria DF reativo para a busca do usuário e atualiza outputs
  
  observeEvent(input$buscarButton,{
    
    print(paste("Iniciado busca para termo:",input$textoBuscaInput))
    
    oasisbrBuscaUser <- reactive({
      
      
      oasisbrDF <- fromJSON(paste("http://oasisbr.ibict.br/vufind/api/v1/search?lookfor=",URLencode(input$textoBuscaInput),"&type=AllFields&page=0&limit=0&sort=relevance&facet[]=author_facet&facet[]=dc.subject.por.fl_str_mv&facet[]=eu_rights_str_mv&facet[]=dc.publisher.program.fl_str_mv&facet[]=dc.subject.cnpq.fl_str_mv&facet[]=publishDate&facet[]=language&facet[]=format&facet[]=institution&facet[]=dc.contributor.advisor1.fl_str_mv",sep=""))

     # print("Usando DF local")
      #oasisbrDF <- fromJSON("data/oasisbr_indicadores_gerais_31-03-2022.json")
      
      
    })
    
    output$authorPlotOutput <- renderPlotly({  renderAuthorPlot(oasisbrBuscaUser(),input$authorTopInput) })
      
    output$subject_cnpqPlotlyOutput <- renderPlotly({ renderSubjectPlot(oasisbrBuscaUser(),input$subjectTopInput) })
    
    output$palavraChavePlotOutput <- renderWordcloud2({ wordCloudPlot(oasisbrBuscaUser(),input$wordCloudTopInput) })
    
    output$publishDatePlotlyOutput <- renderPlotly({renderAnoPublicacaoPlot(oasisbrBuscaUser(),input$anoPublicacaoSliderInput[1],input$anoPublicacaoSliderInput[2])})
    
    output$idiomaPlotlyOutput <- renderPlotly({renderIdiomaPlot(oasisbrBuscaUser())})
    
    output$tipoDocumentoPlotlyOutput <- renderPlotly({renderTipoDocumentoPlot(oasisbrBuscaUser())})
    
    output$tipoAcessoPlotlyOutput <- renderPlotly({renderTipoAcessoPlot(oasisbrBuscaUser())})
    
    output$programPlotlyOutput <- renderPlotly({renderProgramPlot(oasisbrBuscaUser(),input$programTopInput)})
    
   # output$totalDocumentosOutput <- renderText({ scales::comma(total_de_documentos) })
    
    # Criar função para definir objeto em texto
    output$resultadosDaBuscaTextoOutput <- renderUI({ HTML(paste('Mostrando os resultados de <span class="badge">',scales::comma(oasisbrBuscaUser()$resultCount),'</span> documentos para a busca "<span class="badge">',input$textoBuscaInput,'</span>".<br>Tempo de busca: 0 segundos.<hr>',sep="")) })
      
    }) 
    
}

shinyApp(ui, server)