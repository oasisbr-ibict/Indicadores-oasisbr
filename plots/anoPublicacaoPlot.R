renderAnoPublicacaoPlot <- function(x,y,z) {
#######################
## Documentos por ano de publicação (publishDate)
#x <- oasisbrDF
### Cria subconjunto
publishDate <- x$facets$publishDate
#View(publishDate)


shiny::validate(need(is.null(publishDate)==FALSE, paste("A sua busca não corresponde a nenhum registro.")))


## Ordena coluna 'value' (Ano de publicação)
#publishDate <- publishDate[with(publishDate, order(-value)),]

## Retira registro 'sem informação' da coluna 'value'
publishDate <- publishDate[publishDate$value!='sem informação',]

## Adiciona coluna de % de total
publishDate <- publishDate %>% mutate(pctTotal=count/x$resultCount)

## Cria DF vazio para visualização por ano
#publishDateEmpty <- data.frame(value=as.character(c(min(publishDate$value):c(max(publishDate$value)))),yearSum=0)

publishDate$value <- as.integer(publishDate$value)

#publishDate <- left_join(publishDate,publishDateEmpty)



## Filtra período (2002-2022)
publishDate <- subset(publishDate, value %in% c(y:z))



## Gráfico de ano de publicação

publishDatePlot <- ggplot(publishDate) +
  aes(x = value, group = value, weight = count,
      text=paste("Ano de publicação:",value,"<br>","Quantidade",comma(count),"<br>% do total",scales::percent(pctTotal))) +
  geom_bar(fill = "#112446") +
  labs(x = "Ano de publicação", 
       y = "Total de documentos", title = NULL) +
  theme_minimal() +
  theme(axis.title.x = element_text(size = 14L))
publishDatePlotly <- ggplotly(publishDatePlot, tooltip="text")

publishDatePlotly %>% 
  layout(font=t,
         xaxis=list(title=list("Total de documentos",font=t)),
         yaxis=list(title=list("Ano de publicação",font=t))
  )

}
