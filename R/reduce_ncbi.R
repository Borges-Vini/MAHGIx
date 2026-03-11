#' @importFrom magrittr %>%
NULL

#' @import data.table
#' @importFrom data.table .SD
#' @importFrom data.table .N
NULL

collapse_refseq_table <- function(tbl){

  tbl |>
    dplyr::filter(`# feature` == "gene") |>
    dplyr::group_by(GeneID) |>
    dplyr::summarise(
      genomic_accessions = paste(unique(genomic_accession), collapse="|"),
      start = min(start, na.rm=TRUE),
      end   = max(end, na.rm=TRUE),
      assemblies = paste(unique(assembly_unit), collapse="|"),
      symbols = paste(unique(symbol), collapse="|"),
      names   = paste(unique(name), collapse="|"),
      .groups="drop"
    )
}
