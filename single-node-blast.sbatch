#!/bin/bash
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --job-name=blast-single-node
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16

###########################################################################################
# load your modules here
###########################################################################################
module load blastplus

###########################################################################################
# Create an output directory with the same name as your `SLURM_JOBID`
###########################################################################################
# In practice, you would write your data to the /scratch partition instead of /home
#WORKDIR=/scratch/midway/$USER/$SLURM_JOBID
WORKDIR=$SLURM_JOBID
mkdir -p $WORKDIR

###########################################################################################
# Dump the Start time to STDOUT
###########################################################################################
echo "Starting Job id: $SLURM_JOBID"
date

###########################################################################################
# Blastplus
###########################################################################################
DB='nr'
QUERY="protein1.fasta"
NUMBER_OF_THREADS=16
BLAST_RESULTS="$SLURM_JOBID.blast-results-$NUMBER_OF_THREADS.txt"
blastp -query protein1.fasta -db $DB -out $BLAST_RESULTS -num_threads $NUMBER_OF_THREADS

###########################################################################################
# Dump the Finished time to stdout
###########################################################################################
echo "Done with processing..."
date

###########################################################################################
# Copy all the output files to that directory
###########################################################################################
`cp $0 $WORKDIR`
`cp $QUERY $WORKDIR`
`mv $SLURM_JOBID.out $SLURM_JOBID.err $WORKDIR`
`mv $BLAST_RESULTS $WORKDIR`
