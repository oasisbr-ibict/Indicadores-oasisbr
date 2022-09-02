renderTipoAcessoPlot <- function(x) {

  
  
#x <- busca_oasisbr(lookfor="")
  
#############################
## Tipo de acesso
### Cria subconjunto
tipoAcesso_facet <- x$facets$eu_rights_str_mv


shiny::validate(need(is.null(tipoAcesso_facet)==FALSE, paste("A sua busca não corresponde a nenhum registro.")))

## Levar para arquivo separado com valores traduzidos (exemplo: import.R)
traducao_tipoAcesso <- data.frame(value=c("openAccess","embargoedAccess","restrictedAccess"),valuePor=c("Acesso aberto","Acesso embargado","Acesso restrito"),color=c("#76B865","#EA6A47","#CED2CC"))

tipoAcesso_facet <- left_join(traducao_tipoAcesso,tipoAcesso_facet)

## Ordena coluna 'count'
tipoAcesso_facet <- tipoAcesso_facet[with(tipoAcesso_facet, order(-count)),]

##
tipoAcesso_facet <- tipoAcesso_facet %>% mutate(pctTotal=count/x$resultCount)

## Retira registro 'sem informação' da coluna 'value'
tipoAcesso_facet <- tipoAcesso_facet[tipoAcesso_facet$translated!='sem informação',]


tipoAcesso_facet

## Grafico tipo de acesso


colors <- c("#76B865","#EA6A47","#CED2CC")

#data.frame(

tipoAcessoPlotly <- tipoAcesso_facet %>% 
  plot_ly(labels = ~valuePor, values = ~count, 
          marker = list(colors = colors),
          hovertext = paste('<b style="font-family: Lato !important; align=left; font-size:14px; font-weight:400;">Tipo de documento:</b>',
                            '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 ">',tipoAcesso_facet$valuePor,"</b>",
                            "<br><br>",
                            '<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; ">Total de documentos:</b>',
                            '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 ">',scales::comma(tipoAcesso_facet$count),"</b>",
                            "<br><br>"#,
                            #'<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; "">% do total:</b>',
                            #'<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 ">',scales::percent(tipoAcesso_facet$pctTotal),"</b>"
          ),
          hoverinfo = "text"
          ) %>% 
  #add_trace(marker = list(color = "rgba(255, 0, 0, 0.6)") )%>% 
  add_pie(hole = 0.6) %>% layout(font=t, legend = list(font = list(size = 14), orientation = 'h')) %>% config(displayModeBar = F) 

return(tipoAcessoPlotly)

}
