#!/bin/bash
#SBATCH -A mpcs56430
#SBATCH --job-name=array_sleep        # Job name
#SBATCH --mail-type=ALL               # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=your_email_here@uchicago.edu    # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --mem=1gb                     # Job memory request
#SBATCH --time=00:15:00               # Time limit hrs:min:sec
#SBATCH --output=%j.%a.array_sleep.out
#SBATCH --error=%j.%a.array_sleep.err
#SBATCH --array=0-10



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

# Use the array task id to change what is being run each time. SLURM uses one digit
# numbers, but NCBI uses two digit when fragmenting (just be consistent)
#DB="/project/mpcs56420/nr/nr.$PADDED_NUMBER"
PADDED_NUMBER=$(printf %02d $SLURM_ARRAY_TASK_ID)

sleep 15

echo "> Working On: $SLURM_ARRAY_TASK_ID $SLURM_TASK_ID PRETTY_NUMBER: $PADDED_NUMBER"
echo "> Done with processing"
