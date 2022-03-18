# Source custom functions ------------------------------------------------------

source(here::here("R/fx_drop_blobs3.R"))
source(here::here("R/fx_grain2.R"))

# Set parameters ---------------------------------------------------------------

# General params
iteration_id <- "reveal_0039"
initial_seed <- 327139
n_tiles <- 9
bg_colour <- "#002F3D"
line_colour <- "#F18F01"

grain_colours <- c("#3581B8", "#F97068", "#EBE9E9")

lower_limit <- 0
upper_limit <- 12

# Create data ------------------------------------------------------------------

# Create background grain
grain_data <- mimic_grain2(
  seed_num = initial_seed, lower = lower_limit, upper = upper_limit,
  grain = 600, n_lines = 100, colours = grain_colours)

# Drop blobs
blobs <- drop_blobs3(
  seed_num = initial_seed, bg = bg_colour, colours = line_colour,
  x_lower = 1, x_upper = 11, y_lower = 1, y_upper = 11)

# Build plot -------------------------------------------------------------------

p <- ggplot2::ggplot() +
  ggplot2::geom_point(
    data = grain_data,
    ggplot2::aes(x = x, y = y, size = point_size, colour = point_colour),
    shape = 16, stroke = 0, alpha = 0.55) +
  ggforce::geom_diagonal_wide(
      data = blobs,
      ggplot2::aes(x = x, y = y, group = group, size = group_size),
      strength = 1.5, colour = line_colour, alpha = 0,
      radius = ggplot2::unit(6, 'mm')) +
  ggplot2::scale_colour_identity() +
  ggplot2::scale_size_identity() +
  # ggplot2::scale_linetype_identity() +
  ggplot2::coord_cartesian(
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
