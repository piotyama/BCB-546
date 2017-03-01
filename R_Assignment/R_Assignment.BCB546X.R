#Set working directory
setwd("/users/Paulotyama/Desktop/BCB546X-Spring2016/R_Assignment")
                      
                  #Part I:
#Data Inspection:
genotypes <- read.table(file="fang_et_al_genotypes.txt",sep="\t",header=T)
snps <- read.table(file="snp_position.txt",sep="\t",header=T)
head(genotypes)
dim(genotypes)#2782  986
length(genotypes)#986
attributes(genotypes)
class(genotypes)#data.frame
str(genotypes)#data.frame':	2782 obs. of  986 variables
snps <- read.table(file="snp_position.txt",sep="\t",header=T)
dim(snps)# 983  15
length(snps)#15
class(snps)#data.frame
str(snps)#'data.frame':	983 obs. of  15 variables

#Data processing:
#Aim: create a joined file between genotypes and snps and to process each chromosome in both maize
  #and Teosinte separately into different .csv files. Create a total of 40 files as with Unix.

#Create separate maize and teosinte files from the genotypes file
library(dplyr)
Z_mays <- genotypes[which(genotypes$Group %in% c("ZMMIL", "ZMMMR", "ZMMLR")),]
head (Z_mays)
teosinte <- genotypes[which(genotypes$Group %in% c("ZMPBA", "ZMPIL", "ZMPJA")),]
head(teosinte)

#Transpose and process genotype files for merger
######
maize <- Z_mays[-c(1,2,3),]
transposed_Z_mays <- t(maize)
Z.mays <- cbind(rownames(transposed_Z_mays),transposed_Z_mays)
rownames(Z.mays) <- NULL
colnames(Z.mays) <- Z.mays[1,]
Z.mays <- as.data.frame(Z.mays)
colnames(Z.mays)[2] <- "SNP_ID"


Teo <-teosinte[c(-1,-2,-3),]
transposed_teosinte <-t(Teo)
Teosinte <- cbind(rownames(transposed_teosinte),transposed_teosinte)
rownames(Teosinte) <- NULL
colnames(Teosinte) <- Teosinte[1,]
Teosinte <- as.data.frame(Teosinte)
colnames(Teosinte)[1] <- "SNP_ID"


#Process snps file to contain only the necessary info for the merger (ID,Chr,Pos)
snp_pos <- snps[,c(1,3,4)]
head(snp_pos)
snp_pos$Position <- as.numeric(as.character(snp_pos$Position))
snp_pos$Chromosome <- as.numeric(as.character(snp_pos$Chromosome))#NA's introduced by coercion.

#merge created files
joined_Z.mays <- merge(snp_pos,Z.mays, by = "SNP_ID")
joined_Z.mays[joined_Z.mays == "unknown"] <- NA

joined_teosinte <- merge(snp_pos,Teosinte, by = "SNP_ID")

#Organize files in ascending and descending order by pos
acend.Z.mays <- joined_Z.mays[order(joined_Z.mays$Chromosome, joined_Z.mays$Position),]
descend.Z.mays <- joined_Z.mays[order(joined_Z.mays$Chromosome, -joined_Z.mays$Position),]
ascend.teosinte <- joined_teosinte [order(joined_teosinte$Chromosome, joined_teosinte$Position),]
descend.teosinte <- joined_teosinte [order(joined_teosinte$Chromosome, -joined_teosinte$Position),]

#Process the files into separate chromosomes for each in both ascending and descending order
#Usin loop graciouslu suggested on Slack by mcnellie using temp-def 

for(i in 1:10){
temp_df<-acend.Z.mays[acend.Z.mays==[,2]i,]
temp_df[temp_df=="-/-"]<-"?/?"
write.csv(temp_df,paste("Z_mays_chrom",i),row.names=F)
}

for(i in 1:10) {
temp_df<-descend.Z.mays[descend.Z.mays[,2]==i,]
temp_df[temp_df=="-/-"]<-"?/?"
write.csv(temp_df,paste("z_mays_chrom"i".desc.csv,sep""),row.names=F)
}

#Do the same for teosinte to generate the needed 20 files.


                    #Part II:
library(ggplot2)
library(reshape2)
library(tidyr)
tidy_genotypes <- genotypes[,-2]
tidy_genotypes <- melt(tidy_genotypes, id=c("Sample_ID", "Group"))
colnames(tidy_genotypes)[3:4] <- c("SNP_ID","SNP_call")
combined.tidy <- merge(snp_pos,tidy_genotypes, by = "SNP_ID")
convert<-function(x) {
  if (x = "A/A" | x = "C/C" | x = "T/T" | x = "G/G") {
    return(x)
  }
  else if (x == "?/?") {
    return("N")
  }
  else {return("H")}
}

combined.tidy$Converted <- lapply(tidy_genotypes$SNP_call,convert)
