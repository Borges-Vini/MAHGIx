#' Parse gene symbols from GWAS catalog
#' @noRd
#' @importFrom data.table :=
#' @importFrom data.table setDT
#' @importFrom data.table uniqueN
#' @import stringr
NULL

parse_genes <- function(x){

  x %>%
    toupper() %>%
    stringr::str_replace_all(" - ", ",") %>%
    stringr::str_replace_all("-", ",") %>%
    stringr::str_replace_all(";", ",") %>%
    stringr::str_split(",") %>%
    unlist() %>%
    stringr::str_trim() %>%
    purrr::discard(~ .x == "" | .x == "NR")
}

#' Build GWAS gene annotations
#' @export
#'

build_gwas_annotation <- function(gwas, symbol_dicionary){

  gwas_long <- gwas[
    ,
    .(gene_symbol = parse_genes(paste(`REPORTED GENE(S)`, `MAPPED_GENE`, sep=",")),
      trait = `DISEASE/TRAIT`,
      pvalue = `P-VALUE`,
      snp = SNPS),
    by = .I
  ]

  gwas_annot <- merge(
    gwas_long,
    symbol_dicionary,
    by.x = "gene_symbol",
    by.y = "all_symbols",
    allow.cartesian = TRUE
  )

  gwas_gene <- gwas_annot[
    ,
    .(
      GWAS_Traits = paste(unique(trait), collapse="|"),
      GWAS_SNPs   = paste(unique(snp), collapse="|"),
      GWAS_nTraits = uniqueN(trait)
    ),
    by = GeneID
  ]


  return(gwas_gene)

}
