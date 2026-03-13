#' Build integrated human gene catalog
#'
#' Downloads required datasets if missing, builds the catalog,
#' and caches the result for fast reuse.
#'
#' @import data.table
#' @param path Cache directory
#'
#' @export
build_gene_catalog <- function(
    path = tools::R_user_dir("MAHGIx", which = "cache")
) {

  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }

  catalog_file <- file.path(path, "gene_catalog.rds")

  # ⭐ LOAD CACHED VERSION (VERY IMPORTANT)
  if (file.exists(catalog_file)) {

    message("✔ Loading cached gene catalog")

    return(readRDS(catalog_file))
  }

  # ⭐ AUTO DOWNLOAD
  required_files <- c(
    "gene_info_9606.tsv",
    "gene_neighbors_9606.tsv",
    "gene2accession_9606.tsv",
    "gwas.tsv",
    "ctd.tsv",
    "hgnc.gz",
    "table37.gz",
    "table38.gz",
    "tableT2T.gz"
  )

  missing <- !file.exists(file.path(path, required_files))

  if (any(missing)) {

    message("Data not found. Downloading required files...")
    download_gene_catalog_data(path)

  }

  message("Building gene catalog...")

  ############################
  # NCBI
  ############################

  message("Parsing NCBI gene information...", appendLF = FALSE)
  gene_info <- data.table::fread(file.path(path, "gene_info_9606.tsv"))
  r_homo <- dplyr::select(gene_info, GeneID, chromosome, Symbol, Synonyms, description, dbXrefs, map_location, type_of_gene)
  rm(gene_info)
  gc(); message(" Done!")

#gene2accession
  message("Parsing NCBI gene2accession...", appendLF = FALSE)
  gene2accession <- data.table::fread(file.path(path, "gene2accession_9606.tsv"))
  data.table::setDT(gene2accession)
  gene2accession_collapsed <- gene2accession |>
    dplyr::group_by(GeneID) |>
    dplyr::summarise(
      assemblies = paste(unique(assembly), collapse="|"),
      genomic_accessions = paste(unique(genomic_nucleotide_accession.version), collapse="|"),
      rna_accessions = paste(unique(RNA_nucleotide_accession.version), collapse="|"),
      protein_accessions = paste(unique(protein_accession.version), collapse="|"),
      .groups = "drop"
    )

  rm(gene2accession)
  gc(); message(" Done!")

#gene_neighbors
  message("Parsing NCBI gene neighbors...", appendLF = FALSE)
  gene_neighbors <- data.table::fread(file.path(path, "gene_neighbors_9606.tsv"))
  data.table::setDT(gene_neighbors)
  gene_neighbors_collapsed <- gene_neighbors |>
    dplyr::group_by(GeneID) |>
    dplyr::summarise(
      neighbors_left = paste(unique(GeneIDs_on_left), collapse="|"),
      neighbors_right = paste(unique(GeneIDs_on_right), collapse="|"),
      overlapping_neighbors = paste(unique(overlapping_GeneIDs), collapse="|"),
      assemblies_neighbors = paste(unique(assembly), collapse="|"),
      .groups = "drop"
    )
  rm(gene_neighbors)
  gc(); message(" Done!")

#table37
  message("Parsing NCBI GRCh37 data...", appendLF = FALSE)
  table37 <- data.table::fread(file.path(path, "table37.gz"), sep = "\t")
  table37_gene <- collapse_refseq_table(table37)
  data.table::setnames(table37_gene,setdiff(names(table37_gene), "GeneID"),paste0(setdiff(names(table37_gene), "GeneID"), "_GRCh37"))
  rm(table37)
  gc(); message(" Done!")

#table38
  message("Parsing NCBI GRCh38 data...", appendLF = FALSE)
  table38 <- data.table::fread(file.path(path, "table38.gz"), sep = "\t")
  table38_gene <- collapse_refseq_table(table38)
  data.table::setnames(table38_gene,setdiff(names(table38_gene), "GeneID"),paste0(setdiff(names(table38_gene), "GeneID"), "_GRCh38"))
  rm(table38)
  gc(); message(" Done!")

