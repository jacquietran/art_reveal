# Source custom functions ------------------------------------------------------

source(here::here("R/fx_drop_blobs.R"))

# Set parameters ---------------------------------------------------------------

# General params
iteration_id <- "reveal_0005"
initial_seed <- 71004
bg_colour <- "#F1ECCE"

colour_vec <- c("#F26419", "#2F4858")

# Create data ------------------------------------------------------------------

# Drop blobs
blobs <- drop_blobs(
  seed_num = initial_seed, bg = bg_colour, palette = colour_vec,
  x_lower = 0, x_upper = 10, y_lower = 0, y_upper = 10)

blobs_combined <- blobs$combined |>
  dplyr::filter(group <= 5)

# Build plot -------------------------------------------------------------------

p <- ggplot2::ggplot() +
  ggforce::geom_diagonal_wide(
      data = blobs_combined,
      ggplot2::aes(x = x, y = y, group = group),
      strength = 0.5, colour = "#2F4858", size = 5, alpha = 0,
      radius = ggplot2::unit(4, 'mm')) +
  ggplot2::coord_fixed(xlim = c(-2, 12), ylim = c(-2, 12), expand = FALSE) +
  ggplot2::theme_void() +
  ggplot2::theme(
    legend.position = "none",
    plot.background = ggplot2::element_rect(
      fill = bg_colour, colour = bg_colour),
    plot.margin = ggplot2::margin(40,40,40,40, unit = "pt"))

# Export to file ---------------------------------------------------------------

ggplot2::ggsave(
  here::here(glue::glue("img/{`iteration_id`}.png")),
  ggplot2::last_plot(), width = 6000, height = 6000, units = "px", dpi = 600,
  device = ragg::agg_png)

beepr::beep(2)