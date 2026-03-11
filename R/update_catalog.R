#' Update gene catalog
#'
#' Forces rebuild of the catalog by deleting the cached version.
#'
#' @export

update_gene_catalog <- function(
    path = tools::R_user_dir("MAHGIx", which = "cache")
){

  catalog_file <- file.path(path, "gene_catalog_v1.rds")

  if (file.exists(catalog_file)) {

    message("Removing cached catalog...")
    unlink(catalog_file)

  }

  build_gene_catalog(path)

}
