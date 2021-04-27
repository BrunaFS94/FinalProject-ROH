library(dplyr)
library(tidyverse)
library(psych)


setwd("~/Desktop/Final Project/Hereford")
map_hfd<-read.table('cattle__732993variants__35individuals.map', header = F)
map_hfd<-data.frame(seq(1:732993), map_hfd)
names(map_hfd)<-c('N','chr','SNP','Distance','Position')
map_hfd<-map_hfd[,c(2,1,5)]
map_hfd$zero<-0
map_hfd<-map_hfd[,c(1,2,4,3)]
names(map_hfd)<-c('Chromosome','Name','Distance','Position')

hom_hfd<-  read.table("hereford-ROH.hom", h=T)
hom_hfd.indiv<-  read.table("hereford-ROH.hom.indiv", h=T)

uniqID <- unique(hom_hfd$IID)
uniqID <- as.character(uniqID)  
print(uniqID)
autoz <- matrix(0, ncol=732993, nrow=35)
num <- 1
for (i in uniqID){
  anim <- hom_hfd %>%filter(IID==i)
  cat("running animal ID", num, '\n')
  for (j in 1:nrow(anim)){
    autoz[num, anim[j,]$SNP1:anim[j,]$SNP2] <- 1
  }
  num <- num + 1
}

autozM <- colMeans(autoz)
autozM2_hfd <- data.frame(CHR = map_hfd$Chromosome, POS=map_hfd$Position, Prop=autozM)

library(qqman)
#tiff("mp1.tiff",width = 19.20,height = 10.80,units = "in",res = 600,compression = "lzw")
#par(mfrow=c(1,2))
manhattan(autozM2_hfd, chr = "CHR", bp = "POS",
          p = "Prop", snp = "POS",
          col = c("blue", "gray0"), chrlabs = NULL,
          suggestiveline = 0.60,
          highlight = NULL, logp = FALSE, annotatePval = NULL,
          annotateTop = TRUE, ylim=c(0,0.8), ylab='Individuals in a ROH (%)',
          xlab='Chromosome')
#dev.off()
