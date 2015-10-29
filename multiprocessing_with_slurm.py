#!/bin/env python                                                                              
#SBATCH --job-name=multiprocess                                                                
#SBATCH --output=multiprocess_%j.out                                                           
#SBATCH --nodes=1                                                                              
#SBATCH --exclusive                                                                            

import multiprocessing
import sys
import os
import time

# necessary to add cwd to path when script run by slurm (since it executes a copy)                                                          
sys.path.append(os.getcwd())

##################################################################
# get number of cpus available to job just for informational purposes                                                         
##################################################################
try:
    ncpus = int(os.environ["SLURM_JOB_CPUS_PER_NODE"])
except KeyError:
    ncpus = multiprocessing.cpu_count()

##################################################################
## Substitute you sequence alignment function here
##################################################################
def workOnNode(database):
    time.sleep(60) # Do something after arbitrary time
    f1=open(database, 'w+')
    f1.write('This is a test using database' + database)
    print multiprocessing.current_process()
    f1.close()


##################################################################
# Main
##################################################################
print("Number of CPUs: %d" % ncpus)
start = time.time()
# Change processes to what you want
pool = multiprocessing.Pool(processes=2)
pool.map(workOnNode, ["db1", "db2","db3","db4","db5","db6","db7","db8","db9","db10"])
print "Parallel time: %f" % (time.time() - start)




