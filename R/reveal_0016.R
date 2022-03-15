# Source custom functions ------------------------------------------------------

source(here::here("R/fx_drop_blobs2.R"))

# Set parameters ---------------------------------------------------------------

# General params
iteration_id <- "reveal_0016"
initial_seed <- 32016
n_tiles <- 9
bg_colour <- "#4CBD9B"
line_colour <- "#FCE2C5"

# Create data ------------------------------------------------------------------

set.seed(initial_seed)
seed_vec <- sample(seq(1, 5000000, by = 1), n_tiles)

# Drop blobs
blobs_tile1 <- drop_blobs2(
  seed_num = seed_vec[1], bg = bg_colour,
  x_lower = 1, x_upper = 9, y_lower = 1, y_upper = 9)

blobs_tile2 <- drop_blobs2(
  seed_num = seed_vec[2], bg = bg_colour,
  x_lower = 11, x_upper = 19, y_lower = 1, y_upper = 9)

blobs_tile3 <- drop_blobs2(
  seed_num = seed_vec[3], bg = bg_colour,
  x_lower = 21, x_upper = 29, y_lower = 1, y_upper = 9)

blobs_tile4 <- drop_blobs2(
  seed_num = seed_vec[4], bg = bg_colour,
  x_lower = 1, x_upper = 9, y_lower = 11, y_upper = 19)

blobs_tile5 <- drop_blobs2(
  seed_num = seed_vec[5], bg = bg_colour,
  x_lower = 11, x_upper = 19, y_lower = 11, y_upper = 19)

blobs_tile6 <- drop_blobs2(
  seed_num = seed_vec[6], bg = bg_colour,
  x_lower = 21, x_upper = 29, y_lower = 11, y_upper = 19)

blobs_tile7 <- drop_blobs2(
  seed_num = seed_vec[7], bg = bg_colour,
  x_lower = 1, x_upper = 9, y_lower = 21, y_upper = 29)

blobs_tile8 <- drop_blobs2(
  seed_num = seed_vec[8], bg = bg_colour,
  x_lower = 11, x_upper = 19, y_lower = 21, y_upper = 29)

blobs_tile9 <- drop_blobs2(
  seed_num = seed_vec[9], bg = bg_colour,
  x_lower = 21, x_upper = 29, y_lower = 21, y_upper = 29)

# Merge tiles together
blobs_combined <- dplyr::bind_rows(
  blobs_tile1, blobs_tile2, blobs_tile3, blobs_tile4, blobs_tile5, blobs_tile6,
  blobs_tile7, blobs_tile8, blobs_tile9,
  .id = "tile") |>
  dplyr::mutate(
    grouping_var = glue::glue({"{tile}_{group}"}))

# Build plot -------------------------------------------------------------------

p <- ggplot2::ggplot() +
  ggforce::geom_diagonal_wide(
      data = blobs_combined,
      ggplot2::aes(x = x, y = y, group = grouping_var, size = group_size,
                   linetype = group_linetype),
      strength = 0.5, colour = line_colour, alpha = 0,
      radius = ggplot2::unit(7, 'mm')) +
  ggplot2::scale_size_identity() +
  ggplot2::scale_linetype_identity() +
  ggplot2::coord_fixed(xlim = c(-1, 31), ylim = c(-1, 31), expand = FALSE) +
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
