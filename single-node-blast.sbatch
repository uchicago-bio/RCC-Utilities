#!/bin/bash
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --job-name=blast-single-node
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16

# load your modules here
module load blastplus

# Create an output directory
#WORKDIR=/scratch/midway/$USER/$SLURM_JOBID
WORKDIR=$SLURM_JOBID
mkdir -p $WORKDIR

# Start time
echo "Starting Job: $1 with id: $SLURM_JOBID"
date

# Blastplus
DB='nr'
QUERY="protein1.fasta"
NUMBER_OF_THREADS=16
BLAST_RESULTS="$SLURM_JOBID.blast-results-$NUMBER_OF_THREADS.txt"
blastp -query protein1.fasta -db $DB -out $BLAST_RESULTS -num_threads $NUMBER_OF_THREADS

# Finished
echo "Done with processing"
date

# Copy all the output files to that directory
`cp $0 $WORKDIR`
`cp $QUERY $WORKDIR`
`mv $SLURM_JOBID.out $SLURM_JOBID.err $WORKDIR`
`mv $BLAST_RESULTS $WORKDIR`
