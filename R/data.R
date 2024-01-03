#' Five arithmetic moves to combine 6 numbers
#'
#' Given the numbers 1, 2, 2, 4, 5, 7; how can you combine them with 
#'   addition, subtraction, multiplication, and division, in any order,
#'   such that each intermediate step is always a positive integer?
#'   This dataset lists all such unique permutations, and the results can
#'   be quickly calculated.
#'
#' @format
#' A character vector with 260,343 elements:
#' \itemize{
#'   \item{\eqn{(((((1*2)*2)*4)-5)-7)}}
#'   \item{\eqn{(((((1*2)*2)*4)-5)*7)}}
#'   \item{\eqn{(((((1*2)*2)*4)-5)+7)}}
#'   \item{\eqn{...}}
#'   \item{\eqn{(7/(5/((2+4)-(2-1))))}}
#'   \item{\eqn{(7/(5/((4-(2-1))+2)))}}
#'   \item{\eqn{(7/(5/((4/(2/2))+1)))}}
#' }
#' 
#' @examples
#' moves <- data.frame(string = five_moves)
#' moves$result <- fasteval(moves$string)
#' head(moves)
"five_moves"