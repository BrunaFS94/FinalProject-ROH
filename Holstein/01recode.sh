#!/bin/bash
#SBATCH --job-name=make_binary
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=30G
#SBATCH --partition=mcbstudent
#SBATCH --qos=mcbstudent
#SBATCH --mail-type=ALL
#SBATCH --mail-user=gabriella.dodd@uconn.edu

#plink/1.07
module load plink/1.90.beta.4.4
#module load plink/2.00a2.3LM

cp cattle__732993variants__60individuals.ped holstein.ped
plink --file holstein --cow --noweb --recode12
