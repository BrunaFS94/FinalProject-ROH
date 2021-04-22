#R file that can be run using 00map.sh on Xanadu cluster. Prepares file format for PLINK.

map_hol<-read.table('cattle__732993variants__60individuals.map', header = F)
map_hol<-data.frame(seq(1:732993), map_hol)
names(map_hol)<-c('N','chr','SNP','Distance','Position')
map_hol<-map_hol[,c(2,1,5)]
map_hol$zero<-0
map_hol<-map_hol[,c(1,2,4,3)]
names(map_hol)<-c('Chromosome','Name','Distance','Position')
write.table(map_hol,"holstein.map", quote = F, sep= " ", row.names = FALSE, col.names = FALSE)
