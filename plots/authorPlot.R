renderAuthorPlot <- function(x,y) {


  
author_facet <- x$facets$author_facet
#author_facet



shiny::validate(need(is.null(author_facet)==FALSE, 'A sua busca não corresponde a nenhum registro.'))



## Ordena coluna 'count'
author_facet <- author_facet[with(author_facet, order(-count)),]

## Retira registro 'sem informação' da coluna 'value'
author_facet <- author_facet[author_facet$value!='sem informação',]

## Seleciona top 10
author_facet <- head(author_facet, n=y)

#esquisser(author_facet)

## Gráfico de top 10 Autore(a)s

authorPlot <- ggplot(author_facet) +
  aes(x = reorder(value, count), group = value, weight = count, 
      text=paste("Autor(a):",value,"<br>","Quantidade",comma(count))) +
  geom_bar(fill = "#112446") +
  labs(x = "Nome do autor(a)", 
       y = "Total de documentos", title = NULL) +
  theme_minimal() +
  theme(axis.title.x = element_text(size = 14L)) +
  coord_flip()
return(ggplotly(authorPlot, tooltip="text"))

}
