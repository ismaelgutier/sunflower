rm(list = ls())

# Function to get the properties of a dataframe
get_dataframe_properties <- function(df, name) {
  list(
    "Dataframe name" = name,  # Use the passed name directly
    "Rows" = nrow(df),
    "Columns" = ncol(df),
    "Column names" = paste(colnames(df), collapse = ", ")
  )
}

# Load the .RData files
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))  # Set working directory to script location

# Load the data files (adjust the paths as needed)
load("C:/Users/Maria/Desktop/sunflower/data/IGC_sample.RDA")
load("C:/Users/Maria/Desktop/sunflower/data/IGC_long_sample.RDA")
load("C:/Users/Maria/Desktop/sunflower/data/IGC_long_phon_sample.RDA")
load("C:/Users/Maria/Desktop/sunflower/data/simulated_sample.RDA")

# Get the names of the objects loaded in the environment
dataframes <- ls()

# Filter only the objects that are dataframes
dataframes <- dataframes[sapply(dataframes, function(x) is.data.frame(get(x)))]

# Create a list with the properties of all dataframes
properties_list <- lapply(dataframes, function(df_name) {
  df <- get(df_name)  # Get the dataframe by name
  get_dataframe_properties(df, df_name)  # Pass the dataframe and its name to the function
})

# Convert the list into a dataframe
properties <- do.call(rbind, lapply(properties_list, as.data.frame))

# Assign row names according to the name of the dataframes
row.names(properties) <- dataframes

# Print the table with the properties of the dataframes
# Replacing periods with spaces in column names
colnames(properties) <- gsub("\\.", " ", colnames(properties))

# View the properties dataframe
View(properties)

#writexl::write_xlsx(properties, "dataframes_properties.xlsx")
