collapse_accessions <- function(hacc, hgn) {

  hacc <- dplyr::select(
    hacc,
    GeneID, assembly, orientation,
    start_position_on_the_genomic_accession,
    end_position_on_the_genomic_accession,
    status,
    genomic_nucleotide_accession.version,
    RNA_nucleotide_accession.version,
    protein_accession.version
  )

  collapsed <- hacc |>
    dplyr::group_by(GeneID) |>
    dplyr::summarise(
      dplyr::across(everything(), ~paste0(., collapse = "|")),
      .groups = "drop"
    )

  collapsed$GeneIDs_on_left <- hgn$GeneIDs_on_left[
    match(collapsed$GeneID, hgn$GeneID)
  ]

  collapsed
}
