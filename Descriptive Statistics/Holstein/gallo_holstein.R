library(dplyr)
library(GALLO)

map_hol<-read.table('~/Desktop/Final Project/Holstein/cattle__732993variants__60individuals.map', header = F)
names(map_hol)<-c('CHR','SNP','Distance','BP')
map_hol<-data.frame(seq(1:732993), map_hol)
names(map_hol)<-c('N','CHR','SNP','Distance','BP')

hom_hol<-  read.table("holstein-ROH.hom", h=T)
hom_hol.indiv<-  read.table("holstein-ROH.hom.indiv", h=T)

uniqID <- unique(hom_hol$IID)
uniqID <- as.character(uniqID)  
print(uniqID)
autoz <- matrix(0, ncol=732993, nrow=60)
num <- 1

for (i in uniqID){
  anim <- hom_hol %>%filter(IID==i)
  cat("running animal ID", num, '\n') 
  for (j in 1:nrow(anim)){
    autoz[num, anim[j,]$SNP1:anim[j,]$SNP2] <- 1
  }
  num <- num + 1
}

autozM <- colMeans(autoz)
autozM2_hol <- data.frame(CHR = map_hol$CHR, BP=map_hol$BP, Prop=autozM)

chr<-autozM2_hol%>%
  filter(Prop>=0.4) %>%
  select(CHR)
table(chr) # 16 21 26

autozM2_hol%>%
  filter(Prop>=0.4) %>%
  filter(CHR==16) %>%
  summarise(max=max(BP),min=min(BP), mean(BP))

c40<-autozM2_hol%>%
  filter(Prop>=0.4)

names(c40)<- c("CHR","BP","Prop")
c40<-c40[,-3] 
c40$n<- 1:nrow(c40)
c40$zero<- 0
c40<- c40[,c(1,3,4,2)]



cow_genes<-import_gff_gtf("~/Desktop/Final Project/Bos_taurus.ARS-UCD1.2.103.gtf", file_type = "gtf")



hol_gene<- find_genes_qtls_around_markers(
  db_file=cow_genes,
  marker_file=c40,
  method = "gene",
  marker = "snp",
  interval = 50000,
  nThreads = NULL,
  verbose = TRUE
)


DT::datatable(hol_gene, rownames = FALSE, 
              extensions = 'FixedColumns',
              options = list(scrollX = TRUE))
