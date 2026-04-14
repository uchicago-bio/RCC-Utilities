#!/bin/bash
#SBATCH --account=mpcs56420                 # Allocation
#SBATCH --job-name=serial_job_test    # Job name
#SBATCH --mail-type=ALL               # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=abinkowski@uchicago.edu    # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --cpus-per-task=1             # Number of threads per task
#SBATCH --mem=1gb                     # Job memory request
#SBATCH --time=00:15:00               # Time limit hrs:min:sec
#SBATCH --output=%j.serial_job.out
#SBATCH --error=%j.serial_job.err

DATABASE="/project2/mpcs56420/db/pdbaa"
OUTFILE="out.txt"

echo "> Slurm Id:       "$SLURM_JOBID
echo "> Tasks per node: "$SLURM_TASKS_PER_NODE
echo "> CPUS per task:  "$SLURM_CPUS_PER_TASK
echo -n "> Date:           ";date
echo -n "> Pwd:            ";pwd
echo -n "> Hostname:       ";hostname

echo "> Running script on a single CPU core"
echo "> Staring BLASTp"

blastp -query spike.fasta \
    -db $DATABASE \
    -out $OUTFILE \
    -num_threads 1

sleep 60

echo "> Outfile: "$OUTFILE

