#title: " Create phyloseq object"
#' author: "Lauren Martin"
#' date: "20 March 2022"
#' ---

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied", call.=FALSE)
} else if (length(args)==1) {
  stop("Looks like you're missing the taxa table, ASV table, metadata or output file name", call.=FALSE)
} else if (length(args)==2) {
  stop("Looks like you're missing the taxa table, ASV table, metadata or output file name", call.=FALSE)
} else if (length(args)==3) {
  stop("Looks like you're missing the taxa table, ASV table, metadata or output file name", call.=FALSE)
}

tax_table <- args[1]
asv_table <- args[2]
metadata <- args[3]
output_file <- args[4]

#Libraries

library(dplyr)
library(dada2);packageVersion("dada2") 
library(Biostrings); packageVersion("Biostrings")
library(ShortRead); packageVersion("ShortRead")
library(ggplot2); packageVersion("ggplot2")
library(reshape2); packageVersion("reshape2")
library(gridExtra); packageVersion("gridExtra")
library(phyloseq); packageVersion("phyloseq")


# PhyloSeq Handoff --------------------------------------------------------

theme_set(theme_bw())

metadata <- read.table(metadata ,sep="\t",header=T, row.names =NULL)
meta <- as.data.frame(sample_data(metadata))

#taxa <- taxa_table

#row.names(st) <- row.names(meta)
ps <- phyloseq(otu_table(asv_table, taxa_are_rows=FALSE), tax_table(tax_table), metadata)

#plot absolute abundance


pdf(file = paste(output_file, '.pdf', sep = ''))
plot_bar(ps, fill = "Genus")

"""
ps.genus <- tax_glom(ps, taxrank="Genus")
ps.genus
taxa_names(ps.genus) = c(tax_table(ps.genus)[,6])
sort(sample_sums(ps.genus)) # see distribution of reads/ (sample lowest = 53, highest = 17104)
hist(sample_sums(ps.genus))
sample_sums(ps.genus)

#rarify the samples (did not do)
set.seed(454)
ps.gen.rar <- rarefy_even_depth(ps.genus, sample.size = min(sample_sums(ps.genus)))
sample_sums(ps.gen.rar)

# Relative Abundance ------------------------------------------------------
# Filter taxa observed more than once in at least 15% of participants (to not look at all of them and to minimize multiple testing). Note filter_taxa works on phyloseq objects ONLY. Use filtering ONLY when comparing genera (not for distance matrices)
ps.mean1 <- filter_taxa(ps.genus, function(x) mean(x)>=1, TRUE)
ps.mean1.min0.15 <- filter_taxa(ps.mean1, function(x) sum(x>=1) >= (0.15*length(x)), TRUE)
ps.mean1.min0.15

# Create stacked bar chart for  top 10 genera
# sort the sums of the taxa to get 1-10 of the most abundant genera in PhylObject
Top10Gen <-names(sort(taxa_sums(ps.mean1.min0.15), TRUE)[1:10])

#now select only those top 10
Top10Gen.cut <-prune_taxa(Top10Gen, ps.mean1.min0.15)

#plot top 10 taxa
plot_bar(Top10Gen.cut) 
plot_bar(Top10Gen.cut, x="Study.ID", fill="Family") + facet_wrap(~X9.month.Bayley, scales="free_x")
plot_bar(Top10Gen.cut, x="Study.ID", fill="Genus") + facet_wrap(~X9.month.Bayley, scales="free_x")

"""
