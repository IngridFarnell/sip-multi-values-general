# Map to view camera servicing

# Libraries
library(fs)
library(data.table)
library(sf)
library(mapview)

# set path
in_dir <- path("00_data")
out_dir <- path("02_vector_data")

# Load data
cams <- fread(file.path(in_dir, "mv1_camera_sites.csv"))
service2025 <- fread(file.path(in_dir, "service2025.csv"))
veg <- fread(file.path(in_dir, "Plot Data - Site Form.csv"))



# Prep data to merge to spatial file
# camera service 
# If blank then change to Y (for yes)
service2025[is.na(serviced2025) | serviced2025 == "", serviced2025 := "Y"]

# Add this data to the spatial layer
site <- merge(cams, service2025, by = "SiteID", all = TRUE)
site <- as.data.table(site)

# veg plots
# rename some columns to match other data for script functions
setnames(veg, "Plot ID", "Plot_Sub") 
#split plot id and subplot ID
veg[, c("Plot ID", "SubplotID") := {
  split_point <- regexpr("-", Plot_Sub, fixed = TRUE)
  list(
    substr(Plot_Sub, 1, split_point - 1),
    substr(Plot_Sub, split_point + 1, nchar(Plot_Sub))
  )
}]
# rename plotID to siteID
setnames(veg, "Plot ID", "SiteID")
# Only keep siteID and date
vegsites <- unique(veg$SiteID)
# Add these plots with the year to the data
site[SiteID %in% vegsites, vegplots := 2024]



# View the sites
mapview(cams_sf)
st_write(cams_sf, file.path(out_dir, "mv1_camera_sites.gpkg"), layer = "mv1_camera_sites")

