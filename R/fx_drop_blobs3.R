drop_blobs3 <- function(
  seed_num, bg, x_lower, x_upper, y_lower, y_upper, colours){
  
  # Requires {scales}, {tibble}, and {dplyr}
  
  set.seed(seed_num)
  num_groups <- sample(seq(10, 20, by = 1), 1)
  
  num_points <- num_groups * 4
  
  x_integer_vec <- seq(x_lower, x_upper, length.out = 10)
  
  y_mid_bottom <- 0.7*((abs(y_upper - y_lower) / 2) + y_lower)
  y_mid_top <- 1.3*((abs(y_upper - y_lower) / 2) + y_lower)
  
  set.seed(seed_num)
  data <- tibble::tibble(
    x = sample(x_integer_vec, num_points, replace = TRUE),
    y = c(
      rep(sample(c(y_lower, y_mid_bottom), num_points / 4, replace = TRUE), each = 2),
      rep(sample(c(y_mid_top, y_upper), num_points / 4, replace = TRUE), each = 2)),
    group = rep(seq(1, num_groups, by = 1), each = 4))
  
  set.seed(seed_num)
  rel_group_aes <- data |>
    dplyr::distinct(group) |>
    dplyr::mutate(
      group_alpha = sample(
        seq(0, 0.4, by = 0.025), dplyr::n(), replace = TRUE),
      group_size = sample(
        seq(0.6, 4, by = 0.02), dplyr::n(), replace = TRUE),
      group_linetype = dplyr::case_when(
        group_size < 1.5 ~ "dotted",
        TRUE           ~ "solid"),
      group_colour = sample(colours, dplyr::n(), replace = TRUE),
      group_fill = sample(c(colours, bg), dplyr::n(), replace = TRUE))
  
  data_mod <- dplyr::left_join(data, rel_group_aes, by = "group")
  
  return(data_mod)
  
}