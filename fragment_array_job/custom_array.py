#!/bin/env python

"""Many task workflow to fragment, submit and coallate a python script"""

import sys
import os
import time
import platform
import random
import subprocess

# -----------------------------------------------------------------------------
#
# Step 1
# Setup variables to change run behavior
#
# -----------------------------------------------------------------------------
NODES = 10
DATABASE = 'sample.db'
DATABASE_PREFIX = 'tempdb'
GENERATED_SBATCH = "generated.sbatch"

# -----------------------------------------------------------------------------
#
# Step 2
# Load in database file that is going to be split into equal chunks
#
# -----------------------------------------------------------------------------
with open(DATABASE) as f:
    lines = f.readlines()
# print(lines)

# How many lines should be in each chunk
chunks = round(len(lines) / NODES)

# Split database into equal sized chunks
chunked_db = [lines[i:i + chunks] for i in range(0, len(lines), chunks)]
#print(chunked_db)

# Write out each as a temporary database in the format `DATABASE_PREFIX_##.db"
for i in range(0,len(chunked_db)):
    filename = "%s_%s.db" % (DATABASE_PREFIX, i)
    with open(filename, "w") as outfile:
        outfile.write("".join(chunked_db[i]))

# -----------------------------------------------------------------------------
#
# Step 3
# Create a custom sbatch file for this run that uses our nodes and database
#
# -----------------------------------------------------------------------------
sbatch="""#!/bin/bash
#SBATCH -A mpcs56430
#SBATCH --output=%%A-%%j-%%a.out
#SBATCH --error=%%A-%%j-%%a.err
#SBATCH --job-name=custom_array_job
#SBATCH --ntasks=1
#SBATCH --partition=caslake
#SBATCH --array=0-%s

echo "> Custom array job - This file is generated at runtime"
date
hostname
pwd

echo "> SLURM VARIABLES"
echo ">  ArrayJob: $SLURM_ARRAY_JOB_ID JobId: $SLURM_JOB_ID TaskId: $SLURM_ARRAY_TASK_ID"
echo ">"
echo "> Run you script here with a database chunk: script.py temp_$SLURM_ARRAY_TASK_ID.db"

sleep 15

date
""" % (chunks)

# Write the sbatch string to a file
with open(GENERATED_SBATCH, "w") as outfile:
    outfile.write(sbatch)

# -----------------------------------------------------------------------------
# Step 4
# Submit the file using sbatch and collect the job id from the output
# -----------------------------------------------------------------------------
out  = subprocess.run(['sbatch', GENERATED_SBATCH], stdout=subprocess.PIPE, universal_newlines=True)
job_id = out.stdout.strip("Submitted batch job ")
job_id = job_id.strip()
print("Main Job: " + job_id)

# -----------------------------------------------------------------------------
# Step 5
# Create a sbatch script to collect all the ouput and cleanup to a folder
# -----------------------------------------------------------------------------
workspace_folder = job_id + "-workspace"

# Create a sbatch file for a "cleanup" job that will move all the output files
sbatch="""#!/bin/bash
#SBATCH -A mpcs56430
#SBATCH --output=%%j-cleanup.out
#SBATCH --error=%%j-cleanup.err
#SBATCH --job-name=custom_array_job_cleanup
#SBATCH --ntasks=1
#SBATCH --partition=caslake
#SBATCH --dependency=afterok:%s

date
hostname
pwd

echo "Cleanup"
sleep 5
mkdir %s
mv %s-*out %s/
mv %s-*err %s/
mv %s %s/
mv %s_*.db %s/
cp %s %s/
cp %s %s/

date
""" % (job_id, \
    workspace_folder, \
    job_id, workspace_folder, \
    job_id, workspace_folder, \
    GENERATED_SBATCH, workspace_folder, \
    DATABASE_PREFIX, workspace_folder, \
    DATABASE, workspace_folder, \
    __file__, workspace_folder)

# Write it to a file
sbatch_file = "cleanup.%s.sbatch" % job_id
with open(sbatch_file, "w") as outfile:
    outfile.write(sbatch)

# -----------------------------------------------------------------------------
# Step 6
# Run as a dependency job
# -----------------------------------------------------------------------------
out  = subprocess.run(['sbatch', sbatch_file], stdout=subprocess.PIPE, universal_newlines=True)
#print(out)
job_id = out.stdout.strip("Submitted batch job ")
job_id = job_id.strip()
print("Cleanup: %s" % job_id)

