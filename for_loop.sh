#!/bin/bash

for i in {1..10};
do 

	awk '$3=='$i'' joined_teosinte.txt | sed 's/?/-/g'| sort -k4,4n | tee teosinte_chrom$i.txt | sed 's/?/-/g' | sort -k4,4nr > teosinte_chrom"$i"_r-sort.txt	
	
	awk '$3=='$i'' joined_Z_mays.txt | sed 's/?/-/g'| sort -k4,4n | tee Z_mays_chrom$i.txt | sed 's/?/-/g' | sort -k4,4nr > Z_mays_chrom"$i"_r-sort.txt;

done
