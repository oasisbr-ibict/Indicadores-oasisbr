# Url do solr com Lista de todos campos
url_campos_oasisbr <- "http://172.25.0.68:8080/solr/biblio/select?indent=on&q=*:*&rows=0&wt=csv"

# Importa lista de todos os campos oasisbr
library(readr)
campos_oasisbr <- read_csv(url_campos_oasisbr)

# Quantidade de campos
length(names(campos_oasisbr))

# Lista de campos que contêm "dc.contributor" para a construção de análise de redes
url_campos_oasisbr_network <- "http://172.25.0.68:8080/solr/biblio/select?fl=dc.contributor*&indent=on&q=topic:cannabis&rows=3&wt=csv"
campos_oasisbr_network <- read_csv(url_campos_oasisbr_network)

# Quantidade de campos
length(names(campos_oasisbr_network))


sort(print(names(campos_oasisbr_network)))


## Subsetando campos com "author*", "advisor*", "referee*", "Orientador*", "orientador*, "Lattes"
url <- "http://172.25.0.68:8080/solr/biblio/select?fl=dc.contributor.author*,dc.contributor.advisor*,dc.contributor.referee*,dc.contributor.Orientador*,dc.contributor.orientador*,dc.contributor.Lattes*&indent=on&q=*:*&rows=300&wt=csv"

campos_oasisbr_network2 <- read_csv(url)
# Quantidade de campos
length(names(campos_oasisbr_network2))

setdiff(names(campos_oasisbr_network), names(campos_oasisbr_network2))



url2 <- "http://172.25.0.68:8080/solr/biblio/select?&indent=on&q=format:doctoralThesis&rows=1000&wt=json"
teste <- fromJSON(url2)
View(teste)

intersect(names(campos_oasisbr_network2), names(teste$response$docs))

teste$response$docs[,names(campos_oasisbr_network2)]

teste <- teste$response$docs

head(teste)

teste_redes <- #View(
            select(teste,
            #Instituicao
            institution,
            
            # Campos autor
            dc.contributor.author.fl_str_mv,
            dc.contributor.authorLattes.fl_str_mv,
            
            # Campos orientador
            dc.contributor.advisor1.fl_str_mv,
            dc.contributor.advisor1Lattes.fl_str_mv,
            
            # Campos banca
            dc.contributor.referee1.fl_str_mv,
            dc.contributor.referee1Lattes.fl_str_mv)
            #)

View(teste_redes)


names(teste)


teste %>% group_by(dc.contributor.author.fl_str_mv,dc.contributor.authorLattes.fl_str_mv)
