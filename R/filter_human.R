#' Filter human genes (tax_id = 9606)
#'
#' @name filter_human_9606
#' @param gene_info NCBI gene_info table
#' @param gene_neighbors gene_neighbors table
#' @param gene2accession gene2accession table
#' @return A list of filtered tables
#' @export
filter_human_9606 <- function(gene_info, gene_neighbors, gene2accession) {

  list(
    gene_info = dplyr::filter(gene_info, `#tax_id` == "9606"),
    gene_neighbors = dplyr::filter(gene_neighbors, `#tax_id` == "9606"),
    gene2accession = dplyr::filter(gene2accession, `#tax_id` == "9606")
  )
}
