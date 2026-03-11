#' Download gene catalog source files
#'
#'
check_file <- function(f){

  if (!file.exists(f)) {
    stop("Missing file: ", f)
  }

  if (file.size(f) == 0) {
    stop("Downloaded file is empty: ", f)
  }

}

#'
#' @export
download_gene_catalog_data <- function(
    path = tools::R_user_dir("MAHGIx", which = "cache"),
    threads = max(1, parallel::detectCores() - 1)
) {

  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }

  options(timeout = 3600)

  message("📂 Cache directory: ", path)
  message("⚡ Parallel downloads: ", threads)

  urls <- list(
    gene_info="https://ftp.ncbi.nlm.nih.gov/gene/DATA/GENE_INFO/Mammalia/Homo_sapiens.gene_info.gz",
    gene_neighbors="https://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_neighbors.gz",
    gene2accession="https://ftp.ncbi.nlm.nih.gov/gene/DATA/gene2accession.gz",
    table37="https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Homo_sapiens/all_assembly_versions/GCF_000001405.25_GRCh37.p13/GCF_000001405.25_GRCh37.p13_feature_table.txt.gz",
    table38="https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Homo_sapiens/all_assembly_versions/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_feature_table.txt.gz",
    tableT2T="https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Homo_sapiens/all_assembly_versions/GCF_009914755.1_T2T-CHM13v2.0/GCF_009914755.1_T2T-CHM13v2.0_feature_table.txt.gz",
    hgnc="https://storage.googleapis.com/public-download-files/hgnc/tsv/tsv/hgnc_complete_set.txt",
    gwas="https://www.ebi.ac.uk/gwas/api/search/downloads/associations/v1.0?split=false",
    ctd="https://ctdbase.org/reports/CTD_genes_diseases.csv.gz"
  )

  download_one <- function(nm) {

    url <- urls[[nm]]

    if (nm %in% c("gene_neighbors","gene2accession","gene_info")) {

      dest <- file.path(path,paste0(nm,"_9606.tsv"))

      if (file.exists(dest)) return(NULL)

      cmd <- sprintf(
        "curl -L --fail -H 'Accept-Encoding: identity' '%s' | gunzip -c | awk -F '\\t' 'NR==1 || $1==9606' > '%s'",
        url,dest
      )

      system(cmd)
      return(NULL)
    }

    if (nm=="ctd") {

      dest <- file.path(path,"ctd.tsv")

      if (file.exists(dest)) return(NULL)

      cmd <- sprintf(
        "curl -L --fail '%s' | gunzip -c | awk -F ',' 'BEGIN{OFS=\"\\t\"} NR==30 || (NR>30 && $5==\"marker/mechanism\"){print $1,$2,$3,$4,$5,$6,$7,$8,$9}' > '%s'",
        url, dest
      )

      system(cmd)
      return(NULL)
    }

    if (nm=="gwas") {

      dest <- file.path(path,"gwas.tsv")

      if (file.exists(dest)) return(NULL)

      cmd <- sprintf(
        "curl -L --fail '%s' | funzip > '%s'",
        url, dest
      )

      system(cmd)
      return(NULL)
    }

    dest <- file.path(path,paste0(nm,".gz"))

    if (file.exists(dest)) return(NULL)

    cmd <- sprintf(
      "curl -L --fail -H 'Accept-Encoding: identity' '%s' -o '%s'",
      url,dest
    )

    system(cmd)
  }

  message("⬇ Starting downloads...")

  parallel::mclapply(
    names(urls),
    download_one,
    mc.cores = threads
  )

  message("✅ Downloads finished")

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

  for (f in required_files) {
    check_file(file.path(path, f))
  }

}


