renderTipoAcessoPlot <- function(x) {

  
#############################
## Tipo de acesso
### Cria subconjunto
tipoAcesso_facet <- x$facets$eu_rights_str_mv


shiny::validate(need(is.null(tipoAcesso_facet)==FALSE, paste("A sua busca não corresponde a nenhum registro.")))

## Levar para arquivo separado com valores traduzidos (exemplo: import.R)
traducao_tipoAcesso <- data.frame(value=c("openAccess","embargoedAccess","restrictedAccess"),valuePor=c("Acesso aberto","Acesso embargado","Acesso restrito"))

tipoAcesso_facet <- left_join(traducao_tipoAcesso,tipoAcesso_facet)

## Ordena coluna 'count'
tipoAcesso_facet <- tipoAcesso_facet[with(tipoAcesso_facet, order(-count)),]

## Retira registro 'sem informação' da coluna 'value'
tipoAcesso_facet <- tipoAcesso_facet[tipoAcesso_facet$translated!='sem informação',]

## Grafico tipo de acesso


#data.frame(

tipoAcessoPlotly <- tipoAcesso_facet %>% 
  plot_ly(labels = ~valuePor, values = ~count) %>% 
  add_pie(hole = 0.6)

return(tipoAcessoPlotly)

}


oasisbrDF <- fromJSON("data/oasisbr_indicadores_gerais_31-03-2022.json")


