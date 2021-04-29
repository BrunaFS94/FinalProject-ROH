1. Overview

Runs of homozygosity (ROH) are continuous homozygous segments of the DNA sequence in diploid genomes. ROH patterns result from population phenomena such as genetic drift, population bottleneck, inbreeding, and intensive artificial selection, additionally can provide insight about population history and structure. The identification of ROH hot spots is also used to find disease-causing genes that are generally recessive, preserve populations, and maintain genetic diversity in long-term animal breeding programs, while monitoring the inbreeding rate. It is also used to explore signatures of selection, considering that genomic regions sharing ROH potentially contain alleles associated with genetic improvement in livestock. Single nucleotide polymorphisms (SNPs) are the most common type of genetic variation within the genome. Due to their high abundance in the genome, SNPs are used as the predominant marker type. High-density SNP arrays have been used to identify ROH allowing comparison of the degree of homozygosity among populations. The objective of this study is to identify and characterize homozygous segments present in the genome of three bovine breeds, as well as identify the most common genes shared in our samples and compare such genes according to physiological functions.
This tutorial will guide you through testing for runs of homozygosity.

2. Accessing Data

Begin by visiting the WIDDE website to download the data (http://widde.toulouse.inra.fr/widde/ ). Select the Cattle section and locate the three species of focus. 
Beginning with Gir check the box labeled “Chip: Illumina BovineHD ; Samples: 27”. You will see the marker selection box appear and you can select Chromosomes BTA1 through BTA29. You should have 27 individuals with 732,993 markers. Once you click the “Agree and proceed” button, check that the SNP ID is Illumina and the Export Format is PLINK. Once everything is correct you can select the Export Selection button and the files will begin downloading. 
Do the same with the Holstein and Hereford files. For Holstein you should select “Chip: Illumina BovineHD ; Samples: 60” and check that you have information from 60 individuals with 732,993 markers. For Hereford you should select “Chip: Illumina BovineHD ; Samples: 35” and check that you have information from 35 individuals with 732,993 markers.
Once you have all of your files downloaded, you can upload the .map and .ped files for each species to their respective folders on the Xanadu Cluster. 
Before running any script, your folders should look like this:

Runs of Homozygosity/
├── Holstein/
	├──00map_holstein.sh
	├──map_holstein.R
	├──01recode.sh
├──02quality-control.sh
├──03ROH.sh
	├──cattle__732993variants__60individuals.map
	├──cattle__732993variants__60individuals.ped
├── Gyr/
	├──00map_gyr.sh
	├──map_gyr.R
	├──01recode_gyr.sh
├──02qualitycontrol_gyr.sh
├──03ROH_gyr.sh
	├──cattle__732993variants__27individuals.map
	├──cattle__732993variants__27individuals.ped
└── Hereford/
	├──00map_hereford.sh
	├──map_hereford.R
	├──01recode_hereford.sh
├──02qualitycontrol_hereford.sh
├──03ROH_hereford.sh
	├──cattle__732993variants__35individuals.map
	├──cattle__732993variants__35individuals.ped

3. Prepare Files

Each folder should contain the scripts 00map_holstein.sh and map_holstein.R specific to each breed. The .sh file will load R in the cluster and run the R script in the folder. This will create a map file of the form holstein.map that will be formatted for PLINK.


4. Recode Files

Each folder should contain the file 01recode.sh. This file runs the PLINK software using these options: 
--noweb 		skips the web based check 
--recode12	outputs the new pedigree and map files with half allele coding

This file creates the files holstein.ped, plink.log, plink.ped, plink.map, and plink.nosex. The plink.nosex file contains the individuals who have an ambiguous sex listed. 

5. Quality Control

Each folder should contain the files 02qualitycontrol.sh script which has the following options involved:
--allow-no-sex		does not removed ambiguously sexed animals
--nonfounders 		includes all animals
--autosome 		    indicates that the chromosomes we are inputting are autosomal (non-sex chromosomes)
--mind 0.2 		    maximum per individual missing
--geno 0.05 		  maximum per SNP missing
--maf 0.000001 	  minor allele frequency
--hwe 1e-10 		  Hardy Weinberg Equilibrium p-value (exact)
--missing 		    missing rates
--make-bed 		    make .bed, .fam, .bim files

This file will filter our plink files to perform quality control. The file will output seven files with the precursor “plinkQC”: plinkQC.bed, plinkQC.fam, plinkQC.bim, plinkQC.imiss, plinkQC.lmiss, plinkQC.log, and plinkQC.nosex.

6. Runs of homozygosity

Each folder should contain the files 03ROH.sh script. This file will filter using plink to estimate the number of SNPs, set the runs of homozygosity variables, and perform a ROH search . The file will output five files with the precursor “holstein-ROH”: holstein-ROH.hom, holstein-ROH.hom.indiv, holstein-ROH.hom.summary, holstein-ROH.log, and holstein-ROH.nosex.

7. Descriptive Statistics

The output files :“holstein-ROH.hom, holstein-ROH.hom.indiv”were uploaded into R and some descriptive statistics were computed in order to characterize the ROH disposition across the samples.

8. Manhattan Plots

The output files “holstein-ROH.hom, holstein-ROH.hom.indiv” are also necessary for generating the Manhattan plots of the distribution of runs of homozygosity in the genomes under analysis, where the X-axis represents the distribution of ROH across the genome, and the Y-axis shows the frequency (%) of overlapping ROH shared among samples. There are many ways to create Manhattan Plots through R, we will utilize the R package qqman and command manhattan().

9. Gallo

The Genomic Annotation in Livestock for positional candidate LOci (GALLO) is an R package, and was utilized as a tool for the accurate annotation of genes located within candidate regions identified into the most common shared homozygous segments within our samples. The reference file for the Gallo package is linked here: https://cran.r-project.org/web/packages/GALLO/GALLO.pdf 

This package requires the download of a .gtf file from the Ensembl database to provide the reference gene annotation. For the Holstein analysis, the bos taurus reference file was used (https://useast.ensembl.org/Bos_taurus/Info/Index ). For the Hereford and Gyr analysis the bos indicus hybrid reference file was used (https://useast.ensembl.org/Bos_indicus_hybrid/Info/Index ). 

The script with the name gallo_holstein.R (or similar) contains code to format the marker file and run the gallo analysis. To search for genes by snp markers, the file must have a column labeled CHR for chromosome and a column labeled BP for base pair position. 

10. GProfiler

Gene set enrichment analyses were performed from input gene lists. It maps genes to known functional information sources and detects statistically significantly enriched terms. The three lists of genes generated through gallo, one from each breed, were used as input (https://biit.cs.ut.ee/gprofiler/gost). The organism selected in the browser options was bos taurus, for the other options the default was maintained. Results would comprehend gene ontology, biological pathways, protein databases and a few more.


