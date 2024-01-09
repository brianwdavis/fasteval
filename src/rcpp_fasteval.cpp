#include <Rcpp.h>
using namespace Rcpp;


#include "tinyexpr.h"
#include <stdio.h>

// [[Rcpp::export]]
NumericVector eval_(CharacterVector strings, LogicalVector quiet) {
  NumericVector res (strings.length());
  char * expression_string;
  int err;
  
  for (int i = 0; i < strings.length(); i++) {
    expression_string = strings[i];
    res[i] = te_interp(expression_string, &err); 
    if (err && !quiet[0]) {
      warning("NA generated at element %d, '%s'", i, expression_string);
    }
  }
  return res;
}


// [[Rcpp::export]]
NumericVector eval_vars_(
    CharacterVector strings, 
    List list_of_values, 
    LogicalVector quiet
  ) {
  int err;
  int num_vars = list_of_values.length();
  
  // Get the longest argument
  int strings_length = strings.length();
  int longest = std::max(0, strings_length);
  for (int i = 0; i < num_vars; i++) {
    NumericVector elt = list_of_values[i];
    int elt_l = elt.length();
    longest = std::max(longest, elt_l);
  }
  NumericVector res (longest);
  
  StringVector nms = list_of_values.names();
  
  // For each element of each argument, compile and evaluate
  for (int i = 0; i < longest; i++) {
    
    // Make an array of variables
    // Then put a name and pointer struct for each variable
    te_variable vars[num_vars];
    
    for (int j = 0; j < num_vars; j++) {
      NumericVector vals_j = list_of_values[j];
      int v_idx;
      // If a list-elt doesn't have the same length as the longest 
      //   arg, just use the first
      if (vals_j.length() == longest) {
        v_idx = i;
      } else if (vals_j.length() == 1) {
        v_idx = 0;
      } else {
        stop("Incompatible `%s` length, must be 1 or %i", as<std::string>(nms[j]), longest);
      }
      vars[j] = { nms[j], &vals_j[v_idx] };
    }

    // Choose expression and compile it
    char * expression_string;
    if (strings.length() == longest) {
      expression_string = strings[i];
    } else if (strings.length() == 1) {
      expression_string = strings[0];
    } else {
      stop("Incompatible string length, must be 1 or %i", longest);
    }
    te_expr *expr = te_compile(expression_string, vars, num_vars, &err);
    
    if (expr) {
      res[i] = te_eval(expr);
      te_free(expr);
    } else {
      res[i] = NA_REAL;
      if (!quiet[0]) {
        warning("\nNA generated at element %d, '%s': error at character %d\n", i, expression_string, err);
      }
    }
  }
  return res;
  
}

// NumericVector eval_vars_once_(
//     CharacterVector strings, 
//     List list_of_values, 
//     LogicalVector quiet
// ) {
//   int err;
//   int num_vars = list_of_values.length();
//   
//   // Get the longest argument
//   //int strings_length = strings.length();
//   int longest = 0;
//   for (int i = 0; i < num_vars; i++) {
//     NumericVector elt = list_of_values[i];
//     int elt_l = elt.length();
//     longest = std::max(longest, elt_l);
//   }
//   NumericVector res (longest);
//   
//   StringVector nms = list_of_values.names();
//   
//   // Make an array of variables
//   // Then put a name and pointer struct for each variable
//   te_variable vars[num_vars];
//   NumericVector values_at_i (num_vars);
//   
//   char * expression_string;
//   expression_string = strings[0];
//   
//   for (int j = 0; j < num_vars; j++) {
//     NumericVector vals_j = list_of_values[j];
//     int v_idx = 0;
//     values_at_i[j] = vals_j[v_idx];
//     vars[j] = { nms[j], &values_at_i[j] };
//   }
//   // Compile expression once with the pointers to the first values
//   te_expr *expr = te_compile(expression_string, vars, num_vars, &err);
//   
//   // For each element of each argument, evaluate
//   if (expr) {
//     for (int i = 0; i < longest; i++) {
//       for (int j = 0; j < num_vars; j++) {
//         NumericVector vals_j = list_of_values[j];
//         int v_idx = i;
//         values_at_i[j] = vals_j[v_idx];
//       }
//       res[i] = te_eval(expr);
//     }
//     te_free(expr);
//   } else {
//     for (int i = 0; i < longest; i++) {
//       res[i] = NA_REAL;
//       if (!quiet[0]) {
//         warning("\nNA generated at element %d, '%s': error at character %d\n", i, expression_string, err);
//       }
//     }
//   }
//   return res;
//   
// }