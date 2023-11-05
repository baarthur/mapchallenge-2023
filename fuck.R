
bra +
annotation_custom(
grob = ggplotGrob(p_sao),
xmin = -85, xmax = -75,
ymin = -5, ymax = 5
) +
annotation_custom(
grob = ggplotGrob(p_rio),
xmin = -85, xmax = -75,
ymin = -15, ymax = -5
) +
annotation_custom(
grob = ggplotGrob(p_bhz),
xmin = -85, xmax = -75,
ymin = -25, ymax = -15
) +
annotation_custom(
grob = ggplotGrob(p_bsb),
xmin = -85, xmax = -75,
ymin = -35, ymax = -25
) +
annotation_custom(
grob = ggplotGrob(p_poa),
xmin = -30, xmax = -20,
ymin = -5, ymax = 5
) +
annotation_custom(
grob = ggplotGrob(p_for),
xmin = -30, xmax = -20,
ymin = -15, ymax = -5
) +
annotation_custom(
grob = ggplotGrob(p_rec),
xmin = -30, xmax = -20,
ymin = -25, ymax = -15
) +
annotation_custom(
grob = ggplotGrob(p_cwb),
xmin = -30, xmax = -20,
ymin = -35, ymax = -25
) +
labs(title = "Brazil: urban footprint and largest metropolitan areas") +
theme_void() +
theme(
legend.position = "none",
text = element_text(family = "Atkinson"),
plot.title = element_text(face = "bold")
)



#| label: setup
library(sf) # days: all
library(geobr) # days: 3, 4
library(sidrar) # days: 3
library(ggpubr) # days: 3
library(tidyverse) # days: all
library(ggspatial) # days: 3
shp_mg <- read_state(code_state = "31")
shp_muni <- read_municipality(code_muni = "MG")
shp_ri <- read_immediate_region(code_immediate = "MG")

booger <- c(3127008, 3127107)
eye <- c(3100104, 3119302, 3148004, 3153400, 3137536, 3137106, 3171006, 3128600)
eyebrow <- c(3109451, 3170404, 3108206, 3144375, 3122470, 3108552)
teeth <- c(3104106, 3128303, 3128709, 3144102, 3109501, 3108404, 3151800)
mouth <- c(
3132909, 3143203, 3134806, 3163904, 3107604, 3136900, 3145109, 3102001, 3143005, 3104304, 3122405,
3166907, 3111002, 3105301, 3110301, 3102605
)
hair <- c(310009, 310007, 310012, 310008, 310017, 310018, 310015, 310019, 310013)


tm_shape(shp_muni) +
tm_fill(col = "lightgrey") +
tm_borders() +
tm_shape(shp_muni %>% filter(code_muni %in% eye)) +
tm_fill(col = "black") +
tm_shape(shp_muni %>% filter(code_muni %in% eyebrow)) +
tm_fill(col = "#543808") +
tm_shape(shp_ri %>% filter(code_immediate %in% hair)) +
tm_fill(col = "#7d5819") +
tm_shape(shp_muni %>% filter(code_muni %in% teeth)) +
tm_fill(col = "#EAE0C8") +
tm_borders(col = "black") +
tm_shape(shp_muni %>% filter(code_muni %in% mouth)) +
tm_fill(col = "#d32f2f") +
tm_shape(shp_muni %>% filter(code_muni %in% booger)) +
tm_fill(col = "#b2d63f")

ggplot() +
geom_sf(data = shp_mg, fill = "lightgrey", color = "black") +
geom_sf(data = shp_muni %>% filter(code_muni %in% eye), aes(fill = "eye"), color = "black") +
geom_sf(data = shp_muni %>% filter(code_muni %in% eyebrow),
aes(fill = "eyebrow"), color = "#543808") +
geom_sf(data = shp_ri %>% filter(code_immediate %in% hair),
aes(fill = "hair"), color = "#7d5819") +
geom_sf(data = shp_muni %>% filter(code_muni %in% mouth),
aes(fill = "mouth"), color = "#d32f2f") +
geom_sf(data = shp_muni %>% filter(code_muni %in% booger),
aes(fill = "booger"), color = "#b2d63f") +
geom_sf(data = shp_muni %>% filter(code_muni %in% teeth),
aes(fill = "teeth"), color = "black") +
scale_fill_manual(values = c("eye" = "black", "eyebrow" = "#543808", "hair" = "#7d5819",
"teeth" = "#EAE0C8", "mouth" = "#d32f2f", "booger" = "#b2d63f"),
guide = "legend") +
theme_void() +
labs(title = "minas gerais as a person", fill = "parts") +
theme(
text = element_text(family = "Comic Sans MS")
)
