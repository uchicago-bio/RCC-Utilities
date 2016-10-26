#!/bin/bash
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --job-name=blast-single-node
#SBATCH --nodes=1
#SBATCH --tasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1    # Number of threads per task
#SBATCH --partition=sandyb   # 'sandby' has 16 cores/ 32G memory; look up what is appropriate for job
#SBATCH --mem-per-cpu=16000  # Default is 2000 (2G)
#SBATCH --mail-type=ALL                                                                                
#SBATCH --mail-user=abinkowski@uchicago.edu                                                            

JOBNAME=$1
WORKDIR=$SLURM_JOBID"-"$JOBNAME
mkdir -p $WORKDIR


################################################################################
# We are interested in tracking how long these take to run.  We also                                   
# want to track how long the job was in the queue.  Slurm keeps an                                     
# output and error file for each job.  All the standard output and                                     
# error will be directed there. 
################################################################################
echo "Starting Job id: $SLURM_JOBID"
date
lscpu
echo "Done with processing..."


date

`cp $0 $WORKDIR`
`mv $SLURM_JOBID.out $SLURM_JOBID.err $WORKDIR`
