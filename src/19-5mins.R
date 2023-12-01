# 5 minute map - chop chop!


# setup ---------------------------------------------------------------------------------------

library(sf)
library(geobr)
library(tidyverse)



# load ----------------------------------------------------------------------------------------

shp_uf <- read_state()
shp_urban <- read_urban_area()
shp_green <- read_conservation_units()


# map it --------------------------------------------------------------------------------------

ggplot() +
  geom_sf(data = shp_uf, fill = NA) +
  geom_sf(data = shp_urban, fill = "grey85", color = "grey85") +
  geom_sf(
    data = shp_green %>% filter(category %in% c("Floresta", "Parque")), 
    fill = "#58bc82", color = "#58bc82"
  ) + 
  labs(
    title = "Brazil: cities and forests",
    caption = "Source: {geobr}"
  ) +
  theme_void(base_family = "Atkinson Hyperlegible")
