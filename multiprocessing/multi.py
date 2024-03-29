#!/bin/env python

## SLURM variables

#SBATCH --account=mpcs56430
#SBATCH --job-name=multiprocess
#SBATCH --output=%j_multiprocess.out
#SBATCH --partition=broadwl

#SBATCH --cpus-per-task=4    # cores
#SBATCH --nodes=4            # number of nodes to run on       
#SBATCH --ntasks-per-node=4  # 
#SBATCH --ntasks=16          # total tasks to be launcedd

#SBATCH--exclusive
#SBATCH --time=00:15:00

import multiprocessing
import sys
import os
import time
import platform
import random
import socket

# necessary to add cwd to path when script run 
# by slurm (since it executes a copy)
sys.path.append(os.getcwd()) 

job_id = os.environ["SLURM_JOB_ID"]
nodes = int(os.environ["SLURM_NNODES"])
#cpus_per_node = int(os.environ["SLURM_JOB_CPUS_PER_NODE"])
tasks_per_node =  int(os.environ["SLURM_NTASKS_PER_NODE"])
cpus_per_task =  int(os.environ["SLURM_CPUS_PER_TASK"])
nprocs =  int(os.environ["SLURM_NPROCS"])

print("nodes = %d" % int(os.environ["SLURM_NNODES"]))
print("cpus_per_node = %s" % os.environ["SLURM_JOB_CPUS_PER_NODE"])
print("tasks_per_node = %d" %  int(os.environ["SLURM_NTASKS_PER_NODE"]))
print("cpus_per_task =  %d" % int(os.environ["SLURM_CPUS_PER_TASK"]))
print("nprocs =  %d" % int(os.environ["SLURM_NPROCS"]))

print(os.environ)

SLURM_NPROCS = nodes * cpus_per_task

## This is the function that will be run on each node.The
## the parameter is what is being passed in the array from `.map`. 
## You should substitute you sequence alignment function here and     
## use the paramter however best fits your application design.

def process_worker(database):
    # Log out the process                                                                                                                                                               
    print(multiprocessing.current_process())
    # Pretend there is something happending that takes a random amount of time between 5 and 120 seconds
    time.sleep(random.randint(5,120))

    # Write output to file
    outfile="%s_output_%dx%d_%s.txt" % (job_id,nodes,cpus_per_task,database)
    f1=open(outfile, 'w+')
    f1.write('This is a test using the passed number %s on %s %s.\n' % (database,platform.node(),socket.gethostname()))
    f1.close()


if __name__ == "__main__":
    print("Number of Processes: %d" % SLURM_NPROCS)
    start = time.time()
    print("Start time: %s" % start)

    # Set the number of processes to the number available to us; 
    # this isn't necessarily the best performing option.  You should 
    # test your application to determine this
    pool = multiprocessing.Pool(processes=SLURM_NPROCS)

    # The array of parameters that will be passed to your process worker.  
    # This creates array ["00","01"....]
    database_chunks =  [format(x,'02d') for x in range(0,10)]

    # Distribute the jobs to workers
    pool.map(process_worker,database_chunks)

    print("Run time: %f" % (time.time() - start))


