#!/bin/bash                                                                                                                                                                                    
#SBATCH --output=%j.out                                                                                                                                                                        
#SBATCH --error=%j.err                                                                                                                                                                         
#SBATCH --job-name=mpi-blast                                                                                                                                                                   
# Use 2 nodes with 8 tasks each, for 16 MPI task:s                                                                                                                                             
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8
#SBATCH --mail-type=ALL
#SBATCH --mail-user=abinkowski@uchicago.edu
#SBATCH --partition=sandyb                                                                                                                                                                     
# this job requests exclusive access to the nodes it is given                                                                                                                                  
# this mean it will be the only job running on the node                                                                                                                                        
#SBATCH --exclusive                                                                                                                                                                            
#SBATCH --constraint=ib                                                                                                                                                                        

################################################################################                                                                                                               
# load your modules here                                                                                                                                                                       
################################################################################                                                                                                               
module load mpiblast

################################################################################                                                                                                               
# Create an output directory                                                                                                                                                                   
################################################################################                                                                                                               
WORKDIR=/scratch/midway/$USER/mpiblast/$SLURM_JOBID"-"$1
mkdir -p $WORKDIR

################################################################################                                                                                                               
# Start time                                                                                                                                                                                   
################################################################################                                                                                                               
echo "Starting Job: $1 with id: $SLURM_JOBID"; date

################################################################################                                                                                                               
# Blast arguments
################################################################################                                                                                                               
DB=pdb.fasta  # This is a small database of proteins; useful to check if you have everything set up correctly
#DB=nr # Full NCBI nr database

QUERY="protein1.fasta"
BLAST_RESULTS="mpiblast-results.txt"

################################################################################                                                                                                               
# Run mpiblast (results will be written to location specied in the .ncbri
# path
################################################################################                                                                                                               
SLURM_NPROCS=$(( $SLURM_NNODES * $SLURM_NTASKS_PER_NODE ))
time mpirun -n $SLURM_NPROCS mpiblast  -p blastp -d $DB  -i $QUERY -o $BLAST_RESULTS --time-profile=time.txt --removedb --use-parallel-write
#-m 8 -b 1                                                                                                                                                                                     

################################################################################                                                                                                               
#                                                                                                                                                                                              
# Finished                                                                                                                                                                                     
#                                                                                                                                                                                              
################################################################################                                                                                                               
echo "Done with processing"; date

################################################################################                                                                                                               
#                                                                                                                                                                                              
# Copy all the output files to that directory                                                                                                                                                  
#                                                                                                                                                                                              
################################################################################                                                                                                               
`cp $0 $WORKDIR`
`cp $QUERY $WORKDIR`
`mv $SLURM_JOBID.out $SLURM_JOBID.err $WORKDIR`
`mv $BLAST_RESULTS $WORKDIR`
`mv time.txt $WORKDIR`

