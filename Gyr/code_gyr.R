library(dplyr)
library(tidyverse)
library(psych)


setwd("~/Desktop/Final Project/Gyr 2/")
map_gyr<-read.table('cattle__732993variants__27individuals.map', header = F)
map_gyr<-data.frame(seq(1:732993), map_gyr)
names(map_gyr)<-c('N','chr','SNP','Distance','Position')
map_gyr<-map_gyr[,c(2,1,5)]
map_gyr$zero<-0
map_gyr<-map_gyr[,c(1,2,4,3)]
names(map_gyr)<-c('Chromosome','Name','Distance','Position')

hom_gyr<-  read.table("gyr-ROH.hom", h=T)
hom_gyr.indiv<-  read.table("gyr-ROH.hom.indiv", h=T)

uniqID <- unique(hom_gyr$IID)
uniqID <- as.character(uniqID)  
print(uniqID)
autoz <- matrix(0, ncol=732993, nrow=27)
num <- 1
for (i in uniqID){
  anim <- hom_gyr %>%filter(IID==i)
  cat("running animal ID", num, '\n')
  for (j in 1:nrow(anim)){
    autoz[num, anim[j,]$SNP1:anim[j,]$SNP2] <- 1
  }
  num <- num + 1
}

autozM <- colMeans(autoz)
autozM2_gyr <- data.frame(CHR = map_gyr$Chromosome, POS=map_gyr$Position, Prop=autozM)

library(qqman)
#tiff("mp1.tiff",width = 19.20,height = 10.80,units = "in",res = 600,compression = "lzw")
#par(mfrow=c(1,2))
manhattan(autozM2_gyr, chr = "CHR", bp = "POS",
          p = "Prop", snp = "POS",
          col = c("blue", "gray0"), chrlabs = NULL,
          suggestiveline = 0.40,
          highlight = NULL, logp = FALSE, annotatePval = NULL,
          annotateTop = TRUE, ylim=c(0,.6), ylab='Individuals in a ROH (%)',
          xlab='Chromosome')
#dev.off()
