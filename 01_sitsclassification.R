# Título: Classificação de Séries Temporais de Imagens de Satélite em 6 passos!
# Objetivo: Apresentação do Software R SITS.
# Elaboração: Ana Larissa Freitas - Dados & Geo.
# Referência: https://github.com/e-sensing/sitsnotebooks/blob/main/SBSR_2025/classification-of-raster-data-cubes.ipynb.

# Instalando SITS
# install.packages("sits")

# Carregando SITS
library(sits)

# Definindo diretório
data_dir <- "~/sits_ana/"

################################################################################
####################### Preparando os Cubos de dados ###########################
################################################################################

cube <- sits_cube(
  # Provedor
  source = "BDC",
  
  # Coleção
  collection = "SENTINEL-2-16D",
  
  # Extensão espacial das amostras a serem utilizadas
  roi = "~/sits_ana/roi_cube.shp",
  
  # Extensão temporal
  start_date = "2019-09-30",
  end_date = "2020-09-29"
)

################################################################################
########################## Preparando as Amostras ##############################
################################################################################

# Carregando amostras - Oldoni et al. (2020) - https://doi.org/10.1016/j.dib.2020.106553
samples <- sf::st_read("~/sits_ana/LEM_samples.gpkg")

# Lendo amostras
print(head(samples))

# Cores para cada rótulo
color_table <- readRDS(url("https://github.com/e-sensing/sitsnotebooks/raw/refs/heads/main/SBSR_2025/data/raw/colors/colors_lem.rds"))

# Definindo as cores
sits_colors_set(colors = color_table, legend = "LEM")

# Visualizando as amostras
sits_view(samples)

################################################################################
####################### Extraindo as Séries Temporais ##########################
################################################################################

samples_ts <- sits_get_data(
  cube       = cube,
  samples    = samples,
  multicores = 8
)

# Características da séries
summary(samples_ts)

################################################################################
################ Visualizando os Padrões das Séries Temporais ##################
################################################################################

# Selecionando uma banda
samples_indexes <- sits_select(samples_ts, bands = "NDVI")

# Calculando os padrões
patterns <- sits_patterns(samples_indexes)

# Visualizando os padrões
plot(patterns)

################################################################################
##################### Treinando o Modelo de Classificação ######################
################################################################################

# Random Forest
rfor_model <- sits_train(
  samples   = samples_ts,
  ml_method = sits_rfor()
)

# Características do modelo
plot(rfor_model)

################################################################################
############################ Classificação do Cubo #############################
################################################################################

# Gerando cubo de probabilidade

probs <- sits_classify(
  data       = cube,
  ml_model   = rfor_model,
  multicores = 8,
  memsize    = 16,
  roi        = "~/sits_ana/roi_class.shp",
  output_dir = data_dir
)

# Visualizando as probabilidades
plot(probs)

# Suavização espacial
bayes <- sits_smooth(
  cube       = probs,
  multicores = 8,
  memsize    = 16,
  output_dir = data_dir,
  progress   = TRUE
)

plot(bayes)

# Rotulando a classificação
class <- sits_label_classification(
  cube       = bayes,
  multicores = 8,
  memsize    = 16,
  output_dir = data_dir,
  progress   = TRUE
)

# Visualizando a classificação no plot
plot(class)

# Visualização em View do RStudio
sits_view(class)


################################################################################
############################ Fim da Classificação ##############################
################################################################################
