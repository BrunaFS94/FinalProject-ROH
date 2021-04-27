#!/bin/bash
#SBATCH --job-name=make_binary
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=30G
#SBATCH --partition=mcbstudent
#SBATCH --qos=mcbstudent
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu

#plink/1.07
module load plink/1.90.beta.4.4
#module load plink/2.00a2.3LM


#Estimation of number of SNPs
# log(0.05/(63163*91))/ log(1-0.3393)     Lencz et al. 2007 
# 44.78182
DATA="plinkQC"
#Set ROH variables
SNP="50"       # --homozyg-snp [min var count]
KB="1000"      # --homozyg-kb [min length]
DENSITY="100"  # --homozyg-density [max inverse density (kb/var)]
GAP="500"      # --homozyg-gap [max internal gap kb length]
WIN_HET="1"    # --homozyg-window-het [max hets in scanning window hit]
WIN_MISS="4"   # --homozyg-window-missing [max missing calls in scanning window hit]
WIN_THR="0.05" # --homozyg-window-threshold [min scanning window hit rate]
OUT3="gyr-ROH"

#Perform ROH search
plink --cow --noweb --allow-no-sex --nonfounders --bfile $DATA --homozyg-snp $SNP --homozyg-kb $KB --homozyg-density $DENSITY --homozyg-gap $GAP --homozyg-window-het $WIN_HET --homozyg-window-missing $WIN_MISS --homozyg-window-threshold $WIN_THR --out $OUT3
