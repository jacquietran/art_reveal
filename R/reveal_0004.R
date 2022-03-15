# Source custom functions ------------------------------------------------------

source(here::here("R/fx_drop_blobs.R"))
source(here::here("R/fx_make_noise.R"))

# Set parameters ---------------------------------------------------------------

# General params
iteration_id <- "reveal_0004"
initial_seed <- 71004
bg_colour <- "#F6D8AE"

# For blobs
colour_vec <- c(
  "#083D77", "#DA4167", "#F4D35E", "#51A3A3", "#E0E2DB", "#FBC4AB")
panel_colour <- "#2E4057"

# For noise
starter_colours <- c(bg_colour, panel_colour)
freq <- 2000
lower_limit <- 0
upper_limit <- 12
noise_type <- "value"

# Create data ------------------------------------------------------------------

set.seed(initial_seed)
seed_vec <- sample(seq(1, 500000, by = 1), 6, replace = FALSE)

# Drop blobs
blobs_tile1 <- drop_blobs(
  seed_num = seed_vec[1], bg = bg_colour, palette = colour_vec,
  x_lower = 1, x_upper = 4, y_lower = 1, y_upper = 3.5)

blobs_tile2 <- drop_blobs(
  seed_num = seed_vec[2], bg = bg_colour, palette = colour_vec,
  x_lower = 4.5, x_upper = 7.5, y_lower = 1, y_upper = 3.5)

blobs_tile3 <- drop_blobs(
  seed_num = seed_vec[3], bg = bg_colour, palette = colour_vec,
  x_lower = 8, x_upper = 11, y_lower = 1, y_upper = 3.5)

blobs_tile4 <- drop_blobs(
  seed_num = seed_vec[4], bg = bg_colour, palette = colour_vec,
  x_lower = 1, x_upper = 4, y_lower = 4.5, y_upper = 7)

blobs_tile5 <- drop_blobs(
  seed_num = seed_vec[5], bg = bg_colour, palette = colour_vec,
  x_lower = 4.5, x_upper = 7.5, y_lower = 4.5, y_upper = 7)

blobs_tile6 <- drop_blobs(
  seed_num = seed_vec[6], bg = bg_colour, palette = colour_vec,
  x_lower = 8, x_upper = 11, y_lower = 4.5, y_upper = 7)

# Merge blobs to plot with no radii (hard angles)
blobs_angled <- dplyr::bind_rows(
  blobs_tile1$set1, blobs_tile2$set1, blobs_tile3$set1,
  blobs_tile4$set1, blobs_tile5$set1, blobs_tile6$set1,
  .id = "tile") |>
  dplyr::mutate(
    grouping_var = glue::glue("{tile}_{set_num}_{group}"))

# Merge blobs to plot with radii (curved angles)
blobs_curved <- dplyr::bind_rows(
  blobs_tile1$set2, blobs_tile2$set2, blobs_tile3$set2,
  blobs_tile4$set2, blobs_tile5$set2, blobs_tile6$set2,
  .id = "tile") |>
  dplyr::mutate(
    grouping_var = glue::glue("{tile}_{set_num}_{group}"))

# Create noise data
noise <- make_noise(
  seed_num = initial_seed, colours = starter_colours, frequency = freq,
  lower = lower_limit, upper = upper_limit, noise_type = noise_type)
noise_data <- noise$noise
noise_gradient <- noise$noise_gradient

# Build plot -------------------------------------------------------------------

p <- ggplot2::ggplot() +
  ggfx::with_blur(
    ggforce::geom_diagonal_wide(
      data = blobs_curved,
      ggplot2::aes(x = x, y = y, group = grouping_var, fill = hex_fill),
      strength = 0.5, size = 0, alpha = 0.6, radius = ggplot2::unit(4, 'mm')),
    sigma = 20) +
  ggfx::as_reference(
    ggforce::geom_diagonal_wide(
      data = blobs_curved,
      ggplot2::aes(x = x, y = y, group = grouping_var, fill = hex_fill),
      strength = 0.5, size = 0, alpha = 1, radius = ggplot2::unit(4, 'mm')),
    id = "base") +
  ggplot2::scale_alpha_identity() +
  ggplot2::scale_fill_identity() +
  ggnewscale::new_scale_fill() +
  # Noise layer
  ggfx::with_blend(
    ggplot2::geom_raster(
      data = noise_data,
      ggplot2::aes(x, y, fill = noise),
      alpha = 0.125),
    bg_layer = "base",
    blend_type = "overlay") +
  ggfx::with_blend(
    ggplot2::geom_raster(
      data = noise_data,
      ggplot2::aes(x, y, fill = noise),
      alpha = 0.125),
    bg_layer = "base",
    blend_type = "linear_dodge") +
  ggplot2::scale_fill_gradientn(colours = noise_gradient) +
  ggplot2::coord_fixed(xlim = c(0, 12), ylim = c(0, 8), expand = FALSE) +
  ggplot2::theme_void() +
  ggplot2::theme(
    legend.position = "none",
    plot.background = ggplot2::element_rect(
      fill = bg_colour, colour = bg_colour),
    panel.background = ggplot2::element_rect(
      fill = panel_colour, colour = panel_colour),
    plot.margin = ggplot2::margin(10,10,10,10, unit = "pt"))

# Export to file ---------------------------------------------------------------

ggplot2::ggsave(
  here::here(glue::glue("img/{`iteration_id`}.png")),
  ggplot2::last_plot(), width = 6000, height = 4000, units = "px", dpi = 600,
  device = ragg::agg_png)

beepr::beep(2)