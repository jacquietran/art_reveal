# Source custom functions ------------------------------------------------------

source(here::here("R/fx_drop_blobs_many.R"))
source(here::here("R/fx_grain2.R"))

# Set parameters ---------------------------------------------------------------

# General params
iteration_id <- "reveal_0044"
initial_seed <- 710044
bg_colour <- "#F1ECCE"
line_colour <- "#2F4858"
grain_colours <- c("#C492B1", "#AF3B6E", "#FF8811")
lower_limit <- -1
upper_limit <- 11

# Create data ------------------------------------------------------------------

# Create grain layer
grain_data <- mimic_grain2(
  seed_num = initial_seed, lower = lower_limit, upper = upper_limit,
  grain = 800, n_lines = 200, colours = grain_colours)

# Drop blobs
blobs <- drop_blobs_many(
  seed_num = initial_seed, bg = bg_colour,
  x_lower = 0, x_upper = 10, y_lower = 0, y_upper = 10)

blobs_combined <- blobs$combined
blobs_set1 <- blobs$set1

# Build plot -------------------------------------------------------------------

p <- ggplot2::ggplot() +
  ggfx::as_reference(
    ggforce::geom_diagonal_wide(
      data = blobs_combined,
      ggplot2::aes(x = x, y = y, group = group),
      strength = 2.5, fill = bg_colour, size = 0, alpha = 1,
      radius = ggplot2::unit(8, 'mm')),
    id = "blobs") +
  ggfx::with_mask(
    ggplot2::geom_point(
      data = grain_data,
      ggplot2::aes(x = x, y = y, size = point_size, colour = point_colour),
      shape = 16, stroke = 0, alpha = 0.55),
    mask = ggfx::ch_alpha("blobs")) +
  ggforce::geom_diagonal_wide(
    data = blobs_combined,
    ggplot2::aes(x = x, y = y, group = group),
    strength = 2.5, colour = line_colour, size = 5, alpha = 0,
    radius = ggplot2::unit(8, 'mm')) +
  ggplot2::scale_colour_identity() +
  ggplot2::scale_size_identity() +
  ggplot2::coord_fixed(
    xlim = c(lower_limit, upper_limit), ylim = c(lower_limit, upper_limit),
    expand = TRUE) +
  ggplot2::theme_void() +
  ggplot2::theme(
    legend.position = "none",
    plot.background = ggplot2::element_rect(
      fill = bg_colour, colour = bg_colour),
    plot.margin = ggplot2::margin(40,40,40,40, unit = "pt"))

# Export to file ---------------------------------------------------------------

ggplot2::ggsave(
  here::here(glue::glue("img/{`iteration_id`}.png")),
  ggplot2::last_plot(), width = 9000, height = 9000, units = "px", dpi = 600,
  device = ragg::agg_png)

beepr::beep(2)