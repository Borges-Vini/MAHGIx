#' Map physical to genetic positions (Rutgers Map v3)
#'
#' @name map_rutgers_positions
#' @param df Gene catalog dataframe
#' @param rutgers_dir Directory with Rutgers map files
#' @return Data frame with genetic positions
#' @export
map_rutgers_positions <- function(df, rutgers_dir) {

  final <- NULL

  for (chr in 1:22) {

    index <- df[df$chromosome == chr, ]

    rutgers_chr <- data.table::fread(
      file.path(rutgers_dir, paste0("RUMapv3_B137_chr", chr, ".txt"))
    )

    index$genetic_start_37 <- NA
    index$genetic_end_37 <- NA

    for (i in seq_len(nrow(index))) {

      s <- index$phy.pos_start_37[i]
      e <- index$phy.pos_end_37[i]

      if (!is.na(s)) {
        idx <- which.min(abs(rutgers_chr$Build37_start_physical_position - s))
        index$genetic_start_37[i] <- rutgers_chr$Build37_genetic_position[idx]
      }

      if (!is.na(e)) {
        idx <- which.min(abs(rutgers_chr$Build37_start_physical_position - e))
        index$genetic_end_37[i] <- rutgers_chr$Build37_genetic_position[idx]
      }
    }

    final <- rbind(final, index)
  }

  final
}
