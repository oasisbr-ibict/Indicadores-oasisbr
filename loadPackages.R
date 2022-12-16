require("pacman")

# Carrega pacotes
p_load(jsonlite,curl,dplyr,plotly,wordcloud2,ggplot2,esquisse,shinycustomloader,shinyWidgets,scales,stringr,tictoc,htmlwidgets)

# Importa funcões
source("functions/busca_oasisbr.R",encoding="UTF-8")
source("functions/fonte_graficos_plotly.R",encoding="UTF-8")
source("functions/tipos_de_documento.R",encoding="UTF-8")

# Importa funções de gráficos
source("plots/ano_publicacao_plot.R", encoding="UTF-8")
source("plots/area_conhecimento_CNPQ_plot.R", encoding="UTF-8")
source("plots/author_plot.R", encoding="UTF-8")
source("plots/heatmap_plot.R")
source("plots/idioma_plot.R", encoding="UTF-8")
source("plots/instituicoes_plot.R", encoding="UTF-8")
source("plots/indicadores_evolucao_plot.R", encoding="UTF-8")
source("plots/pesquisador_orientacoes_plot.R", encoding="UTF-8")
source("plots/programa_plot.R", encoding="UTF-8")
source("plots/tipo_documento_plot.R", encoding="UTF-8")
source("plots/tipo_acesso_plot.R", encoding="UTF-8")
source("plots/titulo_da_fonte_plot.R")
source("plots/wordcloud_plot.R", encoding="UTF-8")
source("plots/wordcloud2_bugfix.R", encoding="UTF-8")





