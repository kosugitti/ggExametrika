# Global variable declarations to avoid R CMD check NOTEs for NSE
# (Non-Standard Evaluation) variables used in ggplot2 aes() calls
utils::globalVariables(c("value"))
