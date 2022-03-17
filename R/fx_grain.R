mimic_grain <- function(seed_num, lower, upper, grain, n_lines){
  
  # Requires {tibble} and {dplyr}
  
  weights <- c(0.2, 0.2, 0.15, 0.15, 0.05, 0.05, 0.05, 0.05, 0.02, 0.02, 0.02,
               0.02, 0.01, 0.01)
  
  set.seed(seed_num)
  data <- tibble::tibble(
    x = rep(seq(lower, upper, length.out = grain), times = n_lines),
    y = rep(seq(lower, upper, length.out = n_lines), each = grain)) |>
    dplyr::mutate(
      point_size = sample(
        seq(0.05, 0.7, by = 0.05), dplyr::n(), replace = TRUE, prob = weights))
  
  return(data)
  
}