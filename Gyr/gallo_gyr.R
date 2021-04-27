library(dplyr)
library(GALLO)

map_gyr<-read.table('~/Desktop/Final Project/Gyr/cattle__732993variants__27individuals.map', header = F)
names(map_gyr)<-c('CHR','SNP','Distance','BP')
map_gyr<-data.frame(seq(1:732993), map_gyr)
names(map_gyr)<-c('N','CHR','SNP','Distance','BP')

hom_gyr<-  read.table("gyr-ROH.hom", h=T)
hom_gyr.indiv<-  read.table("gyr-ROH.hom.indiv", h=T)

uniqID <- unique(hom_gyr$IID)
uniqID <- as.character(uniqID)

autoz <- matrix(0, ncol=732993, nrow=35)
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
autozM2_gyr <- data.frame(CHR = map_gyr$CHR, BP=map_gyr$BP, Prop=autozM)

chr<-autozM2_gyr%>%
  filter(Prop>=0.4) %>%
  select(CHR)
table(chr) # 6 21

autozM2_gyr%>%
  filter(Prop>=0.4) %>%
  filter(CHR==16) %>%
  summarise(max=max(BP),min=min(BP), mean(BP))

c40<-autozM2_gyr%>%
  filter(Prop>=0.4)

names(c40)<- c("CHR","BP","Prop")
c40<-c40[,-3] 
c40$n<- 1:nrow(c40)
c40$zero<- 0
c40<- c40[,c(1,3,4,2)]



cow_genes<-import_gff_gtf("~/Desktop/Final Project/Bos_indicus_hybrid.UOA_Brahman_1.103.gtf", file_type = "gtf")



gyr_gene<- find_genes_qtls_around_markers(
  db_file=cow_genes,
  marker_file=c40,
  method = "gene",
  marker = "snp",
  interval = 50000,
  nThreads = NULL,
  verbose = TRUE
)


DT::datatable(gyr_gene, rownames = FALSE, 
              extensions = 'FixedColumns',
              options = list(scrollX = TRUE))
