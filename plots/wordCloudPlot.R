wordCloudPlot <- function(x,y) {
  

######################
## Palavra-chave ()
library(wordcloud2)

## Cria subconjunto
palavraChave <- x$facets$dc.subject.por.fl_str_mv
#View(palavraChave)


shiny::validate(need(is.null(palavraChave)==FALSE, 'A sua busca não corresponde a nenhum registro.'))


palavraChave <- select(palavraChave, value, count)
palavraChave <- rename(palavraChave, word=value, freq=count)

palavraChavePlot <- wordcloud2a(head(palavraChave, n=y))

return(palavraChavePlot)

}