#!/bin/bash

## Update these variables for your own runs.  
## Make sure to change the `mail` flag or I 
## will get the emails, not you :)

#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --job-name=blast-single-node
#SBATCH --nodes=1
#SBATCH --tasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1    # Number of threads per task

#SBATCH --partition=sandyb   # 'sandby' has 16 cores/ 32G memory; look up what is appropriate for job
#SBATCH --mem-per-cpu=16000  # Default is 2000 (2G)

## Change this to you email or I will get your jobs
## status emails.
#SBATCH --mail-type=ALL                                                      
#SBATCH --mail-user=abinkowski@uchicago.edu                                                            

###########################################################################################
# Load the blastplus module (preloaded on RCC)  
###########################################################################################
module load blastplus

###########################################################################################
# Create an output directory; blastplus creates many different files                                   
# that you will want to keep track of per job                                                          
# Example of writing to a different path:                                                              
#                         WORKDIR=/scratch/midway/$USER/$SLURM_JOBID                                   
#
# For convienence, we have an extra argument that we can use to                                        
# differentiate runs ($1 means the first argument after the executable name                            
#
# Note: In practice you should write data to /scratch and then move the data later
###########################################################################################
JOBNAME=$1
WORKDIR=$SLURM_JOBID"-"$JOBNAME
mkdir -p $WORKDIR

################################################################################
# Copy all of the input files to the directory. This way you can recreate the 
# run again.
################################################################################
`cp $0 $WORKDIR`
`cp $QUERY $WORKDIR`

################################################################################
# We are interested in tracking how long these take to run.  We also                                   
# want to track how long the job was in the queue.  Slurm keeps an                                     
# output and error file for each job.  All the standard output and                                     
# error will be directed there. 
################################################################################
echo "Starting Job id: $SLURM_JOBID"
date

################################################################################
# BLAST arguments
################################################################################
# Full `nr` database.  Look in the directory and see how BLAST structures the 
# files.  They chuck them into groups.
DB="/project2/mpcs56420/nr/nr"
QUERY="protein1.fasta"
BLAST_RESULTS="$SLURM_JOBID.blast-results-$SLURM_TASKS_PER_NODE-$SLURM_CPUS_PER_TASK.txt"

# Run blastp (use time in front to track runtime)                                                      
time blastp -query protein1.fasta \
     -db $DB \
     -out $BLAST_RESULTS \
     -num_threads $SLURM_CPUS_PER_TASK

################################################################################
# Dump the Finished time to stdout so we know we are done
################################################################################
echo "Done with processing..."
date

################################################################################
# All the files are written to current directory.  Copy all                                            
# the output files that were created to our job directory 
################################################################################
`mv $SLURM_JOBID.out $SLURM_JOBID.err $WORKDIR`
`mv $BLAST_RESULTS $WORKDIR`

echo "All files were moved..."
echo "Script completed"
