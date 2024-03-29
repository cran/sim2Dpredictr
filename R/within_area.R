#' Determine Whether Lattice Points are Within or Without a Random Set
#'
#' Determine whether locations in the image/lattice (from \code{generate.grid})
#' are within or without the union of a random set generated by 
#' \code{sim2D_HPPP_coords()}. If the Euclidean distance between a lattice 
#' location and any 'event' is less than the radius about the 'event', then 
#' the location is said to be within the random set. Otherwise, it is without
#' the random set.
#'
#' @param grid.centers Output from \code{generate.grid()} that specifies the 
#' coordinates of the lattice locations in native space.
#' @param radii A vector of radii values.
#' @param event.xcoord,event.ycoord Paired vectors specifying the x- and 
#' y- coordinates, respectively, of each 'event' from the Poisson process.
#' @return A data frame with lattice x- and y- coordinates, and a binary vector
#' where 1 indicates the location is within the random set, and 0 indicates 
#' the location is without the random set.
#' @export
within_area <- function(grid.centers, radii, event.xcoord, event.ycoord) {
  nrow_grid_centers <- nrow(grid.centers)
  in.set <- rep(0,nrow_grid_centers)
  eucl.d2D <- function(x1, y1, x2, y2) sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
  length_radii <- length(radii)
  out.test <- rep(TRUE, length_radii)
  d <- matrix(c(0), nrow = nrow_grid_centers, ncol = length_radii)
  for (i in 1:nrow_grid_centers){
    for (j in 1:length_radii){
      d[i, j] <- eucl.d2D(grid.centers[i, 1], 
                          grid.centers[i, 2],
                          event.xcoord[j], 
                          event.ycoord[j])
    }
    #If each Euclidean distance is greater than each radii then assign 0; 
    # Otherwise, 1.
    if (identical(out.test, d[i, ] > radii) == TRUE) {
      in.set[i] <- 0
    }
    else {
      in.set[i] <- 1
    }
  }
  out <- data.frame(cbind(grid.centers, in.set))
  return(out)
}