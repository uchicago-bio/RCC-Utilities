#!/bin/bash
#SBATCH --job-name=serial_job_test    # Job name
#SBATCH --mail-type=ALL               # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=bbao@uchicago.edu    # Where to send mail
#SBATCH --ntasks=4                    # Run on a single CPU
#SBATCH --cpus-per-task=1             # Number of threads per task
#SBATCH --mem=20gb                     # Job memory request
#SBATCH --time=20:00:00               # Time limit hrs:min:sec
#SBATCH --output=%j.serial_job.out
#SBATCH --error=%j.serial_job.err
#SBATCH --nodes=4


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
pwd; hostname;

################################################################################
# BLAST arguments
################################################################################
# Use `pdb` database.  Look in the directory and see how BLAST structures the
# files.  They chuck them into groups.
DB="/project2/mpcs56420/db/swissprot.fasta"
QUERY="spike.fasta"
BLAST_RESULTS="output.txt"
ALIGNMENT="global"
SCORINGMATRIX="PAM250"
G=3

# Run 9.py (use time in front to track runtime)
time python 9.py --queryfile spike.fasta \
     --databasefile $DB \
     --scoringmatrix $SCORINGMATRIX \
     --alignment $ALIGNMENT \
     --gappenalty $G \
     --output $BLAST_RESULTS \
   
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
`mv $BLAST_RESULTS $WORKDIR/$BLAST_RESULTS`

echo "All files were moved..."
echo "Script completed"
