#!/bin/bash
#SBATCH -A mpcs56430
#SBATCH --job-name=hello_world     # Job name
#SBATCH --nodes=6                  # Number of nodes
#SBATCH --ntasks-per-node=1        # Number of tasks per node (1 task per node)
#SBATCH --time=00:05:00            # Time limit hrs:min:sec
#SBATCH --output=hello_world-%j.out   # Standard output and error log
#SBATCH --error=hello_world-%j.err    # Output file for stderr

echo "Running Hello World on $SLURM_JOB_NUM_NODES nodes..."
echo "---------------------------------------------"
echo "The following nodes have been allocated"
scontrol show hostnames $SLURM_JOB_NODELIST

# The 'srun' command executes the following command on all allocated tasks.
# Since we requested 6 nodes with 1 task per node, this will run 'hostname'
# once on each of the 6 different nodes.
srun bash -c 'echo "$(hostname): $(date)"'


echo "Done..."
