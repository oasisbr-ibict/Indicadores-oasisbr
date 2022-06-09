renderTipoDocumentoPlot <- function(x) {

#############################
## Tipo de documento
### Cria subconjunto
tipoDocumento_facet <- x$facets$format


shiny::validate(need(is.null(tipoDocumento_facet)==FALSE, paste("A sua busca não corresponde a nenhum registro.")))

traducao_tipoDocumento <- data.frame(valuePor = c("Artigo","Dissertação","Tese","Trabalho de conclusão de curso","Relatório","Capítulo de livro","Livro","NA","Artigo de conferência","Artigo (review)","Outros","Conjunto de dados","Artigo (working paper)"),
                                     value = c("article","masterThesis","doctoralThesis","bachelorThesis","report","bookPart","book","<NA>","conferenceObject","review","other","dataset","workingPaper"))



tipoDocumento_facet <- left_join(tipoDocumento_facet, traducao_tipoDocumento)


## Ordena coluna 'count'
tipoDocumento_facet <- tipoDocumento_facet[with(tipoDocumento_facet, order(-count)),]

## Retira registro 'sem informação' da coluna 'value'
tipoDocumento_facet <- tipoDocumento_facet[tipoDocumento_facet$translated!='sem informação',]


tipoDocumento_facet <- tipoDocumento_facet %>% mutate(pctTotal=count/x$resultCount)

## Treemap Idiomas

tipoDocumentoPlotly <- plot_ly(tipoDocumento_facet, labels = ~valuePor, 
                               values = ~count, 
                               parents = ~NA, 
                               type = 'treemap',
                               hovertext = ~ paste0(valuePor, ":", scales::comma(count),"<br>% do total:",scales::percent(pctTotal)),
                               hoverinfo = "text"
                              )

tipoDocumentoPlotly %>% 
  layout(font=t)
  

}
