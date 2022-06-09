# Limpeza de campo "cnpq subject"

#Remove "CNPQ::" do campo

oasisbrDF <- fromJSON("https://oasisbr.ibict.br/vufind/api/v1/search?&type=AllFields&page=0&limit=0&sort=relevance&facet[]=author_facet&facet[]=dc.subject.por.fl_str_mv&facet[]=eu_rights_str_mv&facet[]=dc.publisher.program.fl_str_mv&facet[]=dc.subject.cnpq.fl_str_mv&facet[]=publishDate&facet[]=language&facet[]=format&facet[]=institution&facet[]=dc.contributor.advisor1.fl_str_mv")

cnpq <- oasisbrDF$facets$dc.subject.cnpq.fl_str_mv

cnpq$tratado <- toupper(cnpq$value)
cnpq$tratado <- gsub("CNPQ::","",cnpq$tratado)
cnpq$tratado <- gsub("CIENCIAS","CIÊNCIAS",cnpq$tratado)
cnpq$tratado <- gsub("SAUDE","SAÚDE",cnpq$tratado)
cnpq$tratado <- gsub("BIOLOGICAS","BIOLÓGICAS",cnpq$tratado)
cnpq$tratado <- gsub("EDUCACAO","EDUCAÇÃO",cnpq$tratado)
cnpq$tratado <- gsub("ELETRICA","ELÉTRICA",cnpq$tratado)
cnpq$tratado <- gsub("AGRARIAS","AGRÁRIAS",cnpq$tratado)
cnpq$tratado <- gsub("MECANICA","MECÂNICA",cnpq$tratado)
cnpq$tratado <- gsub("CIENCIA","CIÊNCIA",cnpq$tratado)
cnpq$tratado <- gsub("COMPUTACAO","COMPUTAÇÃO",cnpq$tratado)
cnpq$tratado <- gsub("MATEMATICA","MATEMÁTICA",cnpq$tratado)
cnpq$tratado <- gsub("FISICA","FÍSICA",cnpq$tratado)
cnpq$tratado <- gsub("QUIMICA","QUÍMICA",cnpq$tratado)
cnpq$tratado <- gsub("HISTORIA","HISTÓRIA",cnpq$tratado)
cnpq$tratado <- gsub("PRODUCAO","PRODUÇÃO",cnpq$tratado)
cnpq$tratado <- gsub("ADMINISTRACAO","ADMINISTRAÇÃO",cnpq$tratado)
cnpq$tratado <- gsub("COMUNICACAO","COMUNICAÇÃO",cnpq$tratado)
cnpq$tratado <- gsub("LINGUISTICA","LINGUÍSTICA",cnpq$tratado)


cnpq_tratado <- cnpq %>%
  group_by(tratado) %>%
  summarise(total = sum(count)) %>%
  arrange(desc(total))


View(cnpq_tratado)
