#!/bin/bash
#SBATCH -A mpcs56430
#SBATCH --job-name=hello_world     # Job name
#SBATCH --nodes=6                  # Number of nodes
#SBATCH --ntasks-per-node=1        # Number of tasks per node (1 task per node)
#SBATCH --time=00:05:00            # Time limit hrs:min:sec
#SBATCH --output=hello_world_%j.out   # Standard output and error log
#SBATCH --error=hello_world.%j.err    # Output file for stderr


# Load necessary modules (if any)
# module load some_module

# Print a message from each node
srun echo "Hello, World from node $(hostname)"
