# Título: Acessando imagens de satélite do mundo inteiro!
# Objetivo: Acessar provedores de imagens de satélites e criar cubo de dados.
# Elaboração: Ana Larissa Freitas - Dados & Geo.
# Referência: https://e-sensing.github.io/sitsbook/

# Instalando SITS
# install.packages("sits")

# Carregando SITS
library(sits)

# Definindo diretório
data_dir <- "~/sits_ana/"

# Verificando as coleções disponíveis
sits_list_collections()

# Verificando as informações de um provedor específico
sits_list_collections("MPC")

# Definir os provedores e imagens para compor o cubo de dados
cube_s2 <- sits_cube(
  source = "MPC",
  collection = "SENTINEL-2-L2A",
  # O sits padroniza as bandas que se referem à nuvem
  bands = c("B02", "B8A", "B11", "CLOUD"),
  tiles = "22MGD",
  start_date = "2024-08-01",
  end_date = "2024-10-31"
)

# Verificar as datas das imagens obtidas
sits_timeline(cube_s2)

# Criar a visualização das imagens, as datas podem ser filtradas
sits_view(cube_s2,
          red = "B11", blue = "B02", green = "B8A",
          dates = c("2024-09-06","2024-10-06")
)

# Selecionando data para download
selected <- sits_select(cube_s2, dates = "2024-09-06")

# Criar uma cópia das imagens no computador
copy <- sits_cube_copy(selected,
                       output_dir = "~/sits_ana/images/",
                       multicores = 10)


############################ Fim do Algoritmo ##############################
