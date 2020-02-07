#!/bin/bash -login
#SBATCH -p bmh
#SBATCH -J ggg201b-megahit
#SBATCH -t 0:30:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --mem=10gb

. ~/miniconda3/etc/profile.d/conda.sh

cd $SLURM_SUBMIT_DIR

conda activate assemblyfiz

set -o nounset
set -o errexit
set -x

snakemake -p -n

env | grep SLURM            # Print out values of the current jobs SLURM environment variables

scontrol show job ${SLURM_JOB_ID}     # Print out final statistics about resource uses before job exits

sstat --format 'JobID,MaxRSS,AveCPU' -P ${SLURM_JOB_ID}.batch
