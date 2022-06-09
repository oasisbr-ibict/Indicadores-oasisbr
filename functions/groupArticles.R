oasisbrDF <- fromJSON(paste("https://oasisbr.ibict.br/vufind/api/v1/search?&type=AllFields&page=0&limit=0&sort=relevance&facet[]=author_facet&facet[]=dc.subject.por.fl_str_mv&facet[]=eu_rights_str_mv&facet[]=dc.publisher.program.fl_str_mv&facet[]=dc.subject.cnpq.fl_str_mv&facet[]=publishDate&facet[]=language&facet[]=format&facet[]=institution&facet[]=dc.contributor.advisor1.fl_str_mv",sep=""))
View(oasisbrDF)


teste <- oasisbrDF$facets$format

teste$group <- ifelse(teste$translated %in% c("Article", "Review", "Working paper","Conference object"), "Article", teste$translated)

testePlotly <- plot_ly(teste,
                               labels = ~translated, 
                               values = ~count, 
                               parents = ~group, 
                               type = 'treemap')


testePlotly


View(teste)

rename(oasisbrDF$facets$format, group = `group[,value]`)


renderTipoDocumentoPlot <- function(x) {
  
  #############################
  ## Tipo de documento
  ### Cria subconjunto
  tipoDocumento_facet <- x$facets$format
  
  
  tipoDocumento_facet$group <- ifelse(tipoDocumento_facet$translated %in% c("Article", "Review", "Working paper","Conference object"), "Article", tipoDocumento_facet$translated)
  
  
  ## Ordena coluna 'count'
  tipoDocumento_facet <- tipoDocumento_facet[with(tipoDocumento_facet, order(-count)),]
  
  ## Retira registro 'sem informação' da coluna 'value'
  tipoDocumento_facet <- tipoDocumento_facet[tipoDocumento_facet$translated!='sem informação',]
  
  ## Treemap Idiomas
  
  tipoDocumentoPlotly <- plot_ly(tipoDocumento_facet,
                                 labels = ~translated, 
                                 values = ~count, 
                                 parents = ~group, 
                                 type = 'treemap')
  
  return(tipoDocumentoPlotly)
  
}


renderTipoDocumentoPlot(oasisbrDF)
