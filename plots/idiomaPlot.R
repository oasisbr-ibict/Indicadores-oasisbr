renderIdiomaPlot <- function(x) {

############################
## Idioma
## REPORTAR ERROS DE ESCRITA NESSE DF (EX 'PORTUGES')
### Cria subconjunto
idioma_facet <- x$facets$language


shiny::validate(need(is.null(idioma_facet)==FALSE, paste("A sua busca não corresponde a nenhum registro.")))


## Ordena coluna 'count'
idioma_facet <- idioma_facet[with(idioma_facet, order(-count)),]

## Retira registro 'sem informação' da coluna 'value'
idioma_facet <- idioma_facet[idioma_facet$translated!='sem informação',]


## Treemap Idiomas

idiomaPlotly <- plot_ly(idioma_facet, labels = ~translated, 
                        values = ~count, 
                        parents = ~NA, 
                        type = 'treemap')
return(idiomaPlotly)

}
