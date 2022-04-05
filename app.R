source("loadPackages.R", encoding="UTF-8")


library(shiny)

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .shiny-output-error-validation {
        color: green;
        font-size:20px;
      }
    "))
  ),
  
  h1("Indicadores oasisbr"),
  
  hr(),
  
  h2("Total de documentos"),
  h3(textOutput("totalDocumentosOutput")),
  
  hr(),
  
  fluidRow(column(8,textInput("textoBuscaInput", label=NULL, placeholder = "Filtre os documentos pelos indicadores abaixo")),
  column(2,selectInput("camposInput", label=NULL, choices = c("Todos os campos", "Título", "Autor","Assunto"))),
  column(2,actionButton("buscarButton", "Buscar"))),
  
  uiOutput("fieldUi"),
  actionButton("addField", "Adicionar campo"),
  
  hr(),
  
  h1(paste("Documentos por área do conhecimento do CNPq")),
  numericInput("subjectTopInput","Top",10),
  addSpinner(plotlyOutput("subject_cnpqPlotlyOutput"),spin="folding-cube",color="green"),
  
  hr(),
  
  h1("Documentos por palavra-chave"),
  numericInput("wordCloudTopInput","Top",30),
  addSpinner(wordcloud2Output("palavraChavePlotOutput"),spin="folding-cube",color="green"),
  
  hr(),
  
  h1("Documentos por ano de publicação"),
  sliderInput("anoPublicacaoSliderInput","Ano de publicação",min = 1980, max = 2022, value = c(2011, 2021)),
  addSpinner(plotlyOutput("publishDatePlotlyOutput"),spin="folding-cube",color="green"),
  
  hr(),
  
  h1("Documentos por programa de pós-graduação - PPG"),
  numericInput("programTopInput","Top",10),
  addSpinner(plotlyOutput("programPlotlyOutput"),spin="folding-cube",color="green"),
  
  hr(),
  
  h1("Autores com mais documentos"),
  numericInput("authorTopInput","Top",10),
  addSpinner(plotlyOutput("authorPlotOutput"),spin="folding-cube",color="green"),
  
  hr(),
  
  h1("Documentos por tipo"),
  addSpinner(plotlyOutput("tipoDocumentoPlotlyOutput"),spin="folding-cube",color="green"),
  
  hr(),
  
  h1("Documentos por idioma"),
  addSpinner(plotlyOutput("idiomaPlotlyOutput"),spin="folding-cube",color="green"),
  
  hr(),
  
  h1("Documentos por tipo de acesso"),
  addSpinner(plotlyOutput("tipoAcessoPlotlyOutput"),spin="folding-cube",color="green"),
  
  hr()
  

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
    
    #oasisbrDF <- fromJSON(paste("https://oasisbr.ibict.br/vufind/api/v1/search?&type=AllFields&page=0&limit=0&sort=relevance&facet[]=author_facet&facet[]=dc.subject.por.fl_str_mv&facet[]=eu_rights_str_mv&facet[]=dc.publisher.program.fl_str_mv&facet[]=dc.subject.cnpq.fl_str_mv&facet[]=publishDate&facet[]=language&facet[]=format&facet[]=institution&facet[]=dc.contributor.advisor1.fl_str_mv",sep=""))
    
 # if ( exists("oasisbrDF")==TRUE ) { print("Servidor funcionando.")
    
#  } else {
    
    
   # print("Usando DF local")
    oasisbrDF <- fromJSON("oasisbr_indicadores_gerais_31-03-2022.json")
    
 # }
    
    return(oasisbrDF)
    
  })
  
  
  
  ## Outputs para informações gerais
  
  output$totalDocumentosOutput <- renderText({ formatC(oasisbrBuscaUser()$resultCount, format="f", big.mark = ".", digits=0) })
  
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
      
      #oasisbrDF <- fromJSON(paste("https://oasisbr.ibict.br/vufind/api/v1/search?lookfor=",URLencode(input$textoBuscaInput),"&type=AllFields&page=0&limit=0&sort=relevance&facet[]=author_facet&facet[]=dc.subject.por.fl_str_mv&facet[]=eu_rights_str_mv&facet[]=dc.publisher.program.fl_str_mv&facet[]=dc.subject.cnpq.fl_str_mv&facet[]=publishDate&facet[]=language&facet[]=format&facet[]=institution&facet[]=dc.contributor.advisor1.fl_str_mv",sep=""))

    })
    
    output$authorPlotOutput <- renderPlotly({  renderAuthorPlot(oasisbrBuscaUser(),input$authorTopInput) })
      
    output$subject_cnpqPlotlyOutput <- renderPlotly({ renderSubjectPlot(oasisbrBuscaUser(),input$subjectTopInput) })
    
    output$palavraChavePlotOutput <- renderWordcloud2({ wordCloudPlot(oasisbrBuscaUser(),input$wordCloudTopInput) })
    
    output$publishDatePlotlyOutput <- renderPlotly({renderAnoPublicacaoPlot(oasisbrBuscaUser(),input$anoPublicacaoSliderInput[1],input$anoPublicacaoSliderInput[2])})
    
    output$idiomaPlotlyOutput <- renderPlotly({renderIdiomaPlot(oasisbrBuscaUser())})
    
    output$tipoDocumentoPlotlyOutput <- renderPlotly({renderTipoDocumentoPlot(oasisbrBuscaUser())})
    
    output$tipoAcessoPlotlyOutput <- renderPlotly({renderTipoAcessoPlot(oasisbrBuscaUser())})
    
    output$programPlotlyOutput <- renderPlotly({renderProgramPlot(oasisbrBuscaUser(),input$programTopInput)})
    
    output$totalDocumentosOutput <- renderText({ oasisbrBuscaUser()$resultCount })
      
    }) 
    
}

shinyApp(ui, server)