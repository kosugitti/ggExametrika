# Global variable declarations to avoid R CMD check NOTEs for NSE
# (Non-Standard Evaluation) variables used in ggplot2 aes() and tidyr calls
utils::globalVariables(c(
  # plotArray_gg
  "value",
  # plotCMP_gg / plotRMP_gg
  "Membership",
  # plotCRV_gg
  "field", "class_num",
  # plotFCBR_gg
  "ClassRank", "Probability", "Boundary", "Field",
  # plotFCRP_gg
  "Category", "x", "xend", "y", "yend",
  # plotFRP_gg
  "Value",
  # plotFieldPIRP_gg
  "l", "k",
  # plotGraph_gg
  "node_type", "node_number", "node_size_val", "label_size_val",
  # plotICBR_gg / plotICRP_gg
  "Rank", "ItemLabel",
  # plotICC_overlay_gg / plotICRF_gg / plotIIC_gg / plotTIC_gg
  "theta", "probability", "information", "item", "category",
  # plotIIC_overlay_gg (uses theta, information, item - already listed)
  # plotIRP_gg
  "CRR",
  # plotLCD_gg / plotLRD_gg / plotTRP_gg
  "LC", "Num",
  # plotLDPSR_gg
  "item_pos", "class_type", "label",
  # plotRRV_gg
  "rank_num",
  # plotScoreField_gg
  "LatentLabel", "ExpectedScore",
  # plotScoreFreq_gg / plotScoreRank_gg
  "score", "count",
  # plotDistractor_gg
  "RankLabel", "Proportion"
))

#' @importFrom stats ave median setNames
#' @importFrom utils tail
#' @importFrom ggplot2 geom_segment sec_axis scale_fill_gradientn scale_x_reverse
#' @importFrom tidyr all_of
NULL