#tableT2T
  message("Parsing NCBI T2T data...", appendLF = FALSE)
  tableT2T <- data.table::fread(file.path(path, "tableT2T.gz"), sep = "\t")
  tableT2T_gene <- collapse_refseq_table(tableT2T)
  data.table::setnames(tableT2T_gene,setdiff(names(tableT2T_gene), "GeneID"),paste0(setdiff(names(tableT2T_gene), "GeneID"), "_T2T"))
  rm(tableT2T)
  gc(); message(" Done!")

  ############################
  # HGNC
  ############################

  message("Reading HGNC data...", appendLF = FALSE)
  hgnc <- data.table::fread(file.path(path, "hgnc.gz"))
  message(" Done!")

  ############################
  # CTD
  ############################

  message("Parsing CTD data...", appendLF = FALSE)
  ctd <- data.table::fread(file.path(path, "ctd.tsv"),   sep = "\t",quote = "")

  data.table::setnames(ctd, c(
    "GeneSymbol","GeneID","DiseaseName","DiseaseID",
    "DirectEvidence","InferenceChemicalName",
    "InferenceScore","OmimIDs","PubMedIDs"
  ))
  data.table::setDT(ctd)
  ctd <- ctd[ctd[["DirectEvidence"]] == "marker/mechanism", ]

  ctd$DiseaseID <- sub("^MESH:", "", ctd$DiseaseID)

  ctdbase_collapsed <- ctd |>
    dplyr::group_by(GeneID) |>
    dplyr::summarise(
      DiseaseNames_ctdbase = paste(unique(DiseaseName), collapse="|"),
      DiseaseIDs_ctdbase   = paste(unique(DiseaseID), collapse="|"),
      OmimIDs_ctdbase      = paste(unique(OmimIDs), collapse="|"),
      .groups="drop"
    )
  rm(ctd)
  gc(); message(" Done!")

  ############################
  # SYMBOL DICTIONARY
  ############################

  message("Building symbol dictionaty...", appendLF = FALSE)
  symbol_dicionary <- r_homo %>%
    dplyr::select(GeneID, Symbol, Synonyms) %>%
    dplyr::mutate(
      Synonyms = ifelse(is.na(Synonyms), "", Synonyms),
      all_symbols = paste(Symbol, Synonyms, sep="|")
    ) %>%
    tidyr::separate_rows(all_symbols, sep="\\|") %>%
    dplyr::mutate(
      all_symbols = stringr::str_trim(all_symbols),
      all_symbols = toupper(all_symbols)
    ) %>%
    dplyr::filter(all_symbols != "")

  aliases <- symbol_dicionary %>%
    dplyr::mutate(
      alias = gsub("[-\\. ]", "", all_symbols)
    ) %>%
    dplyr::filter(alias != all_symbols) %>%
    dplyr::mutate(all_symbols = alias) %>%
    dplyr::select(GeneID, Symbol, Synonyms, all_symbols)

  symbol_dicionary <- dplyr::bind_rows(
    symbol_dicionary,
    aliases
  ) %>%
    dplyr::distinct(GeneID, Symbol, Synonyms, all_symbols)

  message(" Done!")
  ############################
  # GWAS
  ############################

  message("Parsing GWAS Catalog data...", appendLF = FALSE)
  gwas <- data.table::fread(file.path(path,"gwas.tsv"), sep="\t", quote = "", fill=TRUE)
  data.table::setDT(gwas)

  gwas_gene <- build_gwas_annotation(gwas, symbol_dicionary)

  rm(gwas)
  gc(); message(" Done!")

  ############################
  # FAST JOINS (data.table)
  ############################

  message("Building integrated gene catalog...", appendLF = FALSE)

  data.table::setDT(r_homo)

  catalog_base <- merge(r_homo, gene2accession_collapsed, by="GeneID", all.x=TRUE)
  rm(r_homo); rm(gene2accession_collapsed); gc();
  catalog_base <- merge(catalog_base, gene_neighbors_collapsed, by="GeneID", all.x=TRUE)
  rm(gene_neighbors_collapsed); gc();
  catalog_base <- merge(catalog_base, table38_gene, by="GeneID", all.x=TRUE)
  rm(table38_gene); gc();
  catalog_base$Gene_Size_GRCh38 <- (catalog_base$end_GRCh38 - catalog_base$start_GRCh38) + 1
  catalog_base <- merge(catalog_base, table37_gene, by="GeneID", all.x=TRUE)
  rm(table37_gene); gc();
  catalog_base <- merge(catalog_base, tableT2T_gene, by="GeneID", all.x=TRUE)
  rm(tableT2T_gene); gc();
  catalog_base <- merge(catalog_base, ctdbase_collapsed, by="GeneID", all.x=TRUE)
  rm(ctdbase_collapsed); gc();
  catalog_base$CTD_nDiseases <- sapply(strsplit(catalog_base$DiseaseNames_ctdbase, "\\|"),function(x){
    x <- trimws(x)
    x <- x[x != "" & !is.na(x)]
    length(unique(x))})
  catalog_base <- merge(catalog_base, gwas_gene, by="GeneID", all.x=TRUE)
  rm(gwas_gene); gc();
  catalog_base$GWAS_nTraits <- sapply(strsplit(unique(catalog_base$GWAS_Traits), "\\|"),function(x){
    x <- trimws(x)
    x <- x[x != "" & !is.na(x)]
    length(unique(x))})
  catalog_base$GWAS_nSNPs <- sapply(strsplit(catalog_base$GWAS_SNPs, "\\|"),function(x){
    x <- x[x != "" & !is.na(x)]
    length(unique(x))})

  catalog_base$gene_symbol_list <- strsplit(
    toupper(paste(
      catalog_base$Symbol,
      catalog_base$symbols_GRCh38,
      catalog_base$symbols_GRCh37,
      catalog_base$symbols_T2T,
      sep="|"
    )),
    "\\|"
  )

  message(" Done!")

  ############################
  # DISEASE UNION
  ############################

  message("Concatenating traits into the catalog...", appendLF = FALSE)
  catalog_base$disease_union <- apply(
    catalog_base[, c("DiseaseNames_ctdbase","GWAS_traits","description")],
    1,
    function(x){
      x <- x[!is.na(x) & x!=""]
      paste(unique(x), collapse="|")
    }
  )

  catalog_base$Total_nTraits <- sapply(strsplit(unique(catalog_base$disease_union), "\\|"),function(x){
    x <- trimws(x)
    x <- x[x != "" & !is.na(x)]
    length(unique(x))})
  catalog_base$Has_Disease_Annot <- catalog_base$Total_nTraits > 0

   message(" Done!")


  ############################
  # SAVE CACHE
  ############################

  metadata <- list(
    build_date = Sys.time(),
    data_sources = c(
      "NCBI gene_info",
      "NCBI gene_neighbors",
      "NCBI gene2accession",
      "GWAS catalog",
      "CTDbase",
      "HGNC"
    )
  )

  attr(catalog_base, "metadata") <- metadata

  saveRDS(catalog_base, catalog_file)

  message("✅ Gene catalog built and cached.")

  return(catalog_base)
}
