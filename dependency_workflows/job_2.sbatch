#!/bin/bash
#SBATCH --account=mpcs56430
#SBATCH --job-name=job_2                       # Job name
#SBATCH --mail-type=ALL                        # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=abinkowski@uchicago.edu    # Where to send mail
#SBATCH --ntasks=1                             # Run on a single CPU
#SBATCH --output=%j.job_2.out
#SBATCH --error=%j.job_2.err

#
# Run with command:
#    sbatch sleep_test.sbatch
#

echo "> job_2"
echo -n "\t> Started: "; date
echo -n "\t> Present Working Directory: "; pwd
echo -n "\t> Running on Node: "; hostname

# Run any commands
time sleep 30

echo "job_2: this is from job 2" $SLURM_JOBID >> workflow.out
echo "> Done Running"
