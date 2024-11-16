rm(list = ls())

# Dependencies
require(dplyr)

# Función para crear data frame
crear_df <- function(item_id, item, response, task_name, date) {
  data.frame(
    item_id = item_id,
    item = item,
    response = response,
    task_name = task_name,
    assessment_date = date,
    stringsAsFactors = FALSE
  )
}

# Creación de data frames individuales
data1 <- crear_df(
  1:13,
  c('peine', 'mesa', 'casa', 'perro', 'gato', 'silla', 'ventana', 'puerta', 'luz', 'luna', 'sol', 'estrella', 'cielo'),
  c('peina, pente', 'misa, miza', 'apartamento', 'gato, gatoz', 'pelo, gato', 'sile, silla', 'espejo', 'puerpo, puerta', 'farola', 'satélite', 'luz, sol', 'estrelo, estrella', 'nube, cielo'),
  'example1', '03-11-2024'
)

data2 <- crear_df(
  14:26,
  c('flor', 'árbol', 'ratón', 'elefante', 'jirafa', 'león', 'tigre', 'pez', 'pájaro', 'mariposa', 'araña', 'abeja', 'libro'),
  c('hoja, flor', 'arbola, arbolito', 'ratona', 'jirafa', 'jirafa, jiravo', 'lion, león', 'gato', 'agua', 'paraguas', 'mari, mosca', 'telaraña', 'abejorro', 'cuaderno'),
  'example2', '04-11-2024'
)

data3 <- crear_df(
  27:39,
  c('peine', 'mesa', 'casa', 'perro', 'gato', 'silla', 'ventana', 'puerta', 'luz', 'luna', 'sol', 'estrella', 'cielo'),
  c('pene, peno', 'meza, miza', 'caza, kasa', 'pero, perrito', 'kato, gato', 'sila, shila', 'benta, venta', 'puertao, puertita', 'lus, luse', 'luno, lun', 'zol, solo', 'estrelo, estera', 'sielo, sielo'),
  'example3', '05-11-2024'
)

data4 <- crear_df(
  40:52,
  c('peine', 'mesa', 'casa', 'perro', 'gato', 'silla', 'ventana', 'puerta', 'luz', 'luna', 'sol', 'estrella', 'cielo'),
  c('pen', 'meso', 'caas', 'pero', 'gto', 'sila', 'veanta', 'puerta', 'lus', 'lnua', 'soli', 'estela', 'ceilo'),
  'example4', '07-11-2024'
)

data5 <- crear_df(
  53:65,
  c('silla', 'mesa', 'casa', 'perro', 'gato', 'ventana', 'puerta', 'luz', 'luna', 'sol', 'estrella', 'cielo', 'flor'),
  c('sofá', 'escritorio', 'apartamento', 'felino', 'ratón', 'espejo', 'portón', 'foco', 'estrella', 'planeta', 'cometa', 'nube', 'jardín'),
  'example5', '08-11-2024'
)

data6 <- crear_df(
  66:75,
  c('firefighter', 'article', 'child', 'umbrella', 'elephant', 'banana', 'guitar', 'butterfly', 'carrot', 'telephone'),
  c('tier, fire, fire, fireigh, firefer, fireter', 'are, arti, artec, artec, article', 'animal, small girl, child',
    'umbre, umbrela, umberella, umbrella', 'elphant, elfant, elaphant, elephant', 'banna, bananna, banana',
    'gitar, gitarr, guitar', 'buter, butterfl, butterflie, butterfly', 'carot, carrat, carrot', 'tele, telaphone, telefone, telephone'),
  'approx_example', '16-11-2024'
)

# Unificar todos los data frames y arreglar item_id duplicados
simulated_sample <- bind_rows(data1, data2, data3, data4, data5, data6) %>%
  mutate(item_id = row_number()) %>% # Asigna un nuevo item_id único
  arrange(item_id)

# Crear directorio "data" si no existe
if (!dir.exists("data")) dir.create("data")

# Guardar el archivo
save(simulated_sample, file = "data/simulated_df.RData")

# Visualizar los datos y el resumen
View(simulated_sample)
summary(simulated_sample)

