#!/usr/bin/env python3

import os
import sys

merge_tax_table = sys.argv[1]
asv_table = sys.argv[2]

f = open(asv_table, "r")
asv = f.readline().strip().split(",")
# print(asv)

print(',"Kingdom","Phylum","Class","Order","Family","Genus","Species"')

for i in asv:
    i = '"' + i + '"'
  #  print(i)
    for line in open(merge_tax_table, "r"):
        line_list = line.strip().split(",")
        if line_list[0] == i:
            print(line)


        

