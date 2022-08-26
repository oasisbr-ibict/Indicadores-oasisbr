df_local <- fromJSON("http://localhost/vufind/api/v1/search?&type=AllFields&page=0&limit=0&sort=relevance&facet[]=institution")
total_de_documentos <<- df_local$resultCount