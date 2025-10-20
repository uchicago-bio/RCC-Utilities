#!/bin/bash
#SBATCH --account=mpcs56430
#SBATCH --job-name=single_node_sleep_job          # Job name
#SBATCH --nodes=1                    # Request a single node
#SBATCH --ntasks=1                   # Run a single task
#SBATCH --cpus-per-task=1            # Request 1 CPU core for the task
#SBATCH --mem=1gb                    # Request 1 gigabyte of memory
#SBATCH --time=00:05:00              # Time limit for the job (5 minutes)
#SBATCH --mail-type=ALL                           # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=your_email_here@uchicago.edu  # Where to send mail
#SBATCH --output=%j.sleep_job.out
#SBATCH --error=%j.sleep_job.err

#
# Run with command:
#    sbatch sleep_test.sbatch
#

cho "This job is running on a single node."
echo "Job started at: $(date)"
echo "-----------------------------------"
echo "Node Hostname: $(hostname)"
echo "-----------------------------------"

# Your actual commands would go here.
# For this example, we'll just sleep for a short time.
echo "Running a sample command (sleeping for 10 seconds)..."
sleep 10

echo "Job finished at: $(date)"
