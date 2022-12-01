require("pacman")

# Carrega pacotes
p_load(jsonlite,curl,dplyr,plotly,wordcloud2,ggplot2,esquisse,shinycustomloader,shinyWidgets,scales,stringr,tictoc,htmlwidgets)

# Importa funcões
source("functions/fonteGraficosPlotly.R",encoding="UTF-8")
source("functions/total_de_documentos.R",encoding="UTF-8")
source("functions/busca_oasisbr.R",encoding="UTF-8")


# Importa funções de gráficos
source("plots/area_conhecimento_CNPQ_Plot.R", encoding="UTF-8")
source("plots/authorPlot.R", encoding="UTF-8")
source("plots/wordCloudPlot.R", encoding="UTF-8")
source("plots/anoPublicacaoPlot.R", encoding="UTF-8")
source("plots/idiomaPlot.R", encoding="UTF-8")
source("plots/tipoDocumentoPlot.R", encoding="UTF-8")
source("plots/tipoAcessoPlot.R", encoding="UTF-8")
source("plots/programPlot.R", encoding="UTF-8")
source("plots/wordcloud2_bugfix.R", encoding="UTF-8")
source("plots/pesquisador_orientacoesPlot.R", encoding="UTF-8")
source("plots/titulo_da_fonte_plot.R")
source("plots/instituicoes_Plot.R", encoding="UTF-8")
source("plots/indicadoresEvolution.R", encoding="UTF-8")
source("plots/heatmap_Plot.R")



