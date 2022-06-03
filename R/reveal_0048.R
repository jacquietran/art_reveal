# Source custom functions ------------------------------------------------------

source(here::here("R/fx_drop_blobs2.R"))
source(here::here("R/fx_blobs_and_tiles.R"))
source(here::here("R/fx_grain2.R"))

# Set parameters ---------------------------------------------------------------

# General params
iteration_id <- "reveal_0048"
initial_seed <- 3578148
bg_colour <- "#001514"
line_colour <- "#FA420F"
grain_colours <- c("#2541B2", "#89555E", "#FA420F", "#FDA187")

# Create data ------------------------------------------------------------------

blobs_combined <- blobs_and_tiles(
  arrangement = "20x20", seed_vec = initial_seed,
  bg = bg_colour, colours = line_colour)

# Create background grain
grain_data <- mimic_grain2(
  seed_num = initial_seed, lower = c(min(blobs_combined$x) - 20),
  upper = c(max(blobs_combined$y) + 20),
  grain = 800, n_lines = 500, colours = grain_colours)

# Build plot -------------------------------------------------------------------

p <- ggplot2::ggplot() +
  ggplot2::geom_point(
    data = grain_data,
    ggplot2::aes(x = x, y = y, size = point_size, colour = point_colour),
    shape = 16, stroke = 0, alpha = 0.55) +
  ggforce::geom_diagonal_wide(
      data = blobs_combined,
      ggplot2::aes(x = x, y = y, group = grouping_var, size = group_size * 0.5,
                   # linetype = group_linetype,
                   fill = group_fill),
      strength = 5, colour = line_colour, alpha = 1) +
  ggplot2::scale_colour_identity() +
  ggplot2::scale_fill_identity() +
  ggplot2::scale_size_identity() +
  # ggplot2::scale_linetype_identity() +
  ggplot2::coord_fixed(
    xlim = c(min(blobs_combined$x) - 20, max(blobs_combined$x) + 20),
    ylim = c(min(blobs_combined$y) - 20, max(blobs_combined$y) + 20),
    expand = FALSE) +
  ggplot2::theme_void() +
  ggplot2::theme(
    legend.position = "none",
    plot.background = ggplot2::element_rect(
      fill = bg_colour, colour = bg_colour),
    plot.margin = ggplot2::margin(200,200,200,200, unit = "pt"))

# Export to file ---------------------------------------------------------------

ggplot2::ggsave(
  here::here(glue::glue("img/{`iteration_id`}.png")),
  ggplot2::last_plot(), width = 12000, height = 12000, units = "px", dpi = 600,
  device = ragg::agg_png)
