#!/usr/bin/env python3

# Script for taking a concatenated file of seq_tables from multiple samples and generating a 'dada2-like' multi-sample seq_table

import os
import sys

input_file = sys.argv[1]  # input is a concatenated file of seq_tables from multiple samples

seqs = []   # list for holding all asvs (including duplicates)
seqs2 = []   # big list for holding separate asv lists corresponding to each sample
counts = []   # big list for holding separate count lists corresponding to each sample


for line in open(input_file, "r"):
    line = line.strip()

    if "A" in line:  # this means the line contains asvs

        seqs.append(line)   # add all asvs (including duplicates)

        line = line.split(",")   # convert the line with asvs for each sample into a list
        seqs2.append(line)   # add the asv lists for each sample to a 'list of lists'

    else:
        sample_counts = line.split(",")   # convert the line with counts for each sample into a list
        counts.append(sample_counts)   # add the counts lists for each sample to a 'list of lists'

seqs = ",".join(seqs)   # collapse all asvs (including duplicates) into a merged string of asvs


sample_ASVs = seqs.split(",")  # convert merged asvs string into a list 
sample_ASVs = [i for n, i in enumerate(sample_ASVs) if i not in sample_ASVs[:n]]   # remove duplicates from asvs list

print(",".join(sample_ASVs))   # print asvs that will be in seq_table


for j in range(0, len(seqs2)):   # indices necessary to loop through all samples in concatenated file

    list_1 = []   # this list will hold the counts summary for each sample

    for i in sample_ASVs:
        if i in seqs2[j]:  # this means the sample has the asv being queried
            index_1 = seqs2[j].index(i)   # get the index of the asv in the sample-specific list
            sample_asv_count = counts[j][index_1]  # use the index above to obtain the correct count

        else:   # this means the sample doesn't have the asv being queried
            sample_asv_count = '0'  # count is obviously zero for this condition

        list_1.append(sample_asv_count)  # add the summarised counts to the count list

    print(",".join(list_1))   # print the asv counts for each sample into the outfile

