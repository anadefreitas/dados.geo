# Título: Criando cubo de dados a partir de imagens locais
# Objetivo: Criar cubo de dados local.
# Elaboração: Ana Larissa Freitas - Dados & Geo.
# Referência: https://e-sensing.github.io/sitsbook/ &
# De Freitas, Gama e Souza (2025), Mercator UFC, https://shre.ink/xCZd

# Carregando SITS
library(sits)

# Definindo Diretório
data_dir <- "~/diretorio/"

# Crie um cubo de dados a partir das imagens SAR processadas
cube <- sits_cube(
  source = "MPC",
  collection = "SENTINEL-1-GRD",
  data_dir = data_dir,
  parse_info = c("satellite", "sensor", "tile", "band", "date")
)

# Obter a linha do tempo do cubo de dados
time_line <- sits_timeline(cube)

# Co-registro de tiles Sentinel-2 e ajuste de resolução de pixels
cube_reg <- sits_regularize(
  cube = cube,
  period = "P1D", # ou P1M para meses
  res = 18,
  multicores = 12,
  output_dir = "~/diretorio/reg/",
  # Tiles obtidos previamente por consulta no GRID MGRS
  tiles = c("24MUA", "24MTA", "24MUV", "24MTV"), 
  timeline = time_line
)

# Crie um cubo de dados regularizado 
cube_reg <- sits_cube(
  source = "MPC",
  collection = "SENTINEL-1-GRD",
  bands = c(
    # Compomos cubos com diferentes bandas para testar a melhor combinação.
    "VV","VH","Angulo-Alfa","Entropia","C11","C12-imag","C12-real","C22","C11-C22","DpRVI"
  ),
  data_dir = "~/diretorio/reg/"
)

# Visualizando o cubo regularizado criado
plot(cube_reg, tile = "24MUA", band = "VH")
plot(cube_reg, tile = "24MUA", band = "ANGULO-ALFA")

############################ Fim do Script ##############################
