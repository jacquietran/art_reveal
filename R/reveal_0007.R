# Source custom functions ------------------------------------------------------

source(here::here("R/fx_drop_blobs2.R"))

# Set parameters ---------------------------------------------------------------

# General params
iteration_id <- "reveal_0007"
initial_seed <- 324817
bg_colour <- "#86BBD8"
line_colour <- "#33658A"

# Create data ------------------------------------------------------------------

# Drop blobs
blobs <- drop_blobs2(
  seed_num = initial_seed, bg = bg_colour,
  x_lower = 0, x_upper = 10, y_lower = 0, y_upper = 10)

# Build plot -------------------------------------------------------------------

p <- ggplot2::ggplot() +
  ggforce::geom_diagonal_wide(
      data = blobs,
      ggplot2::aes(x = x, y = y, group = group, alpha = group_alpha),
      strength = 0.5, fill = line_colour, colour = line_colour, size = 5,
      radius = ggplot2::unit(4, 'mm')) +
  ggplot2::scale_alpha_identity() +
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