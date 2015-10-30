#!/bin/env python                                                                                                                                                                                      
################################################################################                                                                                                                       
## SLURM variables                                                                                                                                                                                     
################################################################################                                                                                                                       
#SBATCH --job-name=multiprocess                                                                                                                                                                        
#SBATCH --output=multiprocess_%j.out                                                                                                                                                                   

## Sandy bridge has 16 cores per node, so we could run 16 processes                                                                                                                                    
#SBATCH --partition=sandyb                                                                                                                                                                             
#SBATCH --nodes=1                                                                                                                                                                                      
#SBATCH --exclusive                                                                                                                                                                                    

################################################################################                                                                                                                       
## Import the python libraries we will be using                                                                                                                                                        
################################################################################                                                                                                                       
import multiprocessing
import sys
import os
import time
import platform
import random

# necessary to add cwd to path when script run by slurm (since it executes a copy)                                                                                                                     
sys.path.append(os.getcwd())

################################################################################                                                                                                                       
# For debugging and profiling, get number of cpus available; this should match                                                                                                                         
# 16 for sandbridge                                                                                                                                                                                    
################################################################################                                                                                                                       
nodes = int(os.environ["SLURM_NNODES"])
cpus = int(os.environ["SLURM_JOB_CPUS_PER_NODE"])

SLURM_NPROCS= nodes * cpus

##################################################################                                                                                                                                     
## This is the function that will be run on each node.  The                                                                                                                                            
## the parameter is what is being passed in the array from `.map`.                                                                                                                                     
## You should substitute you sequence alignment function here and                                                                                                                                      
## use the paramter however best fits your application design.                                                                                                                                         
##################################################################                                                                                                                                     
def process_worker(database):
    # Log out the process                                                                                                                                                                              
    print multiprocessing.current_process()

    # Pretend there is something happending that takes a random                                                                                                                                        
    # amount of time between 5 and 120 seconds                                                                                                                                                         
    time.sleep(random.randint(5,120))

    # Write output to file                                                                                                                                                                             
    outfile="output_%dx%d_%s.txt" % (nodes,cpus,database)
    f1=open(outfile, 'w+')
    f1.write('This is a test using the passed number %s on %s.\n' % (database,platform.node()))
    f1.close()


##################################################################                                                                                                                                     
## Main                                                                                                                                                                                                
##################################################################                                                                                                                                     
print("Number of Processes: %d" % SLURM_NPROCS)
start = time.time()
print("Start time: %s" % start)

# Set the number of processes to the number available to us; this                                                                                                                                      
# isn't necessarily the best performing option.  You should test                                                                                                                                       
# your application to determine this                                                                                                                                                                   
pool = multiprocessing.Pool(processes=SLURM_NPROCS)

# The array of parameters that will be passed to your process worker                                                                                                                                   
database_chunks =  [format(x,'02d') for x in range(0,100)]

# Distribute the jobs to workers                                                                                                                                                                       
pool.map(process_worker,database_chunks)

## More logging                                                                                                                                                                                        
print "Run time: %f" % (time.time() - start)


