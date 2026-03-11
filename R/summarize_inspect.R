
############################
# SUMMARIZE GENE CATALOG
############################

#' Provides a quick overview of the gene catalog contents.
#'
#' @param catalog Gene catalog generated with build_gene_catalog()
#'
#' @export
summary_gene_catalog <- function(catalog){

  if (!"GeneID" %in% names(catalog)) {
    stop("Input does not appear to be a valid gene catalog.")
  }

  n_genes <- nrow(catalog)

  n_protein_coding <- sum(
    catalog$type_of_gene == "protein-coding",
    na.rm = TRUE
  )

  n_traits <- sum(
    !is.na(catalog$GWAS_traits),
    na.rm = TRUE
  )

  n_ctd <- sum(
    !is.na(catalog$DiseaseNames_ctdbase),
    na.rm = TRUE
  )

  n_gwas_snps <- sum(
    !is.na(catalog$GWAS_SNPs),
    na.rm = TRUE
  )

  cat("\nGene Catalog Summary\n")
  cat("---------------------\n")
  cat("Total genes:", n_genes, "\n")
  cat("Protein-coding genes:", n_protein_coding, "\n")
  cat("Genes with GWAS traits:", n_traits, "\n")
  cat("Genes with CTD disease links:", n_ctd, "\n")
  cat("Genes with GWAS SNPs:", n_gwas_snps, "\n\n")
}

############################
# INSPECTING GENE CATALOG
############################

#' Provides an extended overview of the gene catalog structure and annotation coverage.
#'
#' @param catalog Gene catalog generated with build_gene_catalog()
#'
#' @export

inspect_gene_catalog <- function(catalog){

  if (!"GeneID" %in% names(catalog)) {
    stop("Input does not appear to be a valid gene catalog.")
  }

  cat("\n==============================\n")
  cat(" Gene Catalog Inspection\n")
  cat("==============================\n\n")

  cat("Dimensions\n")
  cat("----------\n")
  cat("Genes:", nrow(catalog), "\n")
  cat("Columns:", ncol(catalog), "\n\n")

  cat("Gene Types\n")
  cat("----------\n")

  if ("type_of_gene" %in% names(catalog)) {

    gene_types <- sort(table(catalog$type_of_gene), decreasing = TRUE)

    print(gene_types)

  } else {

    cat("Column 'type_of_gene' not found\n")

  }

  cat("\nAnnotation Coverage\n")
  cat("-------------------\n")

  check_col <- function(col){

    if (col %in% names(catalog)) {

      sum(!is.na(catalog[[col]]))

    } else {

      NA

    }

  }

  cat("Genes with GWAS traits:", check_col("GWAS_traits"), "\n")
  cat("Genes with GWAS SNPs:", check_col("GWAS_SNPs"), "\n")
  cat("Genes with CTD diseases:", check_col("DiseaseNames_ctdbase"), "\n")
  cat("Genes with OMIM IDs:", check_col("omim_ids_NCBI"), "\n")

  cat("\nTop GWAS Traits\n")
  cat("----------------\n")

  if ("GWAS_traits" %in% names(catalog)) {

    traits <- unlist(strsplit(
      catalog$GWAS_traits[!is.na(catalog$GWAS_traits)],
      "\\|"
    ))

    top_traits <- sort(table(traits), decreasing = TRUE)[1:10]

    print(top_traits)

  } else {

    cat("Column 'GWAS_traits' not found\n")

  }

  cat("\nCatalog Columns\n")
  cat("----------------\n")

  print(names(catalog))

  if (!is.null(attr(catalog, "metadata"))) {

    cat("\nMetadata\n")
    cat("--------\n")

    print(attr(catalog, "metadata"))

  }

  cat("\n==============================\n\n")

  invisible(NULL)

}
