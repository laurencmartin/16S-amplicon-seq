#!/usr/bin/env python3

import os
import sys
import random

fasta = sys.argv[1]

f = open(fasta, "r")

list1 = []
q_scores = ["5","6","7", "8","9", ":", ";", "<", "=", ">", "?", "@", "A", "B", "C", "D", "E", "F", "G", "H", "I"]
 
for line in f:
    line = line.strip() #takes away new line character
    list1.append(line)

list2 = []

for i in list1:
    if i.startswith(">"):
        list2.append(list1.index(i))

for i in list2:
     list_name = "a"+ str(i)
     list_name = []
    
     if i != list2[-1]:
         list_name.append(list1[i])
         list_name.append(list1[i+1:list2[(list2.index(i)+1)]])
     else:
         list_name.append(list1[i])
         list_name.append(list1[i+1:])

     read = "".join(list_name[1]) 
     print("@"+list_name[0][1:])
     print(read)
     print("+")
     minimum_int, maximum_int = 0, len(q_scores)-1
     qual = []
     for i in read:
         q_index = random.randint(minimum_int, maximum_int)
         qual.append(q_scores[q_index])
     print( "".join(qual))
