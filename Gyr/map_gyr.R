map_gyr<-read.table('cattle__732993variants__27individuals.map', header = F)
map_gyr<-data.frame(seq(1:732993), map_gyr)
names(map_gyr)<-c('N','chr','SNP','Distance','Position')
map_gyr<-map_gyr[,c(2,1,5)]
map_gyr$zero<-0
map_gyr<-map_gyr[,c(1,2,4,3)]
names(map_gyr)<-c('Chromosome','Name','Distance','Position')
write.table(map_gyr,"gyr.map", quote = F, sep= " ", row.names = FALSE, col.names = FALSE)
