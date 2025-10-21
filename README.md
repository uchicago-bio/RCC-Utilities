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







* single_node_job
  - Run blast on a single node
* multiprocessing/
  - Python multiprocessing job

# Working on the RCC
## Logging In
You need to have 2-factor authentication to sign in.
```
ssh cnetid@midway2.rcc.uchicago.edu

# Useful Commands 
accounts balance

# List files by size
du -mahd 1 
```

## Locations
* /home - You user home directory
* /scratch/midway2/ - Large space for temporary storage
* /project2/mpcs56420 - Class project directory that we all have permissions for

Sequence Databases (for reference)
- /project2/mpcs56420/db/pdbaa
- /project2/mpcs56420/db/swiss_prot 
- /project2/mpcs56420/db/nr 

## Setup Ananconda
Warning, the Anaconda on RCC is outdated, but still works.
```
module load python/anaconda-2019.03    

# May have to add this to your .bashrc
. /software/Anaconda3-5.1.0-el6-x86_64/etc/profile.d/conda.sh

# Create (if needed)
conda create --name mpcs56420

# Activate the env
conda activate mpcs56420
```




# Setup BLAST
Install BLAST (if needed)
```
conda install -c bioconda blast 
```

## Create PDBaa BLAST database (small database)
```
# Download the database
wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/pdbaa.gz
gunzip pdbaa.gz
# Make the database
makeblastdb -in pdbaa -input_type fasta -dbtype prot -out pdbaa
```

## Run BLAST job on the Login Node
Use `protein1.fasta` as the query on the login node. Only do this for testing. Your account will be suspended if you do too much work on the login node.
```
blastp -query protein1.fasta -db pdbaa -out test.out
```

## Run BLAST job on Node as Interactive Job
Start an interactive session.
```
sinteractive -A mpcs56420
```
Run the BLAST job.
```
blastp -query protein1.fasta -db pdbaa -out test.out
```
While you are on a worker node, test that you can read/write to `/scratch` and `/project2/mpcs56420`. Work you do on nodes should be using these directories.
```
touch  /scratch/midway2/cnetid/test.txt
touch /project2/mpcs56420/test.txt
```

## Creating NR and Refseq BLAST db (large database)
Download from NCBI.
```
# NR database
wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz

# Refseq Database (https://www.biostars.org/p/130274/)
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/complete/complete.*.protein.faa.gz
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/complete/complete.nonredundant_protein.*.protein.faa.gz
```

Unzip and renumber sequentially
```
gunzip *gz
ls -v | cat -n | while read n f; do mv -n "$f" "refseq.$n"; done 
ls refseq.* | awk '{print "makeblastdb -in "$1" -input_type fasta -dbtype prot -out "$1}' | sh
```

Create a blast compatible db
```
# makeblastdb -in pdbaa -input_type fasta -dbtype prot -out blast_pdb

ls nr.* | awk '{print "makeblastdb -in "$1" -input_type fasta -dbtype prot -out "$1}' | sh
```

Run a blast job
```
blastp -query protein1.fasta -db /project2/abinkowski/db/blast_pdb -out test3
```

## Split a FASTA database
Useful command to split up any FASTA format database into multiple files.
```
pyfasta split -n 6 swissprot 
```

# Sample Commands
```
# sinteractive
sinteractive -A mpcs56420
DATABASE="/project2/mpcs56420/db/pdbaa"
OUTFILE="/scratch/midway2/abinkowski/out.txt"
blastp -query spike.fasta -db $DATABASE -out $OUTFILE  -num_threads 1

# Single Node Sleep
sbatch sleep_test.sbatch 

# Single Node BLASTP 
cd RCC-Utilities/single_node_job
sbatch single-node-blastp-simple.sbatch 
more out.txt

# Single Node with 
sbatch single-node-blastp.sbatch testjob

# Multiprocessing
sbatch multi.py 

```

# MPI Blast (Deprecated)
Check out this repositories [wiki](https://github.com/uchicago-bio/RCC-Utilities/wiki) for instructions on running the scripts.



# Git Tips and Tricks
git config --global user.name "My Name @RCC"
git config --global user.email cnetid@uchicago.edu