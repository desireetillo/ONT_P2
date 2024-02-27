#!/bin/bash

#SBATCH --partition="norm,ccr"
#SBATCH --mem=24g
#SBATCH --mail-type="ALL"
#SBATCH --cpus-per-task=16
#SBATCH --time=4:00:00
#SBATCH --gres=lscratch:20

dir=$1
outdir=$dir/qc

SCRIPT_DIR=/data/GAU/projects/nanopore/Plasmid_sequencing/P2/Scripts

source /data/GAU/conda/etc/profile.d/conda.sh
conda activate nanopore

mkdir $outdir;

multiqc_config=$SCRIPT_DIR/ones_multiqc.yaml

seqsummary=`ls $dir/*summary*.tsv`
echo $seqsummary

pycoQC --summary_file $seqsummary  --html_outfile $outdir/$dir.pycoQC_report.html  --report_title $dir;

fastq=`ls $dir/fastq/*/*fastq.gz`
echo $fastq;
NanoPlot -t 12 --fastq $fastq -o $outdir/$dir.NanoPlot

module load fastqc
mkdir $outdir/fastqc

fastqc $fastq -t 12 -o $outdir/fastqc

cd $outdir
module load multiqc
multiqc -f -c $multiqc_config $dir.NanoPlot fastqc
