renderTipoAcessoPlot <- function(x) {

  
#############################
## Tipo de acesso
### Cria subconjunto
tipoAcesso_facet <- x$facets$eu_rights_str_mv


shiny::validate(need(is.null(tipoAcesso_facet)==FALSE, paste("A sua busca não corresponde a nenhum registro.")))


## Ordena coluna 'count'
tipoAcesso_facet <- tipoAcesso_facet[with(tipoAcesso_facet, order(-count)),]

## Retira registro 'sem informação' da coluna 'value'
tipoAcesso_facet <- tipoAcesso_facet[tipoAcesso_facet$translated!='sem informação',]

## Grafico tipo de acesso


tipoAcessoPlotly <- tipoAcesso_facet %>% 
  plot_ly(labels = ~translated, values = ~count) %>% 
  add_pie(hole = 0.6)

return(tipoAcessoPlotly)

}
