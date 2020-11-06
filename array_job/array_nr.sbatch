#!/bin/bash
#SBATCH -A mpcs56420
#SBATCH --job-name=nr                 # Job name
#SBATCH --mail-type=ALL               # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=abinkowski@uchicago.edu    # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --mem=1gb                     # Job memory request
#SBATCH --time=00:15:00               # Time limit hrs:min:sec
#SBATCH --output=%j.%a.array_job.out
#SBATCH --error=%j.%a.array_job.err
#SBATCH --array=1-10



# -----------------------------------------------------------------------------
# This will be run N number of times (array variable)
# -----------------------------------------------------------------------------
echo "Starting Job: $SLURM_ARRAY_TASK_ID -- $SLURM_TASK_ID with id: $SLURM_JOBID"
date

# Use the array task id to change what is being run each time
DATABASE="/project2/mpcs56420/db/nr/nr.$SLURM_ARRAY_TASK_ID"
OUTFILE=$SLURM_ARRAY_TASK_ID".out"

echo $DATABASE
echo $OUTFILE

blastp -query spike.fasta \
    -db $DATABASE \
    -out $OUTFILE \
    -num_threads 1

