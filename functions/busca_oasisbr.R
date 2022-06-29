#parameters <- "sort=relevance&facet[]=author_facet&facet[]=dc.subject.por.fl_str_mv&facet[]=eu_rights_str_mv&facet[]=dc.publisher.program.fl_str_mv&facet[]=dc.subject.cnpq.fl_str_mv&facet[]=publishDate&facet[]=language&facet[]=format&facet[]=institution&facet[]=dc.contributor.advisor1.fl_str_mv"


####
busca_oasisbr <- function(url="http://localhost/vufind/api/v1/search?",
                          lookfor,
                          type="AllFields",
                          parameters="sort=relevance&facet[]=author_facet&facet[]=dc.subject.por.fl_str_mv&facet[]=eu_rights_str_mv&facet[]=dc.publisher.program.fl_str_mv&facet[]=dc.subject.cnpq.fl_str_mv&facet[]=publishDate&facet[]=language&facet[]=format&facet[]=institution&facet[]=dc.contributor.advisor1.fl_str_mv") {
  
  x <- fromJSON(paste(url,"lookfor=",lookfor,"&type=",type,parameters,sep=""))
  
  return(x)
}
####



#busca_teste <- busca_oasisbr(lookfor="cannabis")
#View(busca_teste)