#!/usr/bin/env python3

import os
import sys

tax_table = sys.argv[1] 
counts = sys.argv[2]

list_taxa = []
list_counts = []


f = open(tax_table, "r")
#f.next() #skips the unwanted first line of tax_table


for line in f:
    line = line.strip()
    list_taxa.append(line)
header = "," + list_taxa[0]
#print(header)
list_taxa.pop(0) #removing the first element (header line)    
#print(list_taxa)
g = open(counts, "r")

for line in g:
    line = line.strip()
    list_counts.append(line)

list_1 = []

for i in range(0, len(list_taxa)):
    b = int(list_counts[i])
    taxa = list_taxa[i].split(",")
    seq = taxa[0]
    seq = seq.replace('"', '')
    seq = seq.replace('"', '')
    list_1.append(seq)

print(",".join(list_1))
print(",".join(list_counts))

#print(len(list_1))
#print(len(list_counts))        


