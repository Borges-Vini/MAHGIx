#' MAHGIx: Integrated Human Gene Catalog
#'
#' MAHGIx is an R package for building and exploring an integrated human
#' gene catalog that combines annotations from multiple biomedical
#' databases.
#'
#' The package automatically downloads, parses, and integrates data from
#' several authoritative genomic resources, allowing users to rapidly
#' explore gene–trait associations, disease annotations, and genomic
#' metadata.
#'
#' MAHGIx is designed to support:
#'
#' \itemize{
#' \item genetic epidemiology
#' \item GWAS interpretation
#' \item disease gene prioritization
#' \item exploratory genomic analysis
#' \item educational bioinformatics workflows
#' }
#'
#' @section Integrated Databases:
#'
#' MAHGIx integrates information from multiple public databases:
#'
#' \itemize{
#' \item \strong{NCBI Gene} — gene identifiers, symbols, synonyms, gene types and functional descriptions
#' \item \strong{GWAS Catalog} — associations between genetic variants and complex traits
#' \item \strong{CTDbase} — curated gene–disease relationships
#' \item \strong{HGNC} — official human gene nomenclature
#' \item \strong{RefSeq assemblies} — genomic coordinates across GRCh38, GRCh37 and T2T-CHM13
#' }
#'
#' These resources are harmonized into a unified catalog where each row
#' represents a gene and contains multiple layers of annotation.
#'
#' @section Building the Gene Catalog:
#'
#' The central function of the package is:
#'
#' \code{build_gene_catalog()}
#'
#' This function:
#'
#' \enumerate{
#' \item downloads annotation datasets
#' \item parses and cleans source databases
#' \item harmonizes gene identifiers and synonyms
#' \item integrates GWAS and disease annotations
#' \item builds a unified gene catalog
#' }
#'
#' The catalog is automatically cached locally to avoid rebuilding it in
#' future sessions.
#'
#' @section Exploring the Catalog:
#'
#' MAHGIx includes tools to inspect and summarize the catalog:
#'
#' \itemize{
#' \item \code{summary_gene_catalog()} — summary statistics
#' \item \code{inspect_gene_catalog()} — detailed catalog inspection
#' }
#'
#' @section Filtering Utilities:
#'
#' The catalog can be filtered using several helper functions:
#'
#' \itemize{
#' \item \code{filter_gene()} — search by gene symbol or synonym
#' \item \code{filter_trait()} — filter by disease or GWAS trait
#' \item \code{filter_protein_coding()} — keep only protein-coding genes
#' \item \code{filter_omim()} — filter genes by OMIM identifier
#' }
#'
#' @section Typical Workflow:
#'
#' A typical MAHGIx analysis follows these steps:
#'
#' \enumerate{
#' \item Build the catalog
#' \item Inspect its structure
#' \item Filter genes relevant to the analysis
#' }
#'
#' @examples
#'
#' library(MAHGIx)
#'
#' # Build the integrated gene catalog
#' catalog <- build_gene_catalog()
#'
#' # Inspect the catalog
#' summary_gene_catalog(catalog)
#' inspect_gene_catalog(catalog)
#'
#' # Restrict to protein-coding genes
#' pc_catalog <- filter_protein_coding(catalog)
#'
#' # Identify genes associated with hypertension
#' htn <- filter_trait(pc_catalog, "hypertension")
#'
#' # Query a candidate gene
#' filter_gene(htn, "ACE")
#'
#' @seealso
#' \code{\link{build_gene_catalog}},
#' \code{\link{filter_gene}},
#' \code{\link{filter_trait}},
#' \code{\link{filter_protein_coding}},
#' \code{\link{filter_omim}},
#' \code{\link{hello}}
#'
#' @docType package
#' @name MAHGIx
#' @keywords internal
"_PACKAGE"
NULL