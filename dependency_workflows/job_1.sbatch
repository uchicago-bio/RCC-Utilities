#!/bin/bash
#SBATCH --account=mpcs56430
#SBATCH --job-name=job_1                       # Job name
#SBATCH --mail-type=ALL                        # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=abinkowski@uchicago.edu    # Where to send mail
#SBATCH --ntasks=1                             # Run on a single CPU
#SBATCH --output=%j.job_1.out
#SBATCH --error=%j.job_1.err

#
# Run with command:
#    sbatch sleep_test.sbatch
#

echo "> job_1"
echo -n "> Started: "; date
echo -n "> Present Working Directory: "; pwd
echo -n "> Running on Node: "; hostname

# Run any commands
time sleep 30

echo "job_1: this is from job_1 "$SLURM_JOBID > workflow.out
echo "> Done Running"
 