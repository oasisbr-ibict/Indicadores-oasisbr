renderAnoPublicacaoPlot <- function(x,y,z) {
#######################
## Documentos por ano de publicação (publishDate)
### Cria subconjunto
publishDate <- x$facets$publishDate
#View(publishDate)


shiny::validate(need(is.null(publishDate)==FALSE, paste("A sua busca não corresponde a nenhum registro.")))



## Ordena coluna 'value' (Ano de publicação)
#publishDate <- publishDate[with(publishDate, order(-value)),]

## Retira registro 'sem informação' da coluna 'value'
publishDate <- publishDate[publishDate$value!='sem informação',]

## Filtra período (2002-2022)
publishDate <- subset(publishDate, value %in% c(y:z))

#esquisser(author_facet)

## Gráfico de ano de publicação

publishDatePlot <- ggplot(publishDate) +
  aes(x = value, group = value, weight = count,
      text=paste("Ano de publicação:",value,"<br>","Quantidade",comma(count))) +
  geom_bar(fill = "#112446") +
  labs(x = "Ano de publicação", 
       y = "Total de documentos", title = NULL) +
  theme_minimal() +
  theme(axis.title.x = element_text(size = 14L))
publishDatePlotly <- ggplotly(publishDatePlot, tooltip="text")

return(publishDatePlotly)

}
