library(dplyr)
library(GALLO)

map_hfd<-read.table('~/Desktop/Final Project/Hereford/cattle__732993variants__35individuals.map', header = F)
names(map_hfd)<-c('CHR','SNP','Distance','BP')
map_hfd<-data.frame(seq(1:732993), map_hfd)
names(map_hfd)<-c('N','CHR','SNP','Distance','BP')

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
autozM2_hfd <- data.frame(CHR = map_hfd$CHR, BP=map_hfd$BP, Prop=autozM)

chr<-autozM2_hfd%>%
  filter(Prop>=0.6) %>%
  select(CHR)
table(chr) # 6 21

autozM2_hfd%>%
  filter(Prop>=0.6) %>%
  filter(CHR==6) %>%
  summarise(max=max(BP),min=min(BP), mean(BP))

autozM2_hfd%>%
  filter(Prop>=0.6) %>%
  filter(CHR==21) %>%
  summarise(max=max(BP),min=min(BP), mean(BP))

c60<-autozM2_hfd%>%
  filter(Prop>=0.6)

names(c60)<- c("CHR","BP","Prop")
c60<-c60[,-3] 
c60$n<- 1:nrow(c60)
c60$zero<- 0
c60<- c60[,c(1,3,4,2)]



cow_genes<-import_gff_gtf("~/Desktop/Final Project/Bos_taurus.ARS-UCD1.2.103.gtf", file_type = "gtf")



hfd_gene<- find_genes_qtls_around_markers(
  db_file=cow_genes,
  marker_file=c60,
  method = "gene",
  marker = "snp",
  interval = 50000,
  nThreads = NULL,
  verbose = TRUE
)


DT::datatable(hfd_gene, rownames = FALSE, 
              extensions = 'FixedColumns',
              options = list(scrollX = TRUE))
