blobs_and_tiles <- function(n_tiles = c(225, 400), seed_vec, bg, colours){
  
  # Requires {purrr}, {tibble}, {dplyr}, {glue}
  # and custom function drop_blobs2()
  
  set.seed(seed_vec)
  selected_seeds <- sample(seq(1, 5000000, by = 1), n_tiles, replace = FALSE)
  
  if(n_tiles == 225){
    
    xy_pos <- tibble::tibble(
      seed_num = selected_seeds,
      x_lower = rep(seq(1, 71, by = 5), times = 15),
      x_upper = rep(seq(5, 75, by = 5), times = 15),
      y_lower = rep(seq(1, 71, by = 5), each = 15),
      y_upper = rep(seq(5, 75, by = 5), each = 15))
    
  }
  
  if(n_tiles == 400){
    
    xy_pos <- tibble::tibble(
      seed_num = selected_seeds,
      x_lower = rep(seq(1, 96, by = 5), times = 20),
      x_upper = rep(seq(5, 100, by = 5), times = 20),
      y_lower = rep(seq(1, 96, by = 5), each = 20),
      y_upper = rep(seq(5, 100, by = 5), each = 20))
    
  }
  
  
  purrr::map_df(selected_seeds, function(i) {
   
    xy_pos_filtered <- xy_pos |>
      dplyr::filter(seed_num == i)
    
    data <- drop_blobs2(
      seed_num = i, bg = bg, colours = colours,
      x_lower = xy_pos_filtered$x_lower,
      x_upper = xy_pos_filtered$x_upper,
      y_lower = xy_pos_filtered$y_lower,
      y_upper = xy_pos_filtered$y_upper)
    
    data_mod <- data |>
      dplyr::mutate(
        seed_num = i,
        grouping_var = glue::glue({"{seed_num}_{group}"}))
     
  }) -> blobs
  
}