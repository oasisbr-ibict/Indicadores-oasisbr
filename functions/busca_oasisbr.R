## Funcao para download de busca feita pelo usuario

busca_oasisbr <- function(url="http://localhost/vufind/api/v1/search?",
                          lookfor,
                          type="AllFields",
                          sort="relevance",
                          facet_parameters="&facet[]=author_facet&facet[]=dc.subject.por.fl_str_mv&facet[]=eu_rights_str_mv&facet[]=dc.publisher.program.fl_str_mv&facet[]=dc.subject.cnpq.fl_str_mv&facet[]=publishDate&facet[]=language&facet[]=format&facet[]=institution&facet[]=dc.contributor.advisor1.fl_str_mv&facet[]=network_name_str")
  {
  
  query <- paste(url,"lookfor=",URLencode(lookfor),"&type=",type,"&sort=",sort,facet_parameters,sep="")
  #print(query)
  x <- fromJSON(query)
  
  return(x)
}

# Função de busca para criar heatmap utilizando a funcao 'facet.pivot'
busca_oasisbr_heatmap <- function(url="http://172.16.17.42:8080/solr/biblio/select?facet.field=institution&facet=on&indent=on&facet.pivot=publishDate,network_acronym_str",
                                  q="*:*",
                                  rows="1",
                                  wt="json") {
  query <- paste(url,"&q=",URLencode(q),"&rows=",rows,"&wt=",wt,sep="")
  #print(query)
  x <- fromJSON(query)
  
  return(x)
}


busca_oasisbr_tipodoc_ano <- function(url="http://172.16.17.42:8080/solr/biblio/select?facet.field=institution&facet=on&indent=on&facet.pivot=publishDate,format",
                                  q="*:*",
                                  rows="1",
                                  wt="json") {
  query <- paste(url,"&q=",URLencode(q),"&rows=",rows,"&wt=",wt,sep="")
  #print(query)
  x <- fromJSON(query)
  
  return(x)
}

# heatmap_instituicoes <- function(x) {
#   
#   x <- x$facet_counts$facet_pivot$`publishDate,network_acronym_str`
#   
#   
#   for(i in 1:nrow(x)) {
#     
#     y <- as.integer(x$value[i])
#     z <- data.frame(x$pivot[i])
#     
#     ano <- y
#     instituicao <- z$value
#     quantidade <- z$count
#     
#     
#     if (i==1) {
#       #print(i)
#       heatmap_data <<- data.frame(instituicao,ano,quantidade)
#       
#     } else {
#      # print(i)
#       heatmap_data_i <- data.frame(instituicao,ano,quantidade)
#       heatmap_data <- rbind(heatmap_data,heatmap_data_i)
#       
#       
#     }
#     
#     instituicoes_unicas <- as.character(unique(heatmap_data$instituicao))
#     return(instituicoes_unicas)
#   }
#   
# }
# 
# 
# instituicoes_unicas <<- heatmap_instituicoes(x=busca_oasisbr_heatmap())
# 
# 
# #heatmap_solr_facet_pivot <- busca_oasisbr_heatmap()
# 
# #######################################################################################
# 
# heatmap_format_publishDate <- function(x) {
#   
#   x <- x$facet_counts$facet_pivot$`publishDate,format`
#   
#   
#   for(i in 1:nrow(x)) {
#     
#     y <- as.integer(x$value[i])
#     z <- data.frame(x$pivot[i])
#     
#     ano <- y
#     instituicao <- z$value
#     quantidade <- z$count
#     
#     
#     if (i==1) {
#       #print(i)
#       heatmap_data <<- data.frame(instituicao,ano,quantidade)
#       
#     } else {
#       # print(i)
#       heatmap_data_i <- data.frame(instituicao,ano,quantidade)
#       heatmap_data <- rbind(heatmap_data,heatmap_data_i)
#       
#       
#     }
#     
#     instituicoes_unicas <- as.character(unique(heatmap_data$instituicao))
#     return(instituicoes_unicas)
#   }
#   
# }
