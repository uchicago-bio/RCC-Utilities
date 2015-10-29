#!/bin/env python                                                                              
################################################################################
## SLURM variables
################################################################################
#SBATCH --job-name=multiprocess                                                                
#SBATCH --output=multiprocess_%j.out                                                           
## Sandy bridge has 16 cores per node, so we could run 16 processes
#SBATCH --partition=sandyb
#SBATCH --nodes=1                                                                              
## Tell SLURM we want the entire node to ourselves
#SBATCH --exclusive                                                                            

################################################################################
## Import the python libraries we will be using
################################################################################
import multiprocessing
import sys
import os
import time
import platform

# necessary to add cwd to path when script run by slurm (since it executes a copy)                                                          
sys.path.append(os.getcwd())


################################################################################
# For debugging and profiling, get number of cpus available; this should match
# 16 for sandbridge
################################################################################
try:
    ncpus = int(os.environ["SLURM_JOB_CPUS_PER_NODE"])
except KeyError:
    ncpus = multiprocessing.cpu_count()

##################################################################
## This is the function that will be run on each node.  The
## the parameter is what is being passed in the array from `.map`.
## You should substitute you sequence alignment function here and
## use the paramter however best fits your application design.
##################################################################
def process_worker(database):
    # Log out the process
    print multiprocessing.current_process()
    
    # Pretend there is something happending that takes 60 secsonds
    time.sleep(60) 
    
    # Write output to file
    outfile="output_%s.txt" % database
    f1=open(database, 'w+')
    f1.write('This is a test using database %s on %s.' % (database,platform.node()))
    f1.close()


##################################################################
## Main
##################################################################
print("Number of CPUs: %d" % ncpus)
start = time.time()
print("Start time: %s" % start)

# Set the number of processes to the number available to us; this
# isn't necessarily the best performing option.  You should test 
# your application to determine this
pool = multiprocessing.Pool(processes=ncpus)

# The array of parameters that will be passed to your process worker
database_chunks =  ["db1", "db2","db3","db4","db5","db6","db7","db8","db9","db10","db11","db12","db13","db14","db15","db16"]
# Distribute the jobs to workers
pool.map(process_worker,database_chunks)

## More logging
print "Run time: %f" % (time.time() - start)




