#!/bin/bash
#SBATCH -A mpcs56430
#SBATCH --job-name=monkey_shakespear  # Job name
#SBATCH --nodes=24                    # Number of nodes
#SBATCH --ntasks-per-node=1           # Number of tasks per node (1 task per node)
#SBATCH --time=00:05:00               # Time limit hrs:min:sec
#SBATCH --output=monkey_shakespear-%j.out   # Standard output and error log
#SBATCH --error=monkey_shakespear-%j.err    # Output file for stderr

echo "Running Hello World on $SLURM_JOB_NUM_NODES nodes..."
echo "---------------------------------------------"
echo "The following nodes have been allocated"
scontrol show hostnames $SLURM_JOB_NODELIST

# The 'srun' command executes the following command on all allocated tasks.
# Since we requested 6 nodes with 1 task per node, this will run 'hostname'
# once on each of the 6 different nodes.
srun python ../monkey_shakespear.py >> /home/$USER/monkey_shakespear_book.txt

echo "Done..."
