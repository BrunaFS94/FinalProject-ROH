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

plink --cow --allow-no-sex --nonfounders --file plink --autosome --mind 0.2 --geno 0.05 --maf 0.000001 --hwe 1e-10 --missing --make-bed --out plinkQC
