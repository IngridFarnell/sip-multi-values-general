# Creating spatial layer

# libraries
library(fs)
library(data.table)
library(sf)
library(mapview)
library(elevatr)

# data
in_dir <- path("00_data")
out_dir <- path("01_clean_data")

# camera sites
cams <- fread(file.path(in_dir, "mv1_camera_sites.csv"))
cams_sf <- st_as_sf(cams, coords=c("Longitude", "Latitude"), crs = 4326) # x=lon and y= lat


# Export site spatial layer
st_write(cams_sf, file.path(out_dir, "mv1_camera_sites.gpkg"), layer = "mv1_camera_sites")
