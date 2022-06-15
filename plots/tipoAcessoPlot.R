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

##
tipoAcesso_facet <- tipoAcesso_facet %>% mutate(pctTotal=count/x$resultCount)

## Retira registro 'sem informação' da coluna 'value'
tipoAcesso_facet <- tipoAcesso_facet[tipoAcesso_facet$translated!='sem informação',]

## Grafico tipo de acesso


#data.frame(

tipoAcessoPlotly <- tipoAcesso_facet %>% 
  plot_ly(labels = ~valuePor, values = ~count,
          hovertext = paste('<b style="font-family: Lato !important; align=left; font-size:14px; font-weight:400;">Tipo de documento:</b>',
                            '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 ">',tipoAcesso_facet$valuePor,"</b>",
                            "<br><br>",
                            '<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; ">Total de documentos:</b>',
                            '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 ">',scales::comma(tipoAcesso_facet$count),"</b>",
                            "<br><br>",
                            '<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; "">% do total:</b>',
                            '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 ">',scales::percent(tipoAcesso_facet$pctTotal),"</b>"
          ),
          hoverinfo = "text"
          ) %>% 
  add_pie(hole = 0.6) %>% layout(font=t)

return(tipoAcessoPlotly)

}


oasisbrDF <- fromJSON("data/oasisbr_indicadores_gerais_31-03-2022.json")


