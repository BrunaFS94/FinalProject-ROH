library(dplyr)
library(tidyverse)
library(psych)


setwd("~/Desktop/Final Project/Holstein/")

#Map File 
#1. Loading the file
map_hol<-read.table('cattle__732993variants__60individuals.map', header = F)

#2. Adding a column counting from 1 to 732993 (number of markers) with the map file
map_hol<-data.frame(seq(1:732993), map_hol)

#3. Naming the columns (number, chromosome number, snp name, distance, position)
names(map_hol)<-c('N','chr','SNP','Distance','Position')

#4. indexing and reordering by columns 2(chromosome number), 1(number), 5(position) in that order
map_hol<-map_hol[,c(2,1,5)]

#5. Adding a column of zeros at the end of the datatable
map_hol$zero<-0

#6.indexing and reordering by columns 1(chromosome number), 2(number), 4(0), 3(position) in that order
map_hol<-map_hol[,c(1,2,4,3)]

#7. naming the columns Chromosome, Name, Distance, and Position
names(map_hol)<-c('Chromosome','Name','Distance','Position')

#8. loading the hom table and hom.indiv table
hom<-  read.table("holstein-ROH.hom", h=T)
hom.indiv<-  read.table("holstein-ROH.hom.indiv", h=T)

#9. creating a column of the unique IDs in the hom table
uniqID <- unique(hom$IID)

#10. converting the Ids in the unique ID table to characters and printing them
uniqID <- as.character(uniqID)  
print(uniqID)

#11. creating an empty matrix containing 732993 columns (number of markers) and 60 rows (number of animals)
autoz <- matrix(0, ncol=732993, nrow=60)

#12. setting num variable = to 1
num <- 1

#14. For loop cycling 60 times (number of unique IDs/number of animals):
  #pulling the data from the hom table by ID and inputting it into an empty table named anim
  #internal For loop cycling by the number of entries for each animal:
    #
for (i in uniqID){
  anim <- hom %>%filter(IID==i)
  cat("running animal ID", num, '\n')  #just prints which animal it is on
  for (j in 1:nrow(anim)){
    autoz[num, anim[j,]$SNP1:anim[j,]$SNP2] <- 1
  }
  num <- num + 1
}

autozM <- colMeans(autoz)
autozM2_hol <- data.frame(CHR = map_hol$Chromosome, POS=map_hol$Position, Prop=autozM)


#PLOTTING
#package that makes manhattan plots
library(qqman)
#tiff("mp1.tiff",width = 19.20,height = 10.80,units = "in",res = 600,compression = "lzw")
#par(mfrow=c(1,2))
manhattan(autozM2_hol, chr = "CHR", bp = "POS",
          p = "Prop", snp = "POS",
          col = c("blue", "gray0"), chrlabs = NULL,
          suggestiveline = 0.40,
          highlight = NULL, logp = FALSE, annotatePval = NULL,
          annotateTop = TRUE, ylim=c(0,0.6), ylab='Individuals in a ROH (%)',
          xlab='Chromosome')
#dev.off()

