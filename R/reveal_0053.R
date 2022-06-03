# Source custom functions ------------------------------------------------------

source(here::here("R/fx_drop_blobs2.R"))
source(here::here("R/fx_blobs_and_tiles.R"))

# Set parameters ---------------------------------------------------------------

# General params
iteration_id <- "reveal_0053"
initial_seed <- 323453
bg_colour <- "#E8F7DE"
line_colour <- "#94C9A9"
colour_opts <- c("#D5573B", "#885053", "#777DA7", bg_colour)

# Create data ------------------------------------------------------------------

blobs_combined <- blobs_and_tiles(
  arrangement = "20x20", seed_vec = initial_seed, bg = bg_colour,
  colours = colour_opts, groups_min = 2, groups_max = 6)

# Build plot -------------------------------------------------------------------

p <- ggplot2::ggplot() +
  ggforce::geom_diagonal_wide(
      data = blobs_combined,
      ggplot2::aes(x = x, y = y, group = grouping_var, size = group_size * 0.3,
                   # linetype = group_linetype,
                   fill = group_fill),
      strength = 8, colour = line_colour, alpha = 1) +
  ggplot2::scale_fill_identity() +
  ggplot2::scale_size_identity() +
  # ggplot2::scale_linetype_identity() +
  ggplot2::coord_fixed(
    xlim = c(min(blobs_combined$x) - 1, max(blobs_combined$x) + 1),
    ylim = c(min(blobs_combined$y) - 1, max(blobs_combined$y) + 1),
    expand = FALSE) +
  ggplot2::theme_void() +
  ggplot2::theme(
    legend.position = "none",
    plot.background = ggplot2::element_rect(
      fill = bg_colour, colour = bg_colour),
    plot.margin = ggplot2::margin(250,250,250,250, unit = "pt"))

# Export to file ---------------------------------------------------------------

ggplot2::ggsave(
  here::here(glue::glue("img/{`iteration_id`}.png")),
  ggplot2::last_plot(), width = 12000, height = 12000, units = "px", dpi = 600,
  device = ragg::agg_png)
