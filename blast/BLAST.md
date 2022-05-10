# BLAST

## -------------------------------------------------------------
## Environment
## -------------------------------------------------------------

Create an environment using: `mpcs56420.yml`

* Conda .yml file to install all the modules necessary for the course (and then some)
  - [Conda Cheat Sheet](https://docs.conda.io/projects/conda/en/latest/_downloads/843d9e0198f2a193a3484886fa28163c/conda-cheatsheet.pdf)

* Create environment: `conda env create --file mpcs56420.yml`
* Update existing environment
  `conda activate mpcs56430`
  `conda env update --file mpcs56430.yml --prune`


## -------------------------------------------------------------
## Data
## -------------------------------------------------------------
* Fasta files for examples
  - `data/`

* Locations
  - /home - You user home directory
-  /scratch/midway2/ - Large space for temporary storage
* /project2/mpcs56430 - Class project directory that we all have permissions for

Sequence Databases (for reference)
- /project2/mpcs56430/bioinformatics/pdbaa
- /project2/mpcs56430/bioinformatics/swiss_prot 
- /project2/mpcs56430/bioinformatics/nr 


## Setup BLAST
> This is installed as part of the enviroment

* Install BLAST (if needed)
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
blastp -query data/protein1.fasta \
       -db /project2/mpcs56430/bioinformatics/pdbaa/pdbaa \
       -out test.out
```
## ------------------------------------------------------------------
##
## Run BLAST job on Node as Interactive Job
##
## ------------------------------------------------------------------
Start an interactive session.
```
sinteractive -A mpcs56430
```
Run the BLAST job.
```
blastp -query protein1.fasta -db pdbaa -out test.out
```
While you are on a worker node, test that you can read/write to `/scratch` and `/project2/mpcs56420`. Work you do on nodes should be using these directories.
```
touch  /scratch/midway2/<cnetid>/test.txt
touch /project2/mpcs56430/test.txt
```

## ------------------------------------------------------------------
##
## Creating NR and Refseq BLAST db (large database)
##
## ------------------------------------------------------------------
Download from NCBI.

```
# NR database
wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz
gunzip *gz
ls -v | cat -n | while read n f; do mv -n "$f" "refseq.$n"; done 
ls refseq.* | awk '{print "makeblastdb -in "$1" -input_type fasta -dbtype prot -out "$1}' | sh


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

## ------------------------------------------------------------------------
##
## Split a FASTA database
##
## ------------------------------------------------------------------------

Useful command to split up any FASTA format database into multiple files.

```
/project2/mpcs56430/bioinformatics/pdbaa-chunk
pyfasta split -n 6 pdbaa-chunk 
ls pdbaa-chunk.* | awk '{print "makeblastdb -in "$1" -input_type fasta -dbtype prot -out "$1}'  | sh

blastp -query ~/gh/RCC-Utilities/blast/data/protein1.fasta -db pdbaa-chunk.4 -out test

```

Run each chunk as a job.
```
cd /home/abinkowski/gh/RCC-Utilities/blast
sbatch array_pdb.sbatch
```



## ------------------------------------------------------------------------
##
## Benchmark
##
## ------------------------------------------------------------------------
# sinteractive
```
sinteractive -A mpcs56420

DATABASE="/project2/mpcs56430/bioinformatics/pdbaa/pdbaa"
THREADS=1
OUTFILE="/scratch/midway2/abinkowski/${THREADS}.txt"

blastp -query spike.fasta -db $DATABASE -out $OUTFILE  -num_threads $THREADS
```

Run as slurm job:
```
DATABASE=/project2/mpcs56430/bioinformatics/pdbaa
sbatch benchmark.sbatch 
```


## ------------------------------------------------------------------------
##
## Multiprocessing
##
## ------------------------------------------------------------------------

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
