#!/bin/bash
#SBATCH --account=mpcs56430
#SBATCH --job-name=job_3                       # Job name
#SBATCH --mail-type=ALL                        # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=abinkowski@uchicago.edu    # Where to send mail
#SBATCH --ntasks=1                             # Run on a single CPU
#SBATCH --output=%j.job_3.out
#SBATCH --error=%j.job_3.err

#
# Run with command:
#    sbatch sleep_test.sbatch
#

echo "> job_3"
echo -n "\t> Started: "; date
echo -n "\t> Present Working Directory: "; pwd
echo -n "\t> Running on Node: "; hostname

# Run any commands
time sleep 5

echo "job_3: this is from job 3 "$SLURM_JOBID >> workflow.out
echo "> Done Running"
