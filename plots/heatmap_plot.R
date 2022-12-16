render_heatmap_plot <- function(x,min,max,n_instituicoes) {


x <- x$facet_counts$facet_pivot$`publishDate,network_acronym_str`


for(i in 1:nrow(x)) {
  
  y <- as.integer(x$value[i])
  z <- data.frame(x$pivot[i])
  
  ano <- y
  instituicao <- z$value
  quantidade <- z$count
  
  
  if (i==1) {
   
    heatmap_data <- data.frame(instituicao,ano,quantidade)
    
  } else {
   
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
top_instituicoes <- head(top_instituicoes$instituicao,n=n_instituicoes)

# Subseta DF com heatmap
heatmap_data <- subset(heatmap_data, instituicao %in% top_instituicoes & ano %in% c(min:max))

# Subseta DF com instituicoes unicas
#heatmap_data <- subset(heatmap_data, instituicao %in% instituicoes_unicas)


heatmap <- ggplot(heatmap_data, aes(ano, instituicao))+theme_bw()+
  geom_tile(aes(fill=quantidade), colour="white")+
 # scale_fill_distiller(palette = "YlGnBu", direction = 1)+
  scale_fill_gradient(low = 'lightblue', high = 'red', space = 'Lab', na.value = 'white')+
  labs(title = "Heatmap de publicações por ano\n",
       x = "Ano de publicação",
       y = "Nome da Instituição")


heatmap_plotly <- ggplotly(heatmap)
ggplotly(heatmap)

}

################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
render_tipodoc_ano_plot <- function(x,min_ano,max_ano) {
  
  
  x <- x$facet_counts$facet_pivot$`publishDate,format`
  
  
  for(i in 1:nrow(x)) {
    
    y <- as.integer(x$value[i])
    z <- data.frame(x$pivot[i])
    
    ano <- y
    formato <- z$value
    quantidade <- z$count
    
    
    if (i==1) {
      
      data <- data.frame(formato,ano,quantidade)
      
    } else {
      
      data_i <- data.frame(formato,ano,quantidade)
      data <- rbind(data,data_i)
      
    }
    
  }
  
  
  # Cria coluna com totais por linha e total por coluna
  data <- data %>% group_by(ano) %>%
    mutate(totalAno = sum(quantidade)) %>% group_by(formato) %>%
    mutate(total_formato = sum(quantidade))
  
  # Cria variaveis com valor máximo e mínimo para ano de publicação
  #ano_minimo <- min(data$ano)
  #ano_maximo <- max(data$ano)
  
  # Top instituicoes
  #top_instituicoes <- unique(heatmap_data[,c("instituicao","totalInstituicao")])
  #top_instituicoes <- head(top_instituicoes$instituicao,n=n_instituicoes)
  
  # Subseta DF com heatmap
  data <- subset(data, ano %in% c(min_ano:max_ano))
  
  data <- ggplot(data) +
    aes(x = ano, y = quantidade, colour = formato) +
    geom_line(size = 0.5) +
    scale_color_hue(direction = 1) +
    labs(
      x = "Ano de publicação",
      y = "Quantidade de documentos",
      title = "Tipos de documento por ano de publicação"
    ) +
    theme_minimal()
  
  
  data_plotly <- ggplotly(data)
  ggplotly(data_plotly)
  
}

