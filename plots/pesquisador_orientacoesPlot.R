render_pesquisadorPlot <- function(x,y) {
  
 #x <- oasisbrDF
  
  pesquisador_facet <- x$facets$dc.contributor.advisor1.fl_str_mv
  #author_facet
  
  # Adicionar mensagem de erro caso não exista informação (verificar quantidade de registros diferente de zero)
  shiny::validate(need(is.null(pesquisador_facet)==FALSE, 'A sua busca não corresponde a nenhum registro.'))
  
  
  ## Ordena coluna 'count'
  pesquisador_facet <- pesquisador_facet[with(pesquisador_facet, order(-count)),]
  
  ## Retira registro 'sem informação' da coluna 'value'
  pesquisador_facet <- pesquisador_facet[pesquisador_facet$value!='sem informação',]
  
  ## Adiciona % do total
  pesquisador_facet <- pesquisador_facet %>% mutate(pctTotal=count/x$resultCount)
  
  ## Seleciona top 10
  pesquisador_facet <- head(pesquisador_facet, n=y)
  
  #esquisser(author_facet)
  
  ## Gráfico de top 10 Autore(a)s
  
  pesquisadorPlot <- ggplot(pesquisador_facet) +
    aes(x = reorder(value, count), group = value, weight = count, 
        text=paste('<b style="font-family: Lato !important; align=left; font-size:14px; font-weight:400; color:gray">Pesquisador(a):</b>',
                   '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',value,"</b>",
                   "<br><br>",
                   '<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; color:gray">Total de documentos:</b>',
                   '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',comma(count),"</b>",
                   "<br><br>",
                   '<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; color:gray"">% do total:</b>',
                   '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',scales::percent(pctTotal),"</b>"
        )
        #text=paste("Autor(a):",value,"<br>","Quantidade",comma(count))
    ) +
    geom_bar(fill = "#112446") +
    
    scale_y_continuous(labels = scales::comma)+
    labs(x = "<b style='color:gray'>Pesquisador(a)</b><br><br><b style='color:white'>.", 
         y = "<b style='color:gray; font-size:14px'>Total de documentos", title = NULL) +
    
    theme_minimal() +
    theme(axis.title.x = element_text(size = 14L)) +
    coord_flip()
  
  pesquisadorPlot <- ggplotly(pesquisadorPlot, tooltip="text")
  
  pesquisadorPlot %>%
    
    layout(font=t, 
           margin = list(l=50,b = 55),
           hoverlabel=list(bgcolor="white")
    ) %>% config(displayModeBar = F) 
  
  
  
  
}
