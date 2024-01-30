#!/bin/bash
#SBATCH --partition=gpu
#SBATCH --time=24:00:00                                                                                                                                                                       
#SBATCH --mem=20g
#SBATCH --job-name=guppy
#SBATCH --gres=lscratch:200,gpu:p100:1
#SBATCH --cpus-per-task=14
#SBATCH --mail-type=ALL

# --partition=gpu --cpus-per-task=14 --mem=16g --gres=lscratch:200,gpu:p100:1 

DIR=20220929_1851_MN31566_FAO87921_e1ad78b8

module load guppy/6.5.7

guppy_basecaller --input_path $DIR \
  --recursive \
  --save_path $DIR.basecalls \
  --flowcell FLO-MIN106 \
  --kit SQK-RBK004 \
  --device "auto" \
  --compress_fastq \
  --barcode_kits SQK-RBK004 \
  --cpu_threads_per_caller $SLURM_CPUS_PER_TASK 
