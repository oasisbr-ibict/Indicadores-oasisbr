renderProgramPlot <- function(x,y) {

#######################
## Documentos por programa de pós-graduação - PPG (top 10)
### Cria subconjunto
#x <- oasisbrDF
program <- x$facets$dc.publisher.program.fl_str_mv
#View(program)

shiny::validate(need(is.null(program)==FALSE, paste("A sua busca não corresponde a nenhum registro.")))


## Retira registro 'sem informação' da coluna 'value'
program <- program[program$value!='sem informação',]


## Adiciona coluna de % de total
program <- program %>% mutate(pctTotal=count/x$resultCount)

## Cria DF vazio para visualização por ano
#publishDateEmpty <- data.frame(value=as.character(c(min(publishDate$value):c(max(publishDate$value)))),yearSum=0)

#program$value <- as.integer(program$value)




## Seleciona top 10
program <- head(program, n=y)

## Programa

programPlot <- ggplot(program) +
  aes(x = reorder(value, count), group = value, weight = count, 
      text=paste("Programa de pós-graduação:",value,"<br>","Quantidade",comma(count),"<br>Porcentagem do total",pctTotal)) +
  geom_bar(fill = "#112446") +
  labs(x = "Programa de pós-graduação", 
       y = "Total de documentos", title = NULL) +
  theme_minimal() +
  theme(axis.title.x = element_text(size = 14L)) + coord_flip()
programPlotly <- ggplotly(programPlot, tooltip="text")

programPlotly %>%
  layout(font=t,
         xaxis=list(title=list("Total de documentos",font=t)),
         yaxis=list(title=list("Programa de pós-graduação",font=t))
  )

}

