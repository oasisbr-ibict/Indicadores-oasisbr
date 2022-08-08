## Funcao para download de busca feita pelo usuario

busca_oasisbr <- function(url="http://localhost/vufind/api/v1/search?",
                          lookfor,
                          type="AllFields",
                          sort="relevance",
                          parameters="&facet[]=author_facet&facet[]=dc.subject.por.fl_str_mv&facet[]=eu_rights_str_mv&facet[]=dc.publisher.program.fl_str_mv&facet[]=dc.subject.cnpq.fl_str_mv&facet[]=publishDate&facet[]=language&facet[]=format&facet[]=institution&facet[]=dc.contributor.advisor1.fl_str_mv") {
  
  query <- paste(url,"lookfor=",URLencode(lookfor),"&type=",type,"&sort=",sort,parameters,sep="")
  print(query)
  x <- fromJSON(query)
  
  return(x)
}