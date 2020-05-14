import sys
import os
import time
import platform
import random
import subprocess

# How many nodes are we going to distribute the
# work to?
nodes = 10

# Load in database
with open('/project2/mpcs56420/db/swissprot.fasta') as f:
    lines = f.readlines()
# print(lines)

# How many lines should be in each chunk
chunks = round(len(lines) / nodes)

# Split database into equal sized chunks
chunked_db = [lines[i:i + chunks] for i in range(0, len(lines), chunks)]
#print(chunked_db)

# Write out each as a temporary database
for i in range(0,len(chunked_db)):
    filename = "temp_%s" % i
    with open(filename, "w") as outfile:
        outfile.write("".join(chunked_db[i]))

# Create a custom sbatch file for this run
sbatch="""#!/bin/bash
#SBATCH --output=%%A-%%j-%%a.out
#SBATCH --error=%%A-%%j-%%a.err
#SBATCH --job-name=custom_array_job
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --partition=broadwl

#SBATCH --array=0-%s

#SBATCH --job-name=serial_job_test    # Job name
#SBATCH --mail-type=ALL               # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=bbao@uchicago.edu    # Where to send mail

#SBATCH --cpus-per-task=1             # Number of threads per task
#SBATCH --mem=20gb                     # Job memory request
#SBATCH --time=20:00:00               # Time limit hrs:min:sec
#SBATCH --output=%j.serial_job.out
#SBATCH --error=%j.serial_job.err

date
hostname
pwd

echo "$SLURM_ARRAY_JOB_ID $SLURM_JOB_ID $SLURM_ARRAY_TASK_ID"
echo "Run you script with my_custom_script.py temp_%s"
# Here we would run our program with the database temp_??


###########################################################################################
# Create an output directory; blastplus creates many different files
# that you will want to keep track of per job
# Example of writing to a different path:
#                         WORKDIR=/scratch/midway/$USER/$SLURM_JOBID
#
# For convienence, we have an extra argument that we can use to
# differentiate runs ($1 means the first argument after the executable name
#
# Note: In practice you should write data to /scratch and then move the data later
###########################################################################################
JOBNAME=$1
WORKDIR=$SLURM_JOBID"-"$JOBNAME
mkdir -p $WORKDIR

################################################################################
# Copy all of the input files to the directory. This way you can recreate the
# run again.
################################################################################
`cp $0 $WORKDIR`
`cp $QUERY $WORKDIR`


################################################################################
# We are interested in tracking how long these take to run.  We also
# want to track how long the job was in the queue.  Slurm keeps an
# output and error file for each job.  All the standard output and
# error will be directed there.
################################################################################
echo "Starting Job id: $SLURM_JOBID"
date
pwd; hostname;

################################################################################
# BLAST arguments
################################################################################
# Use `pdb` database.  Look in the directory and see how BLAST structures the
# files.  They chuck them into groups.
DB="/project2/mpcs56420/db/swissprot.fasta"
QUERY="spike.fasta"
BLAST_RESULTS="output.txt"
ALIGNMENT="global"
SCORINGMATRIX="PAM250"
G=3

# Run 9.py (use time in front to track runtime)
time python 9.py --queryfile spike.fasta \
     --databasefile $DB \
     --scoringmatrix $SCORINGMATRIX \
     --alignment $ALIGNMENT \
     --gappenalty $G \
     --output $BLAST_RESULTS \
   
################################################################################
# Dump the Finished time to stdout so we know we are done
################################################################################
echo "Done with processing..."
date


################################################################################
# All the files are written to current directory.  Copy all
# the output files that were created to our job directory
################################################################################
`mv $SLURM_JOBID.out $SLURM_JOBID.err $WORKDIR`
`mv $BLAST_RESULTS $WORKDIR/$BLAST_RESULTS`

echo "All files were moved..."
echo "Script completed"


sleep 5

date
""" % (chunks,i)

# Write the sbatch string to a file
sbatch_file = "partitiondb_custom_array.sbatch"
with open(sbatch_file, "w") as outfile:
    outfile.write(sbatch)

# Submit the file using sbatch and collect the 
# job id from the output
out  = subprocess.run(['sbatch', '-A', 'mpcs56420', sbatch_file], capture_output=True, text=True)
job_id = out.stdout.strip("Submitted batch job ")
job_id = job_id.strip()
print("Main Job: " + job_id)

# Create a folder to hold all our files prefixed  with the job id
workspace_folder = job_id + "-workspace"

# Create a sbatch file for a "cleanup" job that will move all the output files
sbatch="""#!/bin/bash
#SBATCH --output=%%j-cleanup.out
#SBATCH --error=%%j-cleanup.err
#SBATCH --job-name=custom_array_job_cleanup
#SBATCH --ntasks=1
#SBATCH --partition=broadwl
#SBATCH --dependency=afterok:%s

date
hostname
pwd

echo "Cleanup"
sleep 5
mkdir %s
mv %s-* %s/
mv custom_array.sbatch temp_* %s/


date
""" % (job_id, workspace_folder, job_id, workspace_folder, workspace_folder)

# Write it to a file
sbatch_file = "cleanup.%s.sbatch" % job_id
with open(sbatch_file, "w") as outfile:
    outfile.write(sbatch)

# Submit it
out  = subprocess.run(['sbatch', '-A', 'mpcs56420', sbatch_file], capture_output=True, text=True)
#print(out)
job_id = out.stdout.strip("Submitted batch job ")
job_id = job_id.strip()
print("Cleanup: %s" % job_id)

