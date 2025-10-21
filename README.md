# RCC-Utilities
Useful scripts and examples for The University of Chicago's RCC resource (https://rcc.uchicago.edu). 

## Files and Directories
* `.bashrc` A starter .bashrc file to put in your shell so that you don't accidentally `rm *`

* `machine_info.py` A pythongn script to identify cpus, cores, and threads.

* `monkey_shakespear.py` A python script to randomly generate Shakespear style sentences.

* `sample_data/` A collection of FASTA files for examples.

* `blast` A benchmarking demonstration using BLASTp for sequence alignment. _Note: This has not been updated for Midway3._

## Sample SLURM Jobs
#### `1_single_node_job/` 
Submits a single job to a single node. Noteably it does not use `srun`, as it isn't needed. 

#### `2_hello_world/` 
Submits a job to print "Hellow World" from 6 different notes. The nodes also report their `hostname`.

#### `3_multi_node_job/` 
Submits a job to 6 nodes that each generate a monkey shakespear sentence. The results are all collected in a single file.

#### `4_array_job/` 
Submits a job that uses the sbatch ARRAY parameter to pass an index 0-10 to each job. 

#### `5_fragment_array_job/` 
A complex job that is drive by a Python script tha performs the following tasks:
1. Load in database file that is going to be split into equal chunks
2. Create a custom `generated.sbatch` file for this run that uses our nodes and chunked database
3. Submit the file using sbatch and collect the `job id` from the output
4. Create a `cleanup.sbatch` script to collect all the ouput and cleanup all the intermediary files to a folder
5. Submit `clean.sbatch` as a dependency jbos

#### `6_dependency_workflows/`
An exemple bash and python script showing how to create dependency jobs that require one job to finish before another starts.

#### `7_multiprocessing/`
A hybrid workflow that submits jobs to each node. On the node the script uses python multiprocessing.
