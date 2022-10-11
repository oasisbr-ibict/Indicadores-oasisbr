set.seed(123)                                                     # Set seed for reproducibility
data <- matrix(rnorm(100, 0, 10), nrow = 10, ncol = 10)           # Create example data
colnames(data) <- paste0("col", 1:10)                             # Column names
rownames(data) <- paste0("row", 1:10)   

library(plotly)
plot_ly(z = data, type = "heatmap")   

library(dplyr)

teste <- busca_oasisbr(lookfor="")
View(teste)
x <- teste$facets
View(x)
x <- c(teste$facets$institution,teste$facets$publishDate)
View(x)




teste <- fromJSON("http://172.25.0.68:8080/solr/biblio2/select?facet.field=institution&facet=on&fq=educacao&indent=on&facet.pivot=publishDate,network_acronym_str&q=*:*&rows=1&wt=json")
x <- teste$facet_counts$facet_pivot$`publishDate,network_acronym_str`


for(i in 1:nrow(x)) {
  
  y <- as.integer(x$value[i])
  z <- data.frame(x$pivot[i])
  
  ano <- y
  instituicao <- z$value
  quantidade <- z$count
  
  
  if (i==1) {
    print(i)
    heatmap_data <- data.frame(instituicao,ano,quantidade)
    
  } else {
    print(i)
    heatmap_data_i <- data.frame(instituicao,ano,quantidade)
    heatmap_data <- rbind(heatmap_data,heatmap_data_i)
    
  }
  
  

}


# Cria coluna com totais por linha e total por coluna
heatmap_data <- heatmap_data %>% group_by(ano) %>%
mutate(totalAno = sum(quantidade)) %>% group_by(instituicao) %>%
  mutate(totalInstituicao = sum(quantidade))


# Reordena 
heatmap_data$instituicao <- reorder(heatmap_data$instituicao, heatmap_data$totalInstituicao)

# Cria variaveis com valor máximo e mínimo para ano de publicação
ano_minimo <- min(heatmap_data$ano)
ano_maximo <- max(heatmap_data$ano)

# Top instituicoes
top_instituicoes <- unique(heatmap_data[,c("instituicao","totalInstituicao")])
top_instituicoes <- head(top_instituicoes$instituicao,n=50)

# Subseta DF com heatmap
heatmap_data <- subset(heatmap_data, instituicao %in% top_instituicoes & ano %in% c(1920:2022))


ano_inst_heat <- ggplot(heatmap_data, aes(ano, instituicao))+theme_bw()+
  geom_tile(aes(fill=quantidade), colour="white")+
 # scale_fill_distiller(palette = "YlGnBu", direction = 1)+
  scale_fill_gradient(low = 'lightblue', high = 'red', space = 'Lab', na.value = 'white')+
  #scale_x_continuous(breaks=c(ano_minimo:ano_maximo))+
 # scale_x_continuous(breaks=c(2000:2022))+
 # theme(axis.text.x = element_text(vjust = 0.5, angle=75))+
  labs(title = "Heatmap de publicações por ano\n",
       x = "Ano de publicação",
       y = "Nome da Instituição")


ggplotly(ano_inst_heat)
