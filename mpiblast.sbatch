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
# Step 1:                                                                                                                                                                                               
# mpiformatdb --nfrags=14 -i pdb1000.fasta -o T                                                                                                                                                         
################################################################################                                                                                                                        

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
# Blastplus                                                                                                                                                                                             
################################################################################                                                                                                                        
DB=nr
QUERY="protein1.fasta"
BLAST_RESULTS="mpiblast-results.txt"

# using default folder (/gpfs/scratch/shared/mpiblast)                                                                                                                                                  
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

