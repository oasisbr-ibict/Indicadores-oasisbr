

"https://oasisbr.ibict.br/vufind/api/v1/"
"search?&type=AllFields"
"&filter[]=institution:'RCAAP'"
"&page=0"
"&limit=0"
"&sort=relevance"
"&facet[]=author_facet&facet[]=dc.subject.por.fl_str_mv&facet[]=eu_rights_str_mv&facet[]=dc.publisher.program.fl_str_mv&facet[]=dc.subject.cnpq.fl_str_mv&facet[]=publishDate&facet[]=language&facet[]=format&facet[]=institution&facet[]=dc.contributor.advisor1.fl_str_mv"

oasisbrFilter <- fromJSON(paste('https://oasisbr.ibict.br/vufind/api/v1/search?&type=AllFields&filter[]=institution:"RCAAP"&page=0&limit=0&sort=relevance&facet[]=author_facet&facet[]=dc.subject.por.fl_str_mv&facet[]=eu_rights_str_mv&facet[]=dc.publisher.program.fl_str_mv&facet[]=dc.subject.cnpq.fl_str_mv&facet[]=publishDate&facet[]=language&facet[]=format&facet[]=institution&facet[]=dc.contributor.advisor1.fl_str_mv',sep=""))
View(oasisbrFilter)
