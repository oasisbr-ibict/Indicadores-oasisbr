renderProgramPlot <- function(x,y) {


## Validação para busca sem registros
shiny::validate(need(x$resultCount>0, paste("A sua busca não corresponde a nenhum registro.")))
  
#######################
## Documentos por programa de pós-graduação - PPG (top 10)
### Cria subconjunto
#x <- oasisbrDF
program <- x$facets$dc.publisher.program.fl_str_mv
#View(program)



## Validação para informação vazia.
shiny::validate(need(is.null(program)==FALSE, paste("Não existem informações sobre esse(s) registro(s).")))


## Validação para limite de termos exibidos
shiny::validate(need((y>0 & y<=25), paste("O número de termo exibidos precisa estar entre 0 e 25.")))



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
  aes(x = reorder(toupper(value), count), group = value, weight = count, 
      text=paste('<b style="font-family: Lato !important; align=left; font-size:14px; font-weight:400; color:gray">Programa de pós-graduação:</b>',
                 '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',value,"</b>",
                 "<br><br>",
                 '<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; color:gray">Total de documentos:</b>',
                 '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',comma(count),"</b>",
                 "<br><br>",
                 '<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; color:gray"">% do total:</b>',
                 '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',scales::percent(pctTotal),"</b>"
      )
      #text=paste("Programa de pós-graduação:",value,"<br>","Quantidade",comma(count),"<br>Porcentagem do total",pctTotal)
      
      ) +
  geom_bar(fill = "#112446") +
  scale_y_continuous(labels = scales::comma)+
  labs(x = "<b style='color:gray'>Programa de pós-graduação</b><br><br><b style='color:white'>.", 
       y = "<b style='color:gray; font-size:14px'>Total de documentos", title = NULL) +
  theme_minimal() +
  theme(axis.title.x = element_text(size = 14L)) + coord_flip()
programPlotly <- ggplotly(programPlot, tooltip="text")

programPlotly %>%
  layout(font=t, 
         margin = list(l=50,b = 55),
         hoverlabel=list(bgcolor="white")
  ) %>% config(displayModeBar = F) 

}

