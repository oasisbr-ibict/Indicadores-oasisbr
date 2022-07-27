wordCloudPlot <- function(x,y) {
  
## Validação para busca sem registros
shiny::validate(need(x$resultCount>0, paste("A sua busca não corresponde a nenhum registro.")))  
  
  
######################
## Palavra-chave ()
library(wordcloud2)

## Cria subconjunto
palavraChave <- x$facets$dc.subject.por.fl_str_mv
#View(palavraChave)


## Validação para informação vazia.
shiny::validate(need(is.null(palavraChave)==FALSE, paste("Não existem informações sobre esse(s) registro(s).")))

## Validação para informação vazia.
shiny::validate(need((y>=5 & y<=30), paste("O número de termo exibidos precisa estar entre 5 e 30.")))



palavraChave <- select(palavraChave, value, count)
palavraChave <- rename(palavraChave, word=value, freq=count)

palavraChavePlot <- wordcloud2a(head(palavraChave, n=y))

return(palavraChavePlot)

}