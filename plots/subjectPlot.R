renderSubjectPlot <- function(x,y) {

## Área de conhecimento do CNPQ (dc.subject.cnpq.fl_str_mv)
### Cria subconjunto
subject_cnpq <- x$facets$dc.subject.cnpq.fl_str_mv
#subject_cnpq

shiny::validate(need(is.null(subject_cnpq)==FALSE, paste("A sua busca não corresponde a nenhum registro.")))

## Ordena coluna 'count'
subject_cnpq <- subject_cnpq[with(subject_cnpq, order(-count)),]

## Retira registro 'sem informação' da coluna 'value'
subject_cnpq <- subject_cnpq[subject_cnpq$value!='sem informação',]


## Seleciona top 10
subject_cnpq <- head(subject_cnpq, n=y)

#esquisser(author_facet)

## Gráfico de top 10 Área de conhecimento do CNPQ

subject_cnpqPlot <- ggplot(subject_cnpq) +
  aes(x = reorder(value, count), group = value, weight = count, 
      text=paste("Área de conhecimento:",value,"<br>","Quantidade",comma(count))) +
  geom_bar(fill = "#112446") +
  labs(x = "Área do conhecimento", 
       y = "Total de documentos", title = NULL) +
  theme_minimal() +
  theme(axis.title.x = element_text(size = 14L)) +
 # scale_x_continuous(labels = scales::comma) +
  coord_flip() 
ggplotly(subject_cnpqPlot, tooltip="text") 

}
