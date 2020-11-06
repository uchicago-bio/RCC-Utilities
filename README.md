# RCC-Utilities
Useful scripts and examples for The University of Chicago's RCC resource (https://rcc.uchicago.edu). 

# Files and Directories
* `.bashrc` file
  - A starter .bashrc file to put in your shell so that you don't accidentally rm *
* array_job/
  - Run SLURM array jobs against the refseq database
* fragment_array_job
  - A single Python script to fragment, run array job, and collate a BLASTp job
* mpcs56420.yml
  - Conda .yml file to install all the modules necessary for the course (and then some)
  - Create environment: `conda env create --file mpcs56420.yml`
  - [Conda Cheat Sheet](https://docs.conda.io/projects/conda/en/latest/_downloads/843d9e0198f2a193a3484886fa28163c/conda-cheatsheet.pdf)
* multiprocessing/
  - Python multiprocessing job
* sample_data
  - Fasta files for examples
* single_node_job
  - Run blast on a single node


# Create a PDBaa BLAST database (small database)
```
conda install -c bioconda blast 
wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/pdbaa.gz
gunzip pdbaa.gz
makeblastdb -in pdbaa -input_type fasta -dbtype prot -out pdbaa
```

# Creating NR and Refseq BLAST db (large database)
```
# NR
`wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz`

# Refseq (https://www.biostars.org/p/130274/)
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/complete/complete.*.protein.faa.gz
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/complete/complete.nonredundant_protein.*.protein.faa.gz

# Unzip and renumber sequentially
gunzip *gz
ls -v | cat -n | while read n f; do mv -n "$f" "refseq.$n"; done 
ls refseq.* | awk '{print "makeblastdb -in "$1" -input_type fasta -dbtype prot -out "$1}' | sh

# Create a blast compatible db
# makeblastdb -in pdbaa -input_type fasta -dbtype prot -out blast_pdb
ls nr.* | awk '{print "makeblastdb -in "$1" -input_type fasta -dbtype prot -out "$1}' | sh

# Run a blast job
blastp -query protein1.fasta -db /project2/abinkowski/db/blast_pdb -out test3
```

# Split a FASTA database
conda install -c bioconda blast
pyfasta split -n 6 swissprot 


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


