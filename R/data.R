#' Four arithmetic moves to combine 5 numbers
#'
#' Given the numbers 1, 2, 4, 5, 7; how can you combine them with 
#'   addition, subtraction, multiplication, and division, in any order,
#'   such that each intermediate step is always a positive integer?
#'   This dataset lists all such permutations, and the results can
#'   be quickly calculated.
#'
#' @format
#' A character vector with 25,563 elements:
#' \itemize{
#'   \item{\code{((((1*2)*4)-5)*7)}}
#'   \item{\code{((((1*2)*4)-5)+7)}}
#'   \item{\code{((((1*2)*4)-7)*5)}}
#'   \item{\code{...}}
#' }
#' 
#' @examples
#' moves <- data.frame(string = four_moves)
#' moves$result <- fasteval(moves$string)
#' head(moves)
"four_moves"