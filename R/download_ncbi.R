#' Download NCBI human gene resources
#'
#' @name download_ncbi_data
#' @return A named list of data.tables
#' @export
download_ncbi_data <- function() {

  options(timeout = 600)

  list(
    gene_info = data.table::fread(
      "https://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_info.gz"
    ),
    gene_neighbors = data.table::fread(
      "https://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_neighbors.gz"
    ),
    gene2accession = data.table::fread(
      "https://ftp.ncbi.nlm.nih.gov/gene/DATA/gene2accession.gz"
    ),
    table37 = data.table::fread(
      "https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Homo_sapiens/all_assembly_versions/GCF_000001405.25_GRCh37.p13/GCF_000001405.25_GRCh37.p13_feature_table.txt.gz"
    ),
    table38 = data.table::fread(
      "https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Homo_sapiens/all_assembly_versions/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_feature_table.txt.gz"
    ),
    tableT2T = data.table::fread(
      "https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Homo_sapiens/all_assembly_versions/GCF_009914755.1_T2T-CHM13v2.0/GCF_009914755.1_T2T-CHM13v2.0_feature_table.txt.gz"
    )
  )
}
