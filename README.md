# RCC-Utilities
Useful scripts for The University of Chicago's RCC resource (https://rcc.uchicago.edu).  Check out this repositories [wiki](https://github.com/uchicago-bio/RCC-Utilities/wiki) for instructions on running the scripts.


### .bashrc
A starter .bashrc file to put in your shell so that you don't accidentally rm *

### chunked_database_blast.sbatch
Conduct a blast search against a chunked version of the `nr` database.  The database is located at `/projects/databases/blast` on RCC.

### single_node_blast.sbatch
Conduct a blast search on a single node using the `nr` database.





# Create a BLAST database
wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/pdbaa.gz
gunzip pdbaa.gz
makeblastdb -in pdbaa -input_type fasta -dbtype prot -out pdbaa

# Creating BLAST db

```
# Install blast
conda install -c bioconda blast

# Download a database from NCBI
wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/pdbaa.gz
wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz

# Unzip and renumber sequentially
gunzip *gz
ls -v | cat -n | while read n f; do mv -n "$f" "refseq.$n"; done 
ls refseq.* | awk '{print "makeblastdb -in "$1" -input_type fasta -dbtype prot -out "$1}' | sh

## Refseq
# https://www.biostars.org/p/130274/
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/complete/complete.*.protein.faa.gz
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/complete/complete.nonredundant_protein.*.protein.faa.gz

# Create a blast compatible db
makeblastdb -in pdbaa -input_type fasta -dbtype prot -out blast_pdb

# Run a blast job
blastp -query protein1.fasta -db /project2/abinkowski/db/blast_pdb -out test3

# Split
conda install -c bioconda blast
pyfasta split -n 6 swissprot 


# RCC Utilities and Demos

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
