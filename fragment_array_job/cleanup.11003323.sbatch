#!/bin/bash
#SBATCH -A mpcs56420
#SBATCH --output=%j-cleanup.out
#SBATCH --error=%j-cleanup.err
#SBATCH --job-name=custom_array_job_cleanup
#SBATCH --ntasks=1
#SBATCH --partition=broadwl
#SBATCH --dependency=afterok:11003323

date
hostname
pwd

echo "Cleanup"
sleep 5
mkdir 11003323-workspace
mv 11003323-*out 11003323-workspace/
mv 11003323-*err 11003323-workspace/
mv generated.sbatch 11003323-workspace/
mv tempdb_*.db 11003323-workspace/
cp sample.db 11003323-workspace/
cp custom_array.py 11003323-workspace/

date
