#' MAHGIx quick start
#'
#' Runs a full example of the MAHGIx workflow:
#' building the catalog, inspecting it, and applying filters.
#'
#' @export

hello <- function(){

  cat("\n=============================\n")
  cat(" MAHGIx Quick Start\n")
  cat("=============================\n\n")

  cat("Building gene catalog...\n")

  catalog <- build_gene_catalog()

  cat("\nCatalog built successfully.\n\n")

  summary_gene_catalog(catalog)

  cat("\nInspecting catalog structure...\n\n")

  inspect_gene_catalog(catalog)

  cat("\nExample queries\n")
  cat("----------------\n")

  cat("\n1. Filter protein-coding genes\n")

  pc <- filter_protein_coding(catalog)

  cat("Protein-coding genes:", nrow(pc), "\n")

  cat("\n2. Search gene symbol (ACE)\n")

  print(filter_gene(catalog, "ACE"))

  cat("\n3. Filter by disease trait\n")

  eh <- filter_trait(catalog, "essential hypertension")

  cat("Genes associated with essential hypertension:", nrow(eh), "\n")

  cat("\n4. Filter by OMIM ID\n")

  omim <- filter_omim(catalog, "145500")

  cat("Genes linked to OMIM 145500:", nrow(omim), "\n")

  cat("\nQuick start complete.\n\n")

  invisible(catalog)

}
