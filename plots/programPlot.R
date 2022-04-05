renderProgramPlot <- function(x,y) {

#######################
## Documentos por programa de pós-graduação - PPG (top 10)
### Cria subconjunto
program <- x$facets$dc.publisher.program.fl_str_mv
#View(program)

shiny::validate(need(is.null(program)==FALSE, paste("A sua busca não corresponde a nenhum registro.")))


## Retira registro 'sem informação' da coluna 'value'
program <- program[program$value!='sem informação',]

## Seleciona top 10
program <- head(program, n=y)

## Gráfico de top 10 Autore(a)s

programPlot <- ggplot(program) +
  aes(x = reorder(value, count), group = value, weight = count, 
      text=paste("Programa de pós-graduação:",value,"<br>","Quantidade",comma(count))) +
  geom_bar(fill = "#112446") +
  labs(x = "Programa de pós-graduação", 
       y = "Total de documentos", title = NULL) +
  theme_minimal() +
  theme(axis.title.x = element_text(size = 14L)) + coord_flip()
programPlotly <- ggplotly(programPlot, tooltip="text")

return(programPlotly)

}
