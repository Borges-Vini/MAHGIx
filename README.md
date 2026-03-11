# MAHGIx

MAHGIx is an R package designed to build, explore, and query an integrated human gene catalog by combining multiple genomic and biomedical databases.

The package automatically downloads, integrates, and caches annotations from several authoritative resources, allowing users to rapidly explore gene–disease relationships, functional annotations, and genomic metadata.

MAHGIx is particularly useful for:

• genetic epidemiology  
• GWAS interpretation  
• disease gene prioritization  
• exploratory genomic analyses  
• educational use in bioinformatics pipelines  


---

# Integrated Data Sources

MAHGIx integrates annotations from several major genomic resources:

**NCBI Gene Info, Gene2accessories and Gene Neighbors**  
Core gene metadata including GeneID, symbols, synonyms, gene types, genomic coordinates, and functional descriptions.

**GWAS Catalog**  
Associations between genetic variants and complex traits or diseases.

**CTDbase (Comparative Toxicogenomics Database)**  
Curated gene–disease relationships based on experimental evidence.

**HGNC**  
Official human gene nomenclature and standardized gene symbols.

**RefSeq genome assemblies**

Gene coordinates across multiple reference assemblies including:

• GRCh38  
• GRCh37  
• T2T-CHM13  

These resources are harmonized and merged into a single unified gene catalog.


---

# Installation

Install MAHGIx directly from GitHub:

```r
remotes::install_github("Borges-Vini/MAHGIx")
```

Load the package:

```r
library(MAHGIx)
```


---

# Quick Start

The quickest way to explore MAHGIx is:

```r
catalog <- build_gene_catalog()

summary_gene_catalog(catalog)

inspect_gene_catalog(catalog)
```

Alternatively, run the built-in tutorial:

```r
hello()
```

The `hello()` function runs a complete demonstration of the MAHGIx workflow.


---

# Building the Gene Catalog

The core function of the package is:

```r
build_gene_catalog()
```

This function automatically performs the following steps:

1. Downloads annotation datasets if they are not already cached  
2. Parses and cleans all source databases  
3. Harmonizes gene identifiers and gene symbols  
4. Integrates GWAS and disease annotations  
5. Builds a unified human gene catalog  

Example:

```r
catalog <- build_gene_catalog()
```

The resulting catalog is cached locally for faster reuse in future sessions.

The cache location is determined by:

```r
tools::R_user_dir("MAHGIx", "cache")
```


---

# Updating the Catalog

To force a rebuild using the most recent database versions:

```r
update_gene_catalog()
```

This deletes the cached catalog and rebuilds it from scratch.


---

# Exploring the Gene Catalog

MAHGIx provides several functions to inspect and understand the catalog.

Summary overview:

```r
summary_gene_catalog(catalog)
```

This displays:

• total number of genes  
• number of protein-coding genes  
• number of genes linked to GWAS traits  
• number of genes linked to CTD diseases  


Detailed inspection:

```r
inspect_gene_catalog(catalog)
```

This function reports:

• catalog dimensions  
• distribution of gene types  
• annotation coverage  
• most frequent GWAS traits  
• catalog metadata  


---

# Structure of the Gene Catalog

Each row of the catalog represents a gene and includes multiple annotation fields such as:

**GeneID**  
NCBI Gene identifier.

**Symbol**  
Official gene symbol.

**Synonyms**  
Alternative gene names.

**type_of_gene**  
Gene classification (protein-coding, lncRNA, pseudogene, etc.).

**GWAS_traits**  
Traits associated with the gene in the GWAS Catalog.

**GWAS_SNPs**  
List of SNPs associated with the gene.

**DiseaseNames_ctdbase**  
Disease annotations from CTDbase.

**disease_union**  
Combined disease and trait annotations from multiple sources.

**gene_symbol_list**  
Expanded list of gene symbols and synonyms used for matching.


---

# Filtering the Gene Catalog

MAHGIx provides filtering utilities to extract subsets of genes relevant to specific analyses.

Filter protein-coding genes:

```r
pc_catalog <- filter_protein_coding(catalog)
```

Search by gene symbol:

```r
filter_gene(catalog, "ACE")
```

This function supports both official symbols and synonyms.

Filter by disease or trait:

```r
filter_trait(catalog, "essential hypertension")
```

Example:

```r
htn_genes <- filter_trait(catalog, "hypertension")
```

Filter by OMIM identifier:

```r
filter_omim(catalog, "145500")
```


---

# Example Analysis Workflow

The following workflow illustrates a typical gene prioritization analysis using MAHGIx.

Step 1 — Build the catalog

```r
catalog <- build_gene_catalog()
```

Step 2 — Restrict to protein-coding genes

```r
pc_catalog <- filter_protein_coding(catalog)
```

Step 3 — Identify genes associated with hypertension

```r
htn <- filter_trait(pc_catalog, "essential hypertension")
```

Step 4 — Query candidate genes

```r
filter_gene(htn, "ACE")
```


---

# Typical Use Cases

MAHGIx can be used for:

• prioritizing candidate genes from GWAS signals  
• identifying disease-associated genes  
• building custom gene lists for downstream analyses  
• exploring gene–trait relationships  
• teaching bioinformatics workflows  


---

# Citation

Borges VM, Weekley D, Nato A (2026).  
MAHGIx: Marshall Aggregated Human Gene Index. 
Available at: https://github.com/Borges-Vini/MAHGIx


BibTeX:

```
@software{borges2026mahgix,
  author       = {Borges, Vinícius and Weekley, Daron and Nato, Alejandro},
  title        = {MAHGIx: Marshall Aggregated Human Gene Index},
  year         = {2026},
  publisher    = {GitHub},
  url          = {https://github.com/Borges-Vini/MAHGIx}
}
```

If you use MAHGIx in academic work, please cite the package and the underlying databases:

• NCBI Gene  
• GWAS Catalog  
• CTDbase  
• HGNC  


---

# License

MIT License


---

# Authors

Vinícius Magalhães Borges  
Daron Weekley  
Alejandro Nato  

Marshall University
