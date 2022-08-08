#ano_de_publicacao <- fromJSON("http://172.25.0.68:8080/solr/biblio2/select?facet.field=publishDate&facet=on&fl=publishDate&search?lookfor='cannabis'&type=AllFields&indent=on&q=*:*&wt=json")
ano_de_publicacao <- fromJSON("http://172.25.0.68:8080/solr/biblio2/select?facet.field=publishDate&facet.field=institution&facet=on&fl=publishDate&indent=on&q=*:*&fq=&wt=json")

View(ano_de_publicacao)

x <- ano_de_publicacao$facet_counts$facet_fields$publishDate

# Manipulações
x <- x %>% matrix(ncol=2, byrow=TRUE) %>% data.frame() %>% 
  rename(publishDate=X1,count=X2) %>% mutate(count=as.numeric(as.character(count)), publishDate=ISOdate(publishDate, 1, 1))


# Filtro
ano_de_publicacao <- filter(x, publishDate < '2022-01-01' & publishDate > '0000-01-01')


# Gráfico ggplot
ano_de_publicacao_plot <- ggplot(ano_de_publicacao) +
  aes(x = publishDate, y = count) +
  geom_line(size = 0.5, colour = "#4682B4") +
  labs(
    x = "Ano de publicação",
    y = "Quantidade de documentos",
    title = "Quantidade de documentos por ano"
  ) +
  scale_y_continuous(labels = scales::comma)+
  theme_minimal()


# Gráfico ggplotly
ggplotly(ano_de_publicacao_plot)