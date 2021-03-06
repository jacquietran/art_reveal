drop_blobs2 <- function(
  seed_num, bg, x_lower, x_upper, y_lower, y_upper, colours,
  groups_min, groups_max){
  
  # Requires {scales}, {tibble}, and {dplyr}
  
  if(missing(groups_min)){
    groups_min <- 5
  }
  
  if(missing(groups_max)){
    groups_max <- 8
  }
  
  set.seed(seed_num)
  num_groups <- sample(seq(groups_min, groups_max, by = 1), 1)
  
  num_points <- num_groups * 4
  
  x_integer_vec <- seq(x_lower, x_upper, length.out = 10)
  
  set.seed(seed_num)
  data <- tibble::tibble(
    x = sample(x_integer_vec, num_points, replace = TRUE),
    y = rep(
      sample(c(y_lower, y_upper), num_points / 2, replace = TRUE), each = 2),
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