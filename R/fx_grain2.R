mimic_grain2 <- function(seed_num, lower, upper, grain, n_lines, colours){
  
  # Requires {scales}, {tibble} and {dplyr}
  
  weights <- tibble::tibble(
    values_init = c(
      rep(0.5, times = 10),
      rep(0.3, times = 10),
      rep(0.1, times = 5),
      rep(0.05, times = 5))) |>
    dplyr::mutate(
      values_sum = sum(values_init),
      values_pct = values_init / values_sum) |>
    dplyr::select(values_pct) |>
    dplyr::pull()
  
  set.seed(seed_num)
  data <- tibble::tibble(
    x = rep(seq(lower, upper, length.out = grain), times = n_lines),
    y = rep(seq(lower, upper, length.out = n_lines), each = grain)) |>
    dplyr::mutate(
      point_size = sample(
        seq(0.05, 1.5, by = 0.05), dplyr::n(), replace = TRUE, prob = weights),
      point_colour = sample(colours, dplyr::n(), replace = TRUE),
      to_delete = sample(
        c("yes", "no"), dplyr::n(), replace = TRUE, prob = c(0.85, 0.15))) |>
    dplyr::filter(to_delete == "no")
  
  return(data)
  
}