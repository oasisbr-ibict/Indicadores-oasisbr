total_de_documentos <- fromJSON("http://localhost/vufind/api/v1/search?&type=AllFields&page=0&limit=0&sort=relevance")
total_de_documentos <- total_de_documentos$resultCount
