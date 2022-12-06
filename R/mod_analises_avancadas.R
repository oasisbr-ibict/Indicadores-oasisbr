mod_analises_avancadas_UI <- function(id) {
  ns <- NS(id)
  tagList(
    # Sidebar
    
    sidebarPanel(
      selectInput(ns("analises_input"), "Selecionar análise:",
                  choices = c("clique_aqui","heatmap", "redes"),selected = "clique_aqui"),
      conditionalPanel(
        condition = "input.analises_input == 'heatmap'",ns=ns,
        column(12,sliderInput(ns("ano_heatmap_input"),
                              label = "Ano de publicação",
                              min = 1900, max = 2022, value = c(1900, 2022))),
        numericInput(ns("top_instituicoes"),"Qtde. de Instituicoes",min=1,max=133, value=80)
       # selectInput(ns("instituicoes_input"),"Selecionar instituicoes",choices = instituicoes_unicas,multiple = TRUE)
      )
    ),
    
    # Main Panel
    
    mainPanel(
      conditionalPanel(
        condition = "input.analises_input == 'heatmap'",ns=ns,
        column(12,fluidRow(plotlyOutput(ns("heatmap_output"),height="800px")))
      )

      
    )
    
  
  )
}

mod_analises_avancadas_Server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      

      

      
     # instituicoes_unicas <<- unique(heatmap_data$instituicao)
      
      output$heatmap_output <- renderPlotly(render_heatmap_plot(oasisbrBuscaUser_heatmap(),min=input$ano_heatmap_input[1],max=input$ano_heatmap_input[2],n_instituicoes=input$top_instituicoes))
      
    }
  )
}