#!/usr/bin/env python3

#to allow us to load input files
import os
import sys

in_file=sys.argv[1] 
f = open(in_file, "r")

list1 = []


for line in f:
    if line.startswith(">"):
        line = line.strip()
        a = line.find("=")
        count = str(int(float(line[a+1: ]))) #convert to integer and convert back to string   
        if count == "0":
            count = "1"
        print(count)
#        list1.append(int(count))
#print(sum(list1))


        

