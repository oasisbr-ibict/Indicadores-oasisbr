renderIdiomaPlot <- function(x) {

############################
## Idioma
## REPORTAR ERROS DE ESCRITA NESSE DF (EX 'PORTUGES')
### Cria subconjunto
idioma_facet <- x$facets$language


shiny::validate(need(is.null(idioma_facet)==FALSE, paste("A sua busca não corresponde a nenhum registro.")))


## Ordena coluna 'count'
idioma_facet <- idioma_facet[with(idioma_facet, order(-count)),]

## Adiciona % do total
idioma_facet <- idioma_facet %>% mutate(pctTotal=count/x$resultCount)

## Retira registro 'sem informação' da coluna 'value'
idioma_facet <- idioma_facet[idioma_facet$translated!='sem informação',]


## Treemap Idiomas

idiomaPlotly <- plot_ly(idioma_facet, labels = ~translated, 
                        values = ~count, 
                        hoverinfo = "text",
                        hovertext = paste('<b style="font-family: Lato !important; align=left; font-size:14px; font-weight:400;">Idioma:</b>',
                                          '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 ">',idioma_facet$translated,"</b>",
                                          "<br><br>",
                                          '<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; ">Total de documentos:</b>',
                                          '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 ">',scales::comma(idioma_facet$count),"</b>",
                                          "<br><br>",
                                          '<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; "">% do total:</b>',
                                          '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 ">',scales::percent(idioma_facet$pctTotal),"</b>"
                        ),
                        parents = ~NA, 
                        type = 'treemap') %>% layout(font=t) %>% config(displayModeBar = F) 
return(idiomaPlotly)

}
