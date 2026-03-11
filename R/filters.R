############################
# FILTER BY GENE SYMBOL
############################

#' Filter catalog by gene symbol
#' @export
filter_gene <- function(catalog, gene){

  if (!"gene_symbol_list" %in% names(catalog)) {
    stop("Column 'gene_symbol_list' not found in catalog.")
  }

  gene <- toupper(gene)

  catalog[
    vapply(
      gene_symbol_list,
      function(x) gene %in% x,
      logical(1)
    )
  ]

}


############################
# FILTER PROTEIN CODING
############################

#' Keep protein-coding genes
#' @export
filter_protein_coding <- function(catalog){

  if (!all(c("type_of_gene","Symbol") %in% names(catalog))) {
    stop("Required columns 'type_of_gene' or 'Symbol' not found in catalog.")
  }

  catalog[
    type_of_gene == "protein-coding" &
      !grepl("^LOC", Symbol)
  ]

}


############################
# FILTER BY TRAIT
############################

#' Filter genes by disease trait
#' @export
filter_trait <- function(catalog, trait){

  if (!"disease_union" %in% names(catalog)) {
    stop("Column 'disease_union' not found in catalog.")
  }

  catalog[
    grepl(trait, disease_union, ignore.case = TRUE)
  ]

}


############################
# FILTER BY OMIM
############################

#' Filter genes by OMIM ID
#' @export
filter_omim <- function(catalog, omim){

  if (!"OmimIDs_ctdbase" %in% names(catalog)) {
    stop("Column 'OmimIDs_ctdbase' not found in catalog.")
  }

  pattern <- paste0("(^|\\|)", omim, "(\\||$)")

  catalog[
    !is.na(OmimIDs_ctdbase) &
      grepl(pattern, OmimIDs_ctdbase)
  ]

}
