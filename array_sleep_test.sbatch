#!/bin/bash
#SBATCH -A mpcs56420
#SBATCH --job-name=array_job_test    # Job name
#SBATCH --mail-type=ALL               # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=abinkowski@uchicago.edu    # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --mem=1gb                     # Job memory request
#SBATCH --time=00:15:00               # Time limit hrs:min:sec
#SBATCH --output=%j.%a.array_job.out
#SBATCH --error=%j.%a.array_job.err

#SBATCH --array=0-10


echo "Starting Job: $SLURM_ARRAY_TASK_ID -- $SLURM_TASK_ID with id: $SLURM_JOBID"
date

PADDED_NUMBER=$(printf %02d $SLURM_ARRAY_TASK_ID)

#DB="/project/mpcs56420/nr/nr.$PADDED_NUMBER"
pwd
hostname
date
sleep 5

echo "HI from $SLURM_ARRAY_TASK_ID $SLURM_TASK_ID PRETTY_NUMBER: $PADDED_NUMBER"

################################################################################
# Finished
################################################################################
echo "Done with processing"
