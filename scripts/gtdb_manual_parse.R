### parse outputs from GTDBTK

### packages ----
library(tidyverse)


### read in  ----

in_path <- "C:/Users/mckyf/OneDrive - Northwestern University/Project folders/cANDO metagenomics/Results from quest/single assembly"

gtdb_raw <- lapply(Sys.glob(file.path(in_path, "/gtdbtk/*/classify/gtdbtk.bac120.summary.tsv")), read_delim)
gtdb <- bind_rows(gtdb_raw)

rm(gtdb_raw)

checkm_raw <- lapply(Sys.glob(file.path(in_path, "/metabat_checkm/*/*checkm_output.txt")), read_delim)
checkm <- bind_rows(checkm_raw)

rm(checkm_raw)


### check for species of interest
checkm_filt <- checkm %>%
  filter(Completeness >= 50 & Contamination <= 10)

gtdb_filt <- gtdb %>%
  filter(user_genome %in% checkm_filt$`Bin Id`)
