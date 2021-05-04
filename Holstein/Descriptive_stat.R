#######################################################
#computing statistics and inbreeding coefficients(f)
######################################################

#First, set the accordingly directory 
hom<-  read.table("holstein-ROH.hom", h=T)
hom.indiv<-  read.table("holstein-ROH.hom.indiv", h=T)

#number of segments
n_segments<- nrow(hom)

#computing ROH mean_length for each individual and general from the samples
mean.individual.ROH<- round(mean(hom.indiv$KBAVG),2)
mean.general.ROH<- round(mean(hom.indiv$KB),2)

#inbreeding coefficient
taurus.genome<- 2489.37
hom.indiv$f<- (hom.indiv$KB / 2489.37)/1000
mean_f<- round(mean(hom.indiv$f),3) 


# put some them in a table:
tble <- data.frame( Summaries = c(n_segments, mean.individual.ROH, mean.general.ROH,
                                  mean_f))

row.names(tble) <- c("ROH sample number", "Individual ROH length", "Total ROH length",
                     "Inbreeding coefficient")
 
