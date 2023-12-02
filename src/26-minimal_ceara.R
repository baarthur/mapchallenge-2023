# not exactly for map challenge: this is just a map of Ceará's light rails outside of the capital,
#   since a lot of people were shocked about their existence according to @copaiba_. 


# setup ---------------------------------------------------------------------------------------

library(here)
library(sf)
library(geobr)
library(tidyverse)
library(spatialops)


# shapefiles ----------------------------------------------------------------------------------

shp_rm <- read_metro_area() %>% filter(abbrev_state == "CE")
shp_cariri <- read_metro_area() %>% filter(name_metro == "RM Cariri")
shp_sobral <- read_metro_area() %>% filter(name_metro == "RM Sobral")

shp_transit <- st_read(here("data/TMA_2022.kml"), layer = "BRT_Corredores") %>% 
  bind_rows(shp_transit)
shp_transit <- st_read(here("data/TMA_2022.kml"), layer = "VLT_Monotrilho_Corredores")
shp_transit <- st_read(here("data/TMA_2022.kml"), layer = "Metro_Trem_Barca_Corredores") %>% 
  bind_rows(shp_transit)

shp_transit <- shp_transit %>% 
  maphub_to_sf(values = Description, pair_sep = "<br>") %>% 
  janitor::clean_names() %>% 
  filter(situacao %in% c("Operacional", "Operacional não TMA")) %>% 
  select(modo, cidade_n, corredor) %>% 
  st_zm()



# getting roads -------------------------------------------------------------------------------

bbox_cariri <- shp_transit %>% 
  filter(cidade_n == "Juazeiro do Norte") %>% 
  st_centroid() %>% 
  st_buffer(5500) %>% 
  st_bbox()

bbox_sobral <- shp_transit %>% 
  filter(cidade_n == "Sobral") %>% 
  st_centroid() %>% 
  st_buffer(5500) %>%
  st_bbox()

shp_roads_cariri <- bbox_cariri %>% 
  get_osm_roads(use = "lines") %>% 
  st_transform(crs = 4674)

shp_roads_sobral <- bbox_sobral %>% 
  get_osm_roads(use = "lines") %>% 
  st_transform(crs = 4674)



# individual maps -----------------------------------------------------------------------------

p_cariri <- ggplot() +
  geom_sf(
    data = shp_cariri,
    fill = NA, linetype = "dashed"
  ) +
  geom_sf(data = shp_roads_cariri, linewidth = 0.0625) +
  geom_sf(
    data = shp_transit %>% filter(cidade_n == "Juazeiro do Norte"),
    aes(color = corredor)
  ) +
  coord_sf(xlim = c(bbox_cariri[1], bbox_cariri[3]), ylim = c(bbox_cariri[2], bbox_cariri[4])) +
  labs(title = "Cariri (Juazeiro do N.)", color = "") +
  theme_void(base_family = "Atkinson Hyperlegible") %+replace%
  theme(legend.position = "bottom")


p_sobral <- ggplot() +
  geom_sf(
    data = shp_sobral,
    fill = NA, linetype = "dashed"
  ) +
  geom_sf(data = shp_roads_sobral, linewidth = 0.0625) +
  geom_sf(
    data = shp_transit %>% filter(cidade_n == "Sobral"),
    aes(color = corredor)
  ) +
  coord_sf(xlim = c(bbox_sobral[1], bbox_sobral[3]), ylim = c(bbox_sobral[2], bbox_sobral[4])) +
  labs(title = "Sobral", color = "") +
  theme_void(base_family = "Atkinson Hyperlegible") %+replace%
  theme(legend.position = "bottom")



# together ------------------------------------------------------------------------------------

ggplot() +
  geom_sf(data = shp_sobral, color = NA, fill = NA) +
  annotation_custom(
    grob = ggplotGrob(p_cariri), xmin = -41.25, xmax = -40.45, ymax = -2.8
  ) +
  annotation_custom(
    grob = ggplotGrob(p_sobral), xmin = -40.35, xmax = -39.55, ymax = -2.85
  ) +
  labs(
    title = "VLTs do interior do Ceará",
    caption = paste0("A extensão de ambos é parecida (cerca de 13km)",
                     ", mas o VLT de Sobral transporta em média","\n",
                     "5 mil passageiros por dia. Já no Cariri, os trens",
                     " levam cerca de 2 mil/dia (dados de set/2023).")
  ) +
  theme_void(base_family = "Atkinson Hyperlegible") %+replace%
  theme(
    plot.title = element_text(face = "bold", hjust = -0.6, size = 14),
    plot.caption = element_text(vjust = 15)
  )

ggsave(here("output/p-day26_3.png"))
