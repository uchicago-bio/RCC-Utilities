#!/bin/bash
#SBATCH -A mpcs56430
#SBATCH --job-name=serial_job_test    # Job name
#SBATCH --mail-type=ALL               # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=abinkowski@uchicago.edu    # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --cpus-per-task=1             # Number of threads per task
#SBATCH --mem=1gb                     # Job memory request
#SBATCH --time=00:15:00               # Time limit hrs:min:sec
#SBATCH --output=%j.out
#SBATCH --error=%j.err


###########################################################################################
# Create an output directory; BLAST creates many different files
# that you will want to keep track of per job
#
# Example of writing to a different path:
#
#                         WORKDIR=/scratch/midway/$USER/$SLURM_JOBID
#
# Note: In practice you should write data to /scratch and then move the data later
#
# For convienence, we have an extra argument that we can use to
# differentiate runs ($1 means the first argument after the executable name
# Example: 
#           single-node-blastp.sbatch unique_name
#
###########################################################################################

if [ -z "$1" ]; then
    echo -e "\nPlease call '$0 <argument>' to run this command!\n"
    exit 1
fi
JOBNAME=$1
WORKDIR="/project2/mpcs56420/"$USER"/"$SLURM_JOBID"-"$JOBNAME
mkdir -p $WORKDIR


################################################################################
# BLAST arguments
################################################################################
DB="/project2/mpcs56430/db/pdbaa"
QUERY="spike.fasta"
BLAST_RESULTS="$SLURM_JOBID.blast-results-$SLURM_TASKS_PER_NODE-$SLURM_CPUS_PER_TASK.txt"

################################################################################
# We are interested in tracking how long these take to run.  We also
# want to track how long the job was in the queue.  Slurm keeps an
# output and error file for each job.  All the standard output and
# error will be directed there.
################################################################################
echo "> Starting Job Id: $SLURM_JOBID"
echo -n "> Date: "; date
echo -n "> Present Working Directory: "; pwd
echo -n "> Hostname: "; hostname
echo "> Database: $DB"
echo "> Query:    $QUERY"

# Run blastp (use time in front to track the actual runtime)
time blastp -query $QUERY \
    -db $DB \
    -out $BLAST_RESULTS \
    -outfmt 6 \
    -num_threads 1

################################################################################
# Dump the Finished time to stdout so we know we are done
################################################################################
echo -n "> Done with processing: "; date

################################################################################
# All the files are written to current directory.  Copy all
# the output files that were created to our job directory
################################################################################
###############################################################################
# Copy all of the input files to the directory. This way you can recreate the
# run again.
################################################################################
`mv $BLAST_RESULTS $WORKDIR/`
`cp $QUERY $WORKDIR/`
`mv $SLURM_JOBID.out $SLURM_JOBID.err $WORKDIR/`
# Copy the script used for the run
`cp $0 $WORKDIR/`

echo -n "> All files were moved..."
echo -n "> Script completed"
