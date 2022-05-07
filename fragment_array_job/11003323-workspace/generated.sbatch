#!/bin/bash
#SBATCH -A mpcs56420
#SBATCH --output=%A-%j-%a.out
#SBATCH --error=%A-%j-%a.err
#SBATCH --job-name=custom_array_job
#SBATCH --ntasks=1
#SBATCH --partition=broadwl
#SBATCH --array=0-1

echo "> Custom array job - This file is generated at runtime"
date
hostname
pwd

echo "> SLURM VARIABLES"
echo ">   ArrayJob: $SLURM_ARRAY_JOB_ID JobId: $SLURM_JOB_ID TaskId: $SLURM_ARRAY_TASK_ID"
echo ">"
echo "> Run you script here with a database chunk: script.py temp_$SLURM_ARRAY_TASK_ID.db"

sleep 15
#blastq 

date
