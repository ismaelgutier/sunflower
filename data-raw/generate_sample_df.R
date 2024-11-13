# Crear un data frame con los datos de la primera tarea
data1 <- data.frame(
  item_id = 1:13,  # IDs del 1 al 13
  item = c(
    'peine', 'mesa', 'casa', 'perro', 'gato',
    'silla', 'ventana', 'puerta', 'luz', 'luna',
    'sol', 'estrella', 'cielo'
  ),
  response = c(
    'pente, peina',
    'misa, miso',
    'casa',
    'pelo, gato',
    'gatoz',
    'sile, silla',
    'venta, ventana',
    'puerpo, puerta',
    'luces, luz',
    'lunita, luna',
    'solito, sol',
    'esc, esme, este, estrella',
    'cielito, cielo'
  ),
  access_to_target = c(
    1, 0, 1, 0, 0,
    1, 1, 1, 1, 1,
    1, 1, 1
  ),
  task_name = rep('example1', 13),  # Repetir "EPLA" para todos los ítems
  assessment_date = rep('03-11-2024', 13) # Repetir la fecha
)

# Crear un data frame con los datos de la segunda tarea
data2 <- data.frame(
  item_id = 14:26, # IDs del 14 al 26
  item = c(
    'flor', 'árbol', 'ratón', 'elefante',
    'jirafa', 'león', 'tigre', 'pez',
    'pájaro', 'mariposa', 'araña',
    'abeja', 'libro'
  ),
  response = c(
    'florecita, flor',
    'arbola, árbol',
    'ratono, ratón',
    'elefantito, elefante',
    'jirafita, jirafa',
    'leoncito, león',
    'tie',
    'pezi',
    'pajo',
    'maria, mariposa',
    'aral, araña',
    'abejo, abeja',
    'lic, libro'
  ),
  access_to_target = c(
    1, 1, 1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1
  ),
  task_name = rep('example2', 13), # Nueva tarea
  assessment_date = rep('04-11-2024', 13) # Nueva fecha
)

# Combinar ambos data frames
combined_data <- rbind(data1, data2)

# Crear directorio "data" si no existe
if (!dir.exists("data")) {
  dir.create("data")
}

# Guardar el dataframe combinado como un archivo .RData en la carpeta "data"
save(combined_data, file = "data/sample_df.RData")

# Mostrar el DataFrame combinado
print(combined_data)

