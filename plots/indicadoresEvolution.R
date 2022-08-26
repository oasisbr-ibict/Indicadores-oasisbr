library(jsonlite)
library(plotly)
library(scales)

## Importa dados da API
oasisbrEvolucao <- fromJSON("http://localhost:3000/api/v1/evolution-indicators")



## Cria novo dataframe com 'content'
content <- oasisbrEvolucao$content

## Transforma coluna 'createdAt' para formato de data.
content$createdAt <- as.Date(content$createdAt)

## Visualização usando o pacote 'esquisser'
#esquisser(content)

## Gráfico
indicadores_evolucao_plotly <<- ggplotly(
  
  ggplot(content) +
    aes(
      x = createdAt,
      y = numberOfDocuments,
      colour = sourceType
    ) +
    geom_line(size = 0.5) +
    geom_point(size=1)+
    scale_color_hue(direction = 1) +
    labs(
      x = "Ano",
      y = "Total de documentos",
      title = "",
      subtitle = "Subtítulo",
      caption = "Caption",
      color = "Tipo de fonte"
    ) +
    scale_y_continuous(labels = comma) +
    theme_minimal()
  
) %>% layout(font=t) %>% config(displayModeBar = F)


####


indicadores_evolucao_fontes_plotly <<- ggplotly(
  
  ggplot(content) +
    aes(
      x = createdAt,
      y = numberOfNetworks,
      colour = sourceType
    ) +
    geom_line(size = 0.5) +
    geom_point(size=1)+
    scale_color_hue(direction = 1) +
    labs(
      x = "Ano",
      y = "Total de documentos",
      title = "",
      subtitle = "Subtítulo",
      caption = "Caption",
      color = "Tipo de fonte"
    ) +
    scale_y_continuous(labels = comma) +
    theme_minimal()
  
) %>% layout(font=t) %>% config(displayModeBar = F)


