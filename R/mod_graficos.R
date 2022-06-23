mod_graficos_UI <- function(id,x) {
  ns <- NS(id)
  

  tagList(
    fluidRow(
      column(offset = 1, 10,
             
             box(
               title = "Documentos por área do conhecimento do CNPq", width = 12, solidHeader = TRUE, status = "primary",
               column(12,numericInput(ns("subjectTopInput"),"Termos exibidos",10, width = "20%")),
               column(12,addSpinner(plotlyOutput(ns("subject_cnpqPlotlyOutput")),spin="folding-cube",color="green"))
             ),
             
             box(
               title = "Documentos por palavra-chave", width = 12, solidHeader = TRUE, status = "primary",
               column(12,numericInput(ns("wordCloudTopInput"),"Termos exibidos",30,width="20%")),
               column(12,addSpinner(wordcloud2Output(ns("palavraChavePlotOutput")),spin="folding-cube",color="green"))
             ),
             
             box(
               title = "Documentos por ano de publicação", width = 12, solidHeader = TRUE, status = "primary",
               column(12,sliderInput(ns("anoPublicacaoSliderInput"),"Ano de publicação",min = 1980, max = 2022, value = c(2011, 2021),width="20%",sep="")),
               column(12,addSpinner(plotlyOutput(ns("publishDatePlotlyOutput")),spin="folding-cube",color="green"))
             ),
             
             box(
               title = "Documentos por programa de pós-graduação - PPG", width = 12, solidHeader = TRUE, status = "primary",
               column(12,numericInput(ns("programTopInput"),"Termos exibidos",10,width="20%")),
               column(12,addSpinner(plotlyOutput(ns("programPlotlyOutput")),spin="folding-cube",color="green"))
             ),
             
             box(
               title = "Autores com mais documentos", width = 12, solidHeader = TRUE, status = "primary",
               column(12,numericInput(ns("authorTopInput"),"Termos exibidos",10,width="20%")),
               column(12,addSpinner(plotlyOutput(ns("authorPlotOutput")),spin="folding-cube",color="green"))
             ),
             
             box(
               title = "Documentos por tipo", width = 12, solidHeader = TRUE, status = "primary",
               column(12,addSpinner(plotlyOutput(ns("tipoDocumentoPlotlyOutput")),spin="folding-cube",color="green")),
             ),
             
             box(
               title = "Documentos por idioma", width = 12, solidHeader = TRUE, status = "primary",
               column(12,addSpinner(plotlyOutput(ns("idiomaPlotlyOutput")),spin="folding-cube",color="green")),
             ),
             
             box(
               title = "Documentos por tipo de acesso", width = 12, solidHeader = TRUE, status = "primary",
               column(12,addSpinner(plotlyOutput(ns("tipoAcessoPlotlyOutput")),spin="folding-cube",color="green")),
             ),
             
             box(
               title = "Pesquisadores com mais orientações", width = 12, solidHeader = TRUE, status = "primary",
               column(12,numericInput(ns("pesquisadorTopInput"),"Termos exibidos",10,width="20%")),
               column(12,addSpinner(plotlyOutput(ns("pesquisadorPlotlyOutput")),spin="folding-cube",color="green")),
             ),
             
             box(
               title = "Instituições com mais documentos", width = 12, solidHeader = TRUE, status = "primary",
               column(12,numericInput(ns("instituicoesTopInput"),"Termos exibidos",10,width="20%")),
               column(12,addSpinner(plotlyOutput(ns("instituicoesPlotlyOutput")),spin="folding-cube",color="green")),
             )
             
      )
    )
  )
}

mod_graficos_server <- function(id, base) {
  shiny::moduleServer(
    id,
    function(input, output, session) {
      
      
      output$authorPlotOutput <- renderPlotly({ renderAuthorPlot(oasisbrBuscaUser(),input$authorTopInput) })
      
      output$palavraChavePlotOutput <- renderWordcloud2({ wordCloudPlot(oasisbrBuscaUser(),input$wordCloudTopInput) })
      
      output$subject_cnpqPlotlyOutput <- renderPlotly({ renderSubjectPlot(oasisbrBuscaUser(),input$subjectTopInput)})
      
      output$publishDatePlotlyOutput <- renderPlotly({renderAnoPublicacaoPlot(oasisbrBuscaUser(),input$anoPublicacaoSliderInput[1],input$anoPublicacaoSliderInput[2])})
      
      output$programPlotlyOutput <- renderPlotly({renderProgramPlot(oasisbrBuscaUser(),input$programTopInput)})
      
      output$idiomaPlotlyOutput <- renderPlotly({renderIdiomaPlot(oasisbrBuscaUser())})
      
      output$tipoDocumentoPlotlyOutput <- renderPlotly({renderTipoDocumentoPlot(oasisbrBuscaUser())})
      
      output$tipoAcessoPlotlyOutput <- renderPlotly({renderTipoAcessoPlot(oasisbrBuscaUser())})
      
      output$pesquisadorPlotlyOutput <- renderPlotly({render_pesquisadorPlot(oasisbrBuscaUser(),input$pesquisadorTopInput)})
      
      output$instituicoesPlotlyOutput <- renderPlotly({render_instituicoesPlot(oasisbrBuscaUser(),input$instituicoesTopInput)})
      
      
    }
  )
}