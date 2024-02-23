#!/bin/bash

#SBATCH --partition="norm,ccr"
#SBATCH --mem=24g
#SBATCH --mail-type="ALL"
#SBATCH --cpus-per-task=16
#SBATCH --time=4:00:00
#SBATCH --gres=lscratch:20

dir=$1
$SCRIPT_DIR=/data/GAU/projects/nanopore/Plasmid_sequencing/P2/Scripts

source /data/GAU/conda/etc/profile.d/conda.sh
conda activate nanopore

mkdir qc;
multiqc_config=$SCRIPT_DIR/ones_multiqc.yaml
seqsummary=`ls $dir/*summary*.tsv`
echo $seqsummary

pycoQC --summary_file $seqsummary  --html_outfile qc/$dir.pycoQC_report.html  --report_title $dir;

fastq=`ls $dir/*/*fastq.gz`
echo $fastq;
NanoPlot -t 12 --fastq $fastq -o qc/$dir.NanoPlot

module load fastqc
fastqc $fastq -t 12 -o qc/fastqc

cd qc;
module load multiqc
multiqc -f -c $multiqc_config $dir.Nanoplot fastqc
