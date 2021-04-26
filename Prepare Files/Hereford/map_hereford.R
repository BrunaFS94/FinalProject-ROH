map_hfd<-read.table('cattle__732993variants__35individuals.map', header = F)
map_hfd<-data.frame(seq(1:732993), map_hfd)
names(map_hfd)<-c('N','chr','SNP','Distance','Position')
map_hfd<-map_hol[,c(2,1,5)]
map_hfd$zero<-0
map_hfd<-map_hfd[,c(1,2,4,3)]
names(map_hfd)<-c('Chromosome','Name','Distance','Position')
write.table(map_hfd,"hereford.map", quote = F, sep= " ", row.names = FALSE, col.names = FALSE)
