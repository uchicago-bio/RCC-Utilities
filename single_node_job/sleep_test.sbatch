#!/bin/bash
#SBATCH --account=mpcs56420
#SBATCH --job-name=sleep_job          # Job name
#SBATCH --mail-type=ALL               # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=abinkowski@uchicago.edu    # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --output=%j.sleep_job.out
#SBATCH --error=%j.sleep_job.err

#
# Run with command:
#    sbatch sleep_test.sbatch
#

#python myCpG_script.py

echo "> Running Sleep script on a single CPU core"
echo -n "> Date: "; date
echo -n "> Present Working Directory: "; pwd
echo -n "> Running on Node: "; hostname

# Run any commands
echo "> Sleep Command"
time sleep 5

echo "> Done Running"
