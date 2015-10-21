#!/bin/bash
#SBATCH --output=%A-%a.out
#SBATCH --error=%A-%a.err
#SBATCH --job-name=blast-per-node
#SBATCH --ntasks=1
#SBATCH --array=0-14
#SBATCH --partition=sandyb

################################################################################
# load your modules here
################################################################################
module load blastplus

################################################################################
# Create an output directory
################################################################################
#WORKDIR=/scratch/midway/$USER/$SLURM_JOBID
WORKDIR="$SLURM_ARRAY_JOB_ID"
mkdir -p $WORKDIR

################################################################################
# Start time
################################################################################

echo "Starting Job: $SLURM_ARRAY_TASK_ID -- $SLURM_TASK_ID with id: $SLURM_JOBID"
date

################################################################################
# Blastplus
################################################################################
PRETTY_NUMBER=$(printf %02d $SLURM_ARRAY_TASK_ID)
DB="nr.$PRETTY_NUMBER"
QUERY="protein1.fasta"
NUMBER_OF_THREADS=1
BLAST_RESULTS="$WORKDIR/$SLURM_ARRAY_JOB_ID.$SLURM_ARRAY_TASK_ID.blast-results-$NUMBER_OF_THREADS.txt"

# blast command
time blastp -query protein1.fasta -db $DB -out $BLAST_RESULTS -num_threads $NUMBER_OF_THREADS -outfmt 6

# Log this from each node that is running a job for debugging; this will go to STDOUT
echo "HI from $SLURM_ARRAY_TASK_ID $SLURM_TASK_ID PRETTY_NUMBER: $PRETTY_NUMBER"

################################################################################
# Finished
################################################################################
echo "Done with processing"
date

################################################################################
# Copy all the output files to that directory
################################################################################
`cp $0 $WORKDIR`
`cp $QUERY $WORKDIR`
`mv $SLURM_ARRAY_JOB_ID-* $WORKDIR`
