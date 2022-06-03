blobs_and_tiles <- function(
  arrangement = c("5x5", "10x10", "15x15", "20x20"), seed_vec, bg, colours,
  groups_min, groups_max){
  
  # Requires {purrr}, {tibble}, {dplyr}, {glue}
  # and custom function drop_blobs2()
  
  if(arrangement == "5x5"){
    n_tiles <- 25
    n_across <- 5
  }
  if(arrangement == "10x10"){
    n_tiles <- 100
    n_across <- 10
  }
  if(arrangement == "15x15"){
    n_tiles <- 225
    n_across <- 15
  }
  if(arrangement == "20x20"){
    n_tiles <- 400
    n_across <- 20
  }
  
  if(missing(groups_min)){
    groups_min <- 5
  }
  if(missing(groups_max)){
    groups_max <- 8
  }
  
  set.seed(seed_vec)
  selected_seeds <- sample(seq(1, 5000000, by = 1), n_tiles, replace = FALSE)
  
  xy_pos <- tibble::tibble(
    seed_num = selected_seeds,
    x_lower = rep(seq(1, ((n_across * 5) - 4), by = 5), times = n_across),
    x_upper = rep(seq(5, (n_across * 5), by = 5), times = n_across),
    y_lower = rep(seq(1, ((n_across * 5) - 4), by = 5), each = n_across),
    y_upper = rep(seq(5, (n_across * 5), by = 5), each = n_across))
  
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
  
  return(blobs)
  
}