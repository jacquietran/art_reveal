drop_blobs <- function(
  seed_num, bg, palette, x_lower, x_upper, y_lower, y_upper){
  
  # Requires {scales}, {tibble}, and {dplyr}
  
  set.seed(seed_num)
  num_groups <- sample(seq(30, 100, by = 5), 1)
  
  num_points <- num_groups * 4
  
  x_integer_vec <- seq(x_lower, x_upper, length.out = 10)
  
  set.seed(seed_num)
  data <- tibble::tibble(
    x = sample(x_integer_vec, num_points, replace = TRUE),
    y = rep(
      sample(c(y_lower, y_upper), num_points / 2, replace = TRUE), each = 2),
    group = rep(seq(1, num_groups, by = 1), each = 4),
    hex_fill = sample(colour_vec, num_points, replace = TRUE))
  
  set.seed(seed_num)
  rel_groups_sets <- data |>
    dplyr::distinct(group) |>
    dplyr::mutate(
      set_num = sample(c(1, 2, 3), dplyr::n(), replace = TRUE))
  
  data_mod <- dplyr::left_join(data, rel_groups_sets, by = "group")
  
  set1 <- data_mod |>
    dplyr::filter(set_num == 1)
  
  set2 <- data_mod |>
    dplyr::filter(set_num != 1)
  
  return(list(
    "combined" = data_mod,
    "set1" = set1,
    "set2" = set2))
  
}