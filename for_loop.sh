#!/bin/bash

	for i in {1..10}; 

	do
		awk '$3 ~ /i/ {print}' joined_teosinte.txt | sort -k4,4n > teosinte_chrom$i.txt
	
		awk '$3 ~ /i/ {print}' joined_teosinte.txt | sort -k4,4nr > teosinte_chrom$i_r-sort.txt
	done
