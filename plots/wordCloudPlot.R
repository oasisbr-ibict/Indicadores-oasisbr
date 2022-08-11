wordCloudPlot <- function(x,y) {
  
## Validação para busca sem registros
shiny::validate(need(x$resultCount>0, paste("A sua busca não corresponde a nenhum registro.")))  

#x <- busca_oasisbr(lookfor="")
  
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

palavraChavePlot <- wordcloud2a(head(palavraChave, n=y), fontFamily = "Lato", size = .8, color=rep_len( c("#F8C300","#76B865", "#EA6A47"), nrow(palavraChave) ))
#palavraChavePlot <- wordcloud2a(palavraChave, color=rep_len( c("#F8C300","#76B865", "#EA6A47"), nrow(palavraChave) ))
#palavraChavePlot


return(palavraChavePlot)

}