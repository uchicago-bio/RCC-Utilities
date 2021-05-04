#!/bin/bash
#SBATCH -A mpcs56420
#SBATCH --job-name=refseq    # Job name
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
echo "> Slurm Id:           "$SLURM_JOBID
echo "> Array Task - Task : $SLURM_ARRAY_TASK_ID -- $SLURM_TASK_ID with id: $SLURM_JOBID"
echo "> Tasks per node:     "$SLURM_TASKS_PER_NODE
echo "> CPUS per task:      "$SLURM_CPUS_PER_TASK
echo -n "> Date:           ";date
echo -n "> Pwd:            ";pwd
echo -n "> Hostname:       ";hostname


# Use the array task id to change what is being run each time
DATABASE="/project2/mpcs56420/db/nr/nr.$SLURM_ARRAY_TASK_ID"
OUTFILE=$SLURM_ARRAY_TASK_ID".blast_out"

blastp -query spike.fasta \
    -db $DATABASE \
    -out $OUTFILE \
    -num_threads 1


echo "> Working On: $SLURM_ARRAY_TASK_ID $SLURM_TASK_ID"
echo "> Database: $DATABASE"


# Look at the single array job example for file management techniques

