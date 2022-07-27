renderAnoPublicacaoPlot <- function(x,y,z) {
  
  
  
## Validação para busca sem registros
shiny::validate(need(x$resultCount>0, paste("A sua busca não corresponde a nenhum registro.")))  

#######################
## Documentos por ano de publicação (publishDate)
#x <- oasisbrDF
### Cria subconjunto
publishDate <- x$facets$publishDate
#View(publishDate)


## Validação para informação vazia.
shiny::validate(need(is.null(publishDate)==FALSE, paste("Não existem informações sobre esse(s) registro(s).")))


## Ordena coluna 'value' (Ano de publicação)
#publishDate <- publishDate[with(publishDate, order(-value)),]

## Retira registro 'sem informação' da coluna 'value'
publishDate <- publishDate[publishDate$value!='sem informação',]

## Adiciona coluna de % de total
publishDate <- publishDate %>% mutate(pctTotal=count/x$resultCount)

## Cria DF vazio para visualização por ano
#publishDateEmpty <- data.frame(value=as.character(c(min(publishDate$value):c(max(publishDate$value)))),yearSum=0)

publishDate$value <- as.integer(publishDate$value)

#publishDate <- left_join(publishDate,publishDateEmpty)



## Filtra período (2002-2022)
publishDate <- subset(publishDate, value %in% c(y:z))



## Gráfico de ano de publicação

publishDatePlot <- ggplot(publishDate) +
  aes(x = value, group = value, weight = count,
      
      text=paste('<b style="font-family: Lato !important; align=left; font-size:14px; font-weight:400; color:gray">Ano de publicação:</b>',
                 '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',value,"</b>",
                 "<br><br>",
                 '<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; color:gray">Quantidade de documentos:</b>',
                 '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',comma(count),"</b>",
                 "<br><br>",
                 '<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; color:gray"">% do total:</b>',
                 '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',scales::percent(pctTotal),"</b>"
      )
      
      
      ) +
  geom_bar(fill = "#112446") +
  labs(x = "<b style='color:gray; font-size:14px'>Ano de publicação</b><br><b style='color:white'>.", 
       y = "<b style='color:gray; font-size:14px'>Total de documentos<br><b style='color:white'>.", title = NULL) +
  theme_minimal() +
  scale_y_continuous(labels = scales::comma)+
  scale_x_continuous(breaks=min(publishDate$value):max(publishDate$value))+
  #scale_x_discrete()+
  theme(axis.title.x = element_text(size = 14L))
publishDatePlotly <- ggplotly(publishDatePlot, tooltip="text")

publishDatePlotly %>% 
  layout(font=t, hoverlabel=list(bgcolor="white")) %>% config(displayModeBar = F) 
  

}


