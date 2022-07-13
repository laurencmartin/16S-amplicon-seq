#' title: "Assign Taxonomy"
#' author: "Lauren Martin"
#' date: "20 March 2022"
#' ---

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied", call.=FALSE)
} else if (length(args)==1) {
  stop("Looks like you're missing either the reference database or final assembly fastq file", call.=FALSE)
} else if (length(args)==2) {
  stop("Looks like you're missing output file name", call.=FALSE)
}

final_assembly <- args[1]
ref_db <- args[2]
output_file <- args[3]

#library(dplyr)
library(dada2);packageVersion("dada2") 
library(Biostrings); packageVersion("Biostrings")
library(ShortRead); packageVersion("ShortRead")
library(ggplot2); packageVersion("ggplot2")
library(reshape2); packageVersion("reshape2")
#library(gridExtra); packageVersion("gridExtra")
#library(phyloseq); packageVersion("phyloseq")


# Assign Taxonomy ---------------------------------------------------------

tax_table <- assignTaxonomy(final_assembly, ref_db, multithread=TRUE, verbose = 1)

#head(tax)
#dim(tax)

#Move ASVs from column in dataframe to row names
tax <- as.matrix(tax_table, taxa_are_rows=TRUE)
#tax2 <- tax[,-1]
#rownames(tax2) <- tax[,1]
#tax2
tax.df <- data.frame(tax)
#tax.df <- tax

#Replace Prevotella_9 with Prevotella
Genus = tax.df[,6]
Genus[grep("Prevotella",Genus)]
tax.df[grep("Prevotella",tax.df$Genus),"Genus"] <- "Prevotella"

#Replace Shuttleworthia with BVAB1
Genus = tax.df[,6]
Genus[grep("Shuttleworthia",Genus)]
tax.df[grep("Shuttleworthia",tax.df$Genus),"Genus"] <- "BVAB1"

write.table(tax.df, file= output_file, sep=",")

# --------------------------------------------------------------------------
