library(haven)
library(readr)
library(stringdist)

# Importar csv infraestructura
infraestructura <- read.csv("infraestructura.csv")

# Importar dta contracts
contracts <- read_dta("contracts_table.dta")

# use grepl() to find rows that match the pattern
pattern <- "ESCUELA|UNIDAD EDUCATIVA|CENTRO|CECIB" # use "^" to match the start of the string
matches <- grepl(pattern, contracts$contract_object)

# subset the indices of the matching rows
indices <- which(matches)

# use the previously computed 'indices' vector to subset the rows with matches
matching_contracts <- contracts[indices,]

# extract the substring after the specified words and store in the 'NOMBRE' column
matching_contracts$NOMBRE <- sub("^.*(ESCUELA|UNIDAD EDUCATIVA|CENTRO|CECIB)", "\\1", matching_contracts$contract_object)

# delete after comma
matching_contracts$NOMBRE <- gsub(",.*", "", matching_contracts$NOMBRE)

# Create an empty vector to store the best matches
best_matches <- vector(mode = "character", length = length(infraestructura$Nombre.de.Institución))

# Loop over each element in infraestructura$Nombre.de.Institución
for (i in seq_along(infraestructura$Nombre.de.Institución)) {
  # Compute the distances between the current element and all elements in matching_contracts$NOMBRE
  distances <- adist(infraestructura$Nombre.de.Institución[i], matching_contracts$NOMBRE)
  # Find the index of the minimum distance
  best_match_index <- which.min(distances)
  # Get the best match from matching_contracts$NOMBRE
  best_matches[i] <- matching_contracts$NOMBRE[best_match_index]
}

# Add the best matches as a new column in infraestructura
infraestructura$best_match <- best_matches
