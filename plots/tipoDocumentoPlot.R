renderTipoDocumentoPlot <- function(x) {

#############################
## Tipo de documento
### Cria subconjunto
tipoDocumento_facet <- x$facets$format



shiny::validate(need(is.null(tipoDocumento_facet)==FALSE, paste("A sua busca não corresponde a nenhum registro.")))



## Ordena coluna 'count'
tipoDocumento_facet <- tipoDocumento_facet[with(tipoDocumento_facet, order(-count)),]

## Retira registro 'sem informação' da coluna 'value'
tipoDocumento_facet <- tipoDocumento_facet[tipoDocumento_facet$translated!='sem informação',]

## Treemap Idiomas

tipoDocumentoPlotly <- plot_ly(tipoDocumento_facet, labels = ~translated, 
                               values = ~count, 
                               parents = ~NA, 
                               type = 'treemap')

return(tipoDocumentoPlotly)

}
