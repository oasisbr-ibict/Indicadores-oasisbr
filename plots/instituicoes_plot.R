render_instituicoesPlot <- function(x,y) {
  
  ## Validação para busca sem registros
  shiny::validate(need(x$resultCount>0, paste("A sua busca não corresponde a nenhum registro.")))  
  
  #x <- busca_oasisbr(lookfor="")
  instituicoes_facet <- x$facets$institution
  
  ## Validação para informação vazia.
  shiny::validate(need(is.null(instituicoes_facet)==FALSE, paste("Não existem informações sobre esse(s) registro(s).")))
  
  
  ## Validação para número de termos exibidos
  shiny::validate(need((y>0 & y<=25), paste("O número de termo exibidos precisa estar entre 0 e 25.")))
  
  
  ## Ordena coluna 'count'
  instituicoes_facet <- instituicoes_facet[with(instituicoes_facet, order(-count)),]
  
  ## Retira registro 'sem informação' da coluna 'value'
  instituicoes_facet <- instituicoes_facet[instituicoes_facet$value!='sem informação',]
  
  ## Adiciona % do total
  instituicoes_facet <- instituicoes_facet %>% mutate(pctTotal=count/x$resultCount)
  
  ## Seleciona top 10
  instituicoes_facet <- head(instituicoes_facet, n=y)
  
  instituicoes_facet$color <- "#76B865"
  
  # Remove string '?' de coluna de 'href', com hyperlink
  instituicoes_facet$href <- sub("?","",instituicoes_facet$href,fixed=TRUE)
  

  # IMPORTANTE/BUG: Ordena coluna com link de referência para documentos dentro do grafo plotly
  instituicoes_facet <- instituicoes_facet[order(instituicoes_facet$href),]
  
  ## Gráfico de top 10 Autore(a)s
  
  instituicoesPlot <- ggplot(instituicoes_facet) +
    aes(x = reorder(value, count), group = value, weight = count, 
        text=paste('<b style="font-family: Lato !important; align=left; font-size:14px; font-weight:400; color:gray">Instituição:</b>',
                   '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',value,"</b>",
                   "<br><br>",
                   '<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; color:gray">Total de documentos:</b>',
                   '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',comma(count),"</b>",
                   "<br><br>")
    ) +
    geom_bar(fill = "#76B865") +
    
    scale_y_continuous(labels = scales::comma)+
    labs(x="",
        #x = "<b style='color:gray'>Instituição</b><br><br><b style='color:white'>.", 
         y = "<b style='color:gray; font-size:14px'>Total de documentos", title = NULL) +
    
    theme_minimal() +
    theme(axis.title.x = element_text(size = 14L)) +
    coord_flip()
  
  instituicoesPlot <- ggplotly(instituicoesPlot, tooltip="text",customdata = "href", source="teste")
  
  instituicoesPlot <- instituicoesPlot %>%
    
    layout(font=t, 
           margin = list(l=50,b = 55),
           hoverlabel=list(bgcolor="white")
    ) %>% config(displayModeBar = F) 
  

  
  # Adiciona a url dos documentos ao gráfico
  instituicoesPlot$x$data[[1]]$customdata <- paste("https://oasisbr.ibict.br/vufind/Search/Results?lookfor=",texto_reactive(),"&",instituicoes_facet$href,sep="")
  
  # Funcção em JS para abrir uma aba quando houver clique numa barra específica
  onRender(
    instituicoesPlot,
    "
    function(el,x){
    el.on('plotly_click', function(d) {
    var websitelink = d.points[0].customdata;
    window.open(websitelink);
    });
    }
    ")
  
  
  
  
}
