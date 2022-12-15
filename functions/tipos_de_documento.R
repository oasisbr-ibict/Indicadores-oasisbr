tipos_de_documento <- function(x) {
  
  ## Tipo de documento
  tipoDocumento_facet <- x$facets$format
  
  ## Validação para resultado da busca igual a zero
  shiny::validate(need(is.null(tipoDocumento_facet)==FALSE, paste("0")))
  
  traducao_tipoDocumento <- data.frame(valuePor = c("Artigo","Dissertação","Tese","Trabalho de conclusão de curso","Relatório","Capítulo de livro","Livro","NA","Artigo de conferência","Artigo (review)","Outros","Conjunto de dados","Artigo (working paper)"),
                                       value = c("article","masterThesis","doctoralThesis","bachelorThesis","report","bookPart","book","<NA>","conferenceObject","review","other","dataset","workingPaper"))
  
  tipoDocumento_facet <- left_join(tipoDocumento_facet, traducao_tipoDocumento, by="value")
  
  ## Ordena coluna 'count'
  tipoDocumento_facet <- tipoDocumento_facet[with(tipoDocumento_facet, order(-count)),]
  
  ## Retira registro 'sem informação' da coluna 'value'
  tipoDocumento_facet <- tipoDocumento_facet[tipoDocumento_facet$translated!='sem informação',]
  
  ## Adiciona % do total
  tipoDocumento_facet <- tipoDocumento_facet %>% mutate(pctTotal=count/x$resultCount)
  
  return(tipoDocumento_facet)
  
}


total_documento <- function(x,y) {
  
  z <- select(subset(x, value %in% y),count)
  
  if (nrow(z)==0) { 
    
    return(0) 
    
    } else { 
      
      return(scales::comma(sum(z)))
    
  }
  
  }

