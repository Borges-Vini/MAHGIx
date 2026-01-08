#' Build full human gene catalog
#'
#' Download, process, and integrate NCBI gene resources
#' into a unified human gene catalog.
#'
#' @name build_gene_catalog
#' @param outdir Output directory
#' @return A data.frame with the gene catalog
#' @export
build_gene_catalog <- function(outdir = ".") {

  ncbi <- download_ncbi_data()

  human <- filter_human_9606(
    ncbi$gene_info,
    ncbi$gene_neighbors,
    ncbi$gene2accession
  )

  gene_info <- reduce_gene_info(human$gene_info)

  table37 <- reduce_feature_table(ncbi$table37)
  table38 <- reduce_feature_table(ncbi$table38)
  tableT2T <- reduce_feature_table(ncbi$tableT2T)

  catalog <- dplyr::left_join(gene_info, table38, by = "GeneID")

  catalog[is.na(catalog)] <- "-"
  catalog[catalog == ""] <- "-"

  outfile <- file.path(outdir, "gene_catalog_dataframe.tsv")
  data.table::fwrite(catalog, outfile, sep = "\t")

  catalog
}
