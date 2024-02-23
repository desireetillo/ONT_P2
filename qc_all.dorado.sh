#!/bin/bash

#SBATCH --partition="norm,ccr"
#SBATCH --mem=24g
#SBATCH --mail-type="ALL"
#SBATCH --cpus-per-task=16
#SBATCH --time=4:00:00
#SBATCH --gres=lscratch:20

dir=$1

source /data/GAU/conda/etc/profile.d/conda.sh
conda activate nanopore

module load R


seqsummary=`ls $dir/*summary*.tsv`
echo $seqsummary
Rscript /data/GAU/projects/nanopore/bin/minion_qc/MinIONQC.R -i $dir/$seqsummary -o qc/$dir.MinIONQC
pycoQC --summary_file $seqsummary  --html_outfile qc/$dir.pycoQC_report.html  --report_title $dir;
fastq=`ls $dir/*fastq.gz`
echo $fastq;
NanoPlot -t 12 --fastq $fastq -o qc/$dir.NanoPlot


