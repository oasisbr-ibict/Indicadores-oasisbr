# network_name_str

render_titulo_fonte_Plot <- function(x,y) {
  
  ## Validação para busca sem registros
  shiny::validate(need(x$resultCount>0, paste("A sua busca não corresponde a nenhum registro.")))  
  
  titulo_fonte_facet <- x$facets$network_name_str
  #author_facet
  
  ## Validação para informação vazia.
  shiny::validate(need(is.null(titulo_fonte_facet)==FALSE, paste("Não existem informações sobre esse(s) registro(s).")))
  
  
  ## Validação para número de termos exibidos
  shiny::validate(need((y>0 & y<=25), paste("O número de termo exibidos precisa estar entre 0 e 25.")))
  
  
  ## Ordena coluna 'count'
  titulo_fonte_facet <- titulo_fonte_facet[with(titulo_fonte_facet, order(-count)),]
  
  ## Retira registro 'sem informação' da coluna 'value'
  titulo_fonte_facet <- titulo_fonte_facet[titulo_fonte_facet$value!='sem informação',]
  
  ## Adiciona % do total
  titulo_fonte_facet <- titulo_fonte_facet %>% mutate(pctTotal=count/x$resultCount)
  
  ## Seleciona top 10
  titulo_fonte_facet <- head(titulo_fonte_facet, n=y)
  
  titulo_fonte_facet$color <- "#76B865"
  
  
  titulo_fonte_facet$url <- "http://google.com"
  
  
  ## Gráfico de top 10 Autore(a)s
  
  titulo_fonte_Plot <- ggplot(titulo_fonte_facet) +
    aes(x = reorder(value, count), group = value, weight = count, 
        text=paste('<b style="font-family: Lato !important; align=left; font-size:14px; font-weight:400; color:gray">Título da fonte:</b>',
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
         y = "<b style='color:gray; font-size:14px'>Total de documentos", 
         title = NULL) +
    
    theme_minimal() +
    theme(axis.title.x = element_text(size = 14L)) +
    coord_flip()
  
  titulo_fonte_Plot <- ggplotly(titulo_fonte_Plot, tooltip="text")
  
  titulo_fonte_Plot <- titulo_fonte_Plot %>%
    
    layout(font=t, 
           margin = list(l=50,b = 55),
           hoverlabel=list(bgcolor="white")
    ) %>% config(displayModeBar = F) 
  
  # Add URL data to plot
  titulo_fonte_Plot$x$data[[1]]$customdata <- titulo_fonte_facet$url
  
  # JS function to make a tab open when clicking on a specific bar
  onRender(
    titulo_fonte_Plot,
    "
    function(el,x){
    el.on('plotly_click', function(d) {
    var websitelink = d.points[0].customdata;
    window.open(websitelink);
    });
    }
    ")
  
  
  
  
}
