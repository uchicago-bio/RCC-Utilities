#!/bin/bash
#SBATCH --job-name=serial_job_test    # Job name
#SBATCH --mail-type=ALL               # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=abinkowski@uchicago.edu    # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --cpus-per-task=1             # Number of threads per task
#SBATCH --mem=1gb                     # Job memory request
#SBATCH --time=00:15:00               # Time limit hrs:min:sec
#SBATCH --output=%j.serial_job.out
#SBATCH --error=%j.serial_job.err

echo "> Running plot script on a single CPU core"
pwd; hostname; date

echo "> Staring blastp"
blastp -query spike.fasta -db /project2/mpcs56420/db/pdbaa -out dog_node.out -num_threads 1
echo "> Done Running"

