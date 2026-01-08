reduce_gene_info <- function(gene_info) {
  dplyr::select(
    gene_info,
    GeneID, chromosome, Symbol, Synonyms,
    description, dbXrefs, map_location, type_of_gene
  )
}

reduce_feature_table <- function(tbl) {
  tbl |>
    dplyr::filter(`# feature` == "gene") |>
    dplyr::select(
      GeneID, class, start, end,
      assembly_unit, symbol, name, genomic_accession
    )
}
