mod_graficos_evolucao_UI <- function(id) {
  ns <- NS(id)
  tagList(
    
    fluidRow(
      sliderInput("ano_evolucao_input",
                  label = "Ano",
                  min = 2017, max = 2022, value = c(2017, 2022), sep=""),
      box(title = "Número de documentos por mês", width = 12, solidHeader = TRUE, status = "primary",
        column(12,addSpinner(plotlyOutput(ns("evolucao_documentos_PlotlyOutput"),height="300px"),spin="folding-cube",color="green")),height = "450px"
      ),
      
      box(title = "Número de fontes por mês", width = 12, solidHeader = TRUE, status = "primary",
          column(12,addSpinner(plotlyOutput(ns("evolucao_fontes_PlotlyOutput"),height="300px"),spin="folding-cube",color="green")),height = "450px"
      ))
  
  )
}

mod_graficos_evolucao_Server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      output$evolucao_documentos_PlotlyOutput <- renderPlotly({ indicadores_evolucao_plotly })
      
      output$evolucao_fontes_PlotlyOutput <- renderPlotly({ indicadores_evolucao_fontes_plotly })
      
    }
  )
}


