#!/usr/local/bin/python

import sys
import os
import time
import platform
import random
import subprocess


def submit(job_name: str, command: str, command2: str) -> int:
    '''
    Submit a job to slurm
    
        Parameters:
            job name: a unique string to identify the job
            command: the first command after sbatch
            command2: the second command after sbatch; it can be an empty string
        
        Returns:
            An integer represting the slurm job id
    '''
    out  = subprocess.run(["sbatch", command, command2], stdout=subprocess.PIPE, universal_newlines=True)
    print(f"Submitting jobTerminal Output: {out}")
    if out.returncode == 0:
        job_id = out.stdout.strip("Submitted batch job ")
        job_id = job_id.strip()
        print(f"SUBMITTED \tJob Name: {job_name} \tJobId:{job_id}")
        return job_id
    else: 
        raise ValueError(f"Problem submitting {job_name}")

#
# Submit the jobs
#

# Keep a list of all jobs so we can delete if there is a problem
jobs = []
try:
    job_1 = submit("job 1", "job_1.sbatch","")
    jobs.append(job_1)

    job_2 = submit("job 2", f"--depend=afterany:{job_1}", "job_2.sbatch")
    jobs.append(job_2)

    job_3 = submit("job 3", f"--depend=afterok:{job_2}", "job_3.sbatch")
    jobs.append(job_3)
    print(f"SUBMITTED JOBS: {jobs}")

except ValueError as err:
    print(f"Error: {err}")

    # Remove all the previously submitted jobs from squeue
    for job in jobs:
        print(f"CANCEL JOB: {job}")
        subprocess.run(["scancel", job])


# Print out the squeue
user = os.getlogin()
queue = subprocess.run(["squeue", "-u", user], stdout=subprocess.PIPE, universal_newlines=True)
print("\n\n")
print(queue.stdout)
