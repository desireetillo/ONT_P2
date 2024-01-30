#!/bin/bash

#SBATCH --partition="norm,ccr"
#SBATCH --mem=24g
#SBATCH --mail-type="ALL"
#SBATCH --cpus-per-task=16
#SBATCH --time=4:00:00
#SBATCH --gres=lscratch:20

dir=20220929_1851_MN31566_FAO87921_e1ad78b8.basecalls
combined_fastqs=fastq

source /data/GAU/conda/etc/profile.d/conda.sh
conda activate nanopore

#module load R

#Rscript /data/GAU/projects/nanopore/bin/minion_qc/MinIONQC.R -i $dir/ -o qc/MinIONQC
seqsummary=`ls $dir/*sequencing_summary*.txt`
pycoQC --summary_file $dir/sequencing_summary.txt  --html_outfile qc/$dir.pycoQC_report.html  --report_title $dir;
fastq=`ls $combined_fastqs/*/*all.fastq.gz`
echo $fastq;
NanoPlot -t 12 --fastq $fastq -o qc/$dir.NanoPlot

