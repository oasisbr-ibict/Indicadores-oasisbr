renderSubjectPlot <- function(x,y) {

## Validação para busca sem registros
shiny::validate(need(x$resultCount>0, paste("A sua busca não corresponde a nenhum registro.")))  
  
  
## Área de conhecimento do CNPQ (dc.subject.cnpq.fl_str_mv)
### Cria subconjunto
subject_cnpq <- x$facets$dc.subject.cnpq.fl_str_mv


## Validação para informação vazia.
shiny::validate(need(is.null(subject_cnpq)==FALSE, paste("Não existem informações sobre esse(s) registro(s).")))

## Validação para informação vazia.
shiny::validate(need((y>0 & y<=25), paste("O número de termo exibidos precisa estar entre 0 e 25.")))



## Ordena coluna 'count'
subject_cnpq <- subject_cnpq[with(subject_cnpq, order(-count)),]

## Retira registro 'sem informação' da coluna 'value'
subject_cnpq <- subject_cnpq[subject_cnpq$value!='sem informação',]


##################################################
# 
# 
 subject_cnpq$tratado <- toupper(subject_cnpq$value)
 subject_cnpq$tratado <- gsub("CNPQ::","",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("CIENCIAS","CIÊNCIAS",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("SAUDE","SAÚDE",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("BIOLOGICAS","BIOLÓGICAS",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("EDUCACAO","EDUCAÇÃO",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("ELETRICA","ELÉTRICA",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("AGRARIAS","AGRÁRIAS",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("MECANICA","MECÂNICA",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("CIENCIA","CIÊNCIA",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("COMPUTACAO","COMPUTAÇÃO",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("MATEMATICA","MATEMÁTICA",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("FISICA","FÍSICA",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("QUIMICA","QUÍMICA",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("HISTORIA","HISTÓRIA",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("PRODUCAO","PRODUÇÃO",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("ADMINISTRACAO","ADMINISTRAÇÃO",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("COMUNICACAO","COMUNICAÇÃO",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("LINGUISTICA","LINGUÍSTICA",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("CI??NCIAS","CIÊNCIAS",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("COMPUTA????O","COMPUTAÇÃO",subject_cnpq$tratado)
 subject_cnpq$tratado <- gsub("::",": ",subject_cnpq$tratado)
 
 
 subject_cnpq <- subject_cnpq %>%
   group_by(tratado) %>%
   summarise(total = sum(count)) %>%
   arrange(desc(total))


###################################################

## Adiciona quebra de texto
#subject_cnpq$tratado <- stringr::str_wrap(subject_cnpq$tratado, 26)

# Adiciona % do total 
subject_cnpq <- subject_cnpq %>% mutate(pctTotal=total/x$resultCount)
 
 ## Seleciona valores TOP
subject_cnpq <- head(subject_cnpq, n=y)




## Gráfico de TOP'S Área de conhecimento do CNPQ

subject_cnpqPlot <- ggplot(subject_cnpq) +
  aes(x = reorder(tratado, total), group = tratado, weight = total, 
      text=paste('<b style="font-family: Lato !important; align=left; font-size:14px; font-weight:400; color:gray">Área do conhecimento CNPQ:</b>',
                 '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',tratado,"</b>",
                 "<br><br>",
                 '<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; color:gray">Total de documentos:</b>',
                 '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',comma(total),"</b>",
                 "<br><br>"
                # '<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; color:gray"">% do total:</b>',
                # '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',scales::percent(pctTotal),"</b>"
                 )) +
  geom_bar(fill = "#76B865") +
  scale_y_continuous(labels = scales::comma)+
  labs(x = "<b style='color:gray'>Área do conhecimento CNPQ</b><br><br><b style='color:white'>.", 
       y = "<b style='color:gray; font-size:14px'>Total de documentos", title = NULL) +
  theme_minimal() +
  theme(axis.title.x = element_text(size = 14L)) +
  coord_flip() 


ggplotly(subject_cnpqPlot, tooltip="text") %>% 
  
  layout(font=t, 
         margin = list(l=50,b = 55),
         hoverlabel=list(bgcolor="white")
         ) %>% config(displayModeBar = F) 

}
