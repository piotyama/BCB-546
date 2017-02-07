**Paul.Otyama_UNIX Assignment.BCB546X**

**_Data Inspection_**

**fang_et_al_genotypes.txt:**

	du -h fang_et_al_genotypes.txt

	wc -l fang_et_al_genotypes.txt

	awk -F "\t" '{print NF; exit}' 	fang_et_al_genotypes.txt

**11M in size with 2783 rows and 986 columns**

**snp_position.txt:**
	
	du -h snp_position.txt

	wc -l snp_position.txt 

	awk -F "\t" '{print NF; exit}' snp_position.txt

**84K file with 984 rows and 15 columns**

**_Data Processing_**

	awk '$3 ~ /ZMMIL/ || $3 ~ /ZMMLR/ || $3 ~ /	ZMMMR/' fang_et_al_genotypes.txt | less -S 

checked within less to highlight each of the group patterns to confirm that they had been extracted as expected from the genotype file.

	awk '$3 ~ /ZMMIL/ || $3 ~ /ZMMLR/ || $3 ~ /	ZMMMR/' fang_et_al_genotypes.txt | less -S > 	Z_mays

Re-directing the output to a new file. Did the same for teosinte;

	 awk '$3 ~ /ZMPBA/ || $3 ~ /ZMPIL/ || $3 ~ /	ZMPJA/' fang_et_al_genotypes.txt | less -S > 	teosinte

Checked to confirm that the files had all the 986 columns:

	awk -F "\t" '{print NF; exit}' teosinte

	awk -F "\t" '{print NF; exit}' Z_mays

Checked for the number of rows in each file, teosinte has 975 and Z_mays has 1573 rows of data:

	wc -l Z_mays teosinte
	
Transpose the two files using the provided awk script and carried a simple file check using wc-l; the transposition worked as anticipated:

	awk -f transpose.awk teosinte > transposed_teosinte.txt

	awk -f transpose.awk Z_mays > transposed_Z_mays.txt
	
	wc -l transposed* 
	
Sorted the files by column 1 which is the common column in all the three files of interest:

	sort -c -k1,1 snp_position.txt

	echo $?

	sort -k1,1 snp_position.txt > snp_position_sorted.txt

	sort -k1,1 transposed_teosinte.txt > teosinte_sorted.txt

	sort -k1,1 transposed_Z_mays.txt > Z_mays_sorted.txt
	
	
Joined the files using column 1 as the common column between snp_pos and the two separate genotype files:

	join -t $'\t' -1 1 -2 1 snp_position_sorted.txt teosinte_sorted.txt | head -n 2
	
	join -t $'\t' -1 1 -2 1 snp_position_sorted.txt teosinte_sorted.txt > joined_teosinte.txt
	
	join -t $'\t' -1 1 -2 1 -a 1 snp_position_sorted.txt Z_mays_sorted.txt > joined_Zmays.txt


Separating SNP data based on chromosome 
:

**_NOTE:_** There's definitely a much better way to do this than repeatedly using the basic awk code I employ here. But I couldn't come up with a much better solution ;)


I am simply matching the chromosome I want to print out using a simple regular expression and repeating this for all the other matches from 1- 10.
		
	1.	To create a file with SNPs ordered based on increasing position values:
	
	awk '$3 ~ /10/ {print}' joined_teosinte.txt | sort -k4,4n > teosinte_chrom10.txt
	
	awk '$3 ~ /4/ {print}' joined_Z_mays.txt | sort -k4,4n > Z_mays_chrom4.txt

**_I repeat the same for different chromosomes_**


	2. To create a file with SNPs ordered based on decreasing position values:

	awk '$3 ~ /10/ {print}' joined_teosinte.txt | sort -k4,4nr > teosinte_chrom10_r-sort.txt

	awk '$3 ~ /4/ {print}' joined_Z_mays.txt | sort -k4,4nr > Z_mays_chrom4_r-sort.txt



**Processed files are in their respective directories**

	
	