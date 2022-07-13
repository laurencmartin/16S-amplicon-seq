#!/bin/bash

while getopts t:a:s: option
do
case "${option}"
in

t) DIR1=${OPTARG};;
a) DIR2=${OPTARG};;
s) FILE1=${OPTARG};;

esac
done

# for i in $(cat $FILE1);
# do 
#     cat $DIR1/${i}*.csv >> tax_concat.csv
#     cat $DIR2/${i}.csv >> asv_concat.csv
# done
#cd $DIR1

cat $DIR1/* >> tax_concat.csv

cat $DIR2/* >> asv_concat.csv

sort tax_concat.csv | uniq | sed $'s/\t/,/g' > tax_uniq.csv

#rm tax_concat.csv

python3 scripts/get_merged_asv_table.py asv_concat.csv | sed $'s/\t/,/g' > asv_merged.csv

#rm asv_concat.csv

python3 scripts/reorder_tax_table.py tax_uniq.csv asv_merged.csv > int_tax.csv

sed $'/^$/d' int_tax.csv > final_tax.csv

#rm int_tax.csv

#rm tax_uniq.csv

echo "" > temp.txt && cat $FILE1 >> temp.txt

paste temp.txt asv_merged.csv | sed $'s/\t/,/' > final_asv.csv

#rm asv_merged.csv temp.txt

#Rscript create_phyloseq_object.R 

#singularity run --bind $PWD:/mnt --bind /users/lcmartin/pipeline/containers:/mnt/containers /users/lcmartin/pipeline/containers/dada2.sif Rscript create_phyloseq_object.R final_tax.csv final_asv.csv $FILE2

  






