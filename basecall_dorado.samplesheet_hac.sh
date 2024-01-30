#!/bin/bash
#SBATCH --partition=gpu
#SBATCH --time=24:00:00
#SBATCH --mem=16g
#SBATCH --job-name=dorado
#SBATCH --gres=lscratch:200,gpu:v100x:1
#SBATCH --cpus-per-task=6
#SBATCH --mail-type=ALL


#dorado basecaller --device cuda:all ${DORADO_MODELS}/dna_r9.4.1_e8_sup@v3.3 input > output.bam

DIR=$1 #FULLPATH
OUTPUT_DIR=$2 # OUTPUT_DIR
#SAMPLE_SHEET=$3
MODEL=${DORADO_MODELS}/dna_r10.4.1_e8.2_400bps_hac@v4.3.0 # NEWEST as of 1/30/24


workdir=`pwd`
OUTPUT_BAM=$workdir/$OUTPUT_DIR/dorado.bam
mkdir -p $OUTPUT_DIR;

module load dorado/0.5.1
ls $MODEL
dorado basecaller --device cuda:all $MODEL $DIR --kit-name SQK-RBK114-96 --recursive >$OUTPUT_BAM
dorado summary $OUTPUT_BAM > $workdir/$OUTPUT_DIR/summary.tsv

cd /lscratch/$SLURM_JOB_ID
dorado demux --output-dir . --no-classify  $OUTPUT_BAM --emit-fastq --sample-sheet $DIR/SampleSheet.csv
gzip *fastq
mv *gz $workdir/$OUTPUT_DIR/
