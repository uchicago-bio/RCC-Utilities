# Running BLAST at the RCC


# Download BLAST
----------------------------------------------------------------
```
VERSION=ncbi-blast-2.17.0+-x64-linux.tar.gz

wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/$VERSION
tar -xzvf $VERSION
```

Update your `$PATH` so that seen by compute nodes. You could also just address the full executable path in your scripts.

```
VERSION=ncbi-blast-2.17.0+
export PATH=~/$VERSION/bin:$PATH
```

<br/><br/>

# Data
----------------------------------------------------------------
* Fasta files for the following examples are located in
  - `data/`

* Locations
  - /home/<cnetid> - Your user home directory
  - /scratch/midway3/<cnetid> - Large space for temporary storage
  - /project/mpcs56430 - Class project directory that we all have permissions for

* Sequence Databases (for reference):
  - /project/mpcs56430/bioinformatics/pdbaa
  - /project/mpcs56430/bioinformatics/pdbaa-chunk
  - /project/mpcs56430/bioinformatics/nr 


<br/><br/>

# Create PDBaa BLAST database (small database)
----------------------------------------------------------------

Download the PDB fasta data and generate a database that can be
used with blast.

```
# Download the database
wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/pdbaa.gz
gunzip pdbaa.gz

# Make the database
makeblastdb -in pdbaa -input_type fasta -dbtype prot -out pdbaa
```

<br/><br/>

# Run BLAST job on the Login Node
----------------------------------------------------------------

Use `protein1.fasta` as the query on the login node. Only do this for testing.
Your account will be suspended if you do too much work on the login node.

```
CNET_ID=
VERSION=ncbi-blast-2.17.0+
BLAST_PATH=/home/$CNET_ID/$VERSION/bin
QUERY=/home/$CNET_ID/RCC-Utilities/blast/data/protein1.fasta
DATABASE=/project/mpcs56430/bioinformatics/pdbaa/pdbaa

$BLAST_PATH/blastp -query $QUERY \
       -db $DATABASE \
       -out test.out
```

# Run BLAST job on Node as Interactive Job
----------------------------------------------------------------

Start an interactive session.
```
sinteractive -A mpcs56430
```

While you are on a worker node, test that you can read/write 
to `/scratch` and `/project/mpcs56430`. Work you do on nodes
should be using these directories.

```
# Test if you can read/write
touch  /scratch/midway3/<cnetid>/test.txt
touch /project/mpcs56430/test.txt
```

Run a BLAST job:
```
CNET_ID=?
VERSION=ncbi-blast-2.17.0+
BLAST_PATH=/home/$CNET_ID/$VERSION/bin
QUERY=/home/$CNET_ID/RCC-Utilities/blast/data/protein1.fasta
DATABASE=/project/mpcs56430/bioinformatics/pdbaa/pdbaa

$BLAST_PATH/blastp -query $QUERY -db $DATABASE -out /scratch/midway3/$CNET_ID/test_sinteractive.out
```

# Creating Large BLAST databases (NR and Refseq)
----------------------------------------------------------------
> This is for educational purposes only, you do not need to recreate these.
> The NCBI database is ~125G and will eat up your quota (and take a really long time to finish)

## NR database
```
wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz
gunzip *gz

# Number sequentially and create a blast db
ls -v | cat -n | while read n f; do mv -n "$f" "nr.$n"; done 
ls nr.* | awk '{print "makeblastdb -in "$1" -input_type fasta -dbtype prot -out "$1}' | sh
```

## Refseq Database (https://www.biostars.org/p/130274/)
```
# wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/complete/complete.*.protein.faa.gz
# Non-redundant (smaller)
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/complete/complete.nonredundant_protein.*.protein.faa.gz


```

# Unzip
```
for y in {1..4}; do echo gunzip *protein."$y".protein.faa.gz \& ; for i in {0..9}; do echo gunzip *protein."$y$i"*.protein.faa.gz \& ; done; done 

```

# Number sequentially and create a blast db
```
#gunzip *gz
#ls -v | cat -n | while read n f; do mv -n "$f" "refseq.$n"; #done 
#ls refseq.* | awk '{print "makeblastdb -in "$1" -input_type #fasta -dbtype prot -out "$1}' | sh
```

# Makedb
Logged into `sinteractive` job.
```
awk '{print "~/ncbi-blast-2.15.0+/bin/makeblastdb  -in "$1" -input_type fasta -dbtype prot -out "substr($1,1,length($1)-4)}'; done


ls complete.nonredundant_protein.1*.faa | awk '{print "~/ncbi-blast-2.15.0+/bin/makeblastdb  -in "$1" -input_type fasta -dbtype prot -out "substr($1,1,length($1)-4)}' | sh &
ls complete.nonredundant_protein.2*.faa | awk '{print "~/ncbi-blast-2.15.0+/bin/makeblastdb  -in "$1" -input_type fasta -dbtype prot -out "substr($1,1,length($1)-4)}' | sh &
ls complete.nonredundant_protein.3*.faa | awk '{print "~/ncbi-blast-2.15.0+/bin/makeblastdb  -in "$1" -input_type fasta -dbtype prot -out "substr($1,1,length($1)-4)}' | sh &
ls complete.nonredundant_protein.4*.faa | awk '{print "~/ncbi-blast-2.15.0+/bin/makeblastdb  -in "$1" -input_type fasta -dbtype prot -out "substr($1,1,length($1)-4)}' | sh &

ls complete.nonredundant_protein.5*.faa | awk '{print "~/ncbi-blast-2.15.0+/bin/makeblastdb  -in "$1" -input_type fasta -dbtype prot -out "substr($1,1,length($1)-4)}' | sh &
ls complete.nonredundant_protein.6*.faa | awk '{print "~/ncbi-blast-2.15.0+/bin/makeblastdb  -in "$1" -input_type fasta -dbtype prot -out "substr($1,1,length($1)-4)}' | sh &
ls complete.nonredundant_protein.7*.faa | awk '{print "~/ncbi-blast-2.15.0+/bin/makeblastdb  -in "$1" -input_type fasta -dbtype prot -out "substr($1,1,length($1)-4)}' | sh &
ls complete.nonredundant_protein.8*.faa | awk '{print "~/ncbi-blast-2.15.0+/bin/makeblastdb  -in "$1" -input_type fasta -dbtype prot -out "substr($1,1,length($1)-4)}' | sh &
ls complete.nonredundant_protein.9*.faa | awk '{print "~/ncbi-blast-2.15.0+/bin/makeblastdb  -in "$1" -input_type fasta -dbtype prot -out "substr($1,1,length($1)-4)}' | sh &

```


Run a blast job on a portion of the database
```
CNET_ID=abinkowski
BLAST_PATH=/home/$CNET_ID/ncbi-blast-2.17.0+/bin
QUERY=/home/$CNET_ID/RCC-Utilities/blast/data/protein1.fasta
DATABASE=/project/mpcs56430/bioinformatics/XXXXXnr|refseq

$BLAST_PATH/blastp -query $QUERY -db $DATABASE -out /scratch/midway3/$CNET_ID/test_bigdb.out

```

# Split a FASTA database into Chunks
----------------------------------------------------------------

Useful command to split up any FASTA format database into multiple files.

```
cd /project/mpcs56430/bioinformatics/pdbaa-chunk
# Split into 6 equal chunks
pyfasta split -n 6 pdbaa-chunk 
```

## Create a blast db for each chunk

```
ls pdbaa-chunk.* | awk '{print "makeblastdb -in "$1" -input_type fasta -dbtype prot -out "$1}'  | sh
```

## Test a chunked database
```
CNET_ID=abinkowski
BLAST_PATH=/home/$CNET_ID/ncbi-blast-2.17.0+/bin
QUERY=/home/$CNET_ID/RCC-Utilities/blast/data/protein1.fasta
DATABASE=/project/mpcs56430/bioinformatics/pdbaa-chunk/pdbaa-chunk.4

$BLAST_PATH/blastp -query $QUERY \
       -db $DATABASE \
       -num_threads 1 \
       -out /scratch/midway3/$CNET_ID/test_chunk4.out
```

## Run each chunk as a job.
```
cd /home/abinkowski/RCC-Utilities/blast
sbatch array_pdb.sbatch
```

# Benchmark Threads
----------------------------------------------------------------

Using an `sinteractive` job maually.
```
sinteractive -A mpcs56430

DATABASE="/project/mpcs56430/bioinformatics/pdbaa/pdbaa"
THREADS=1
OUTFILE="/scratch/midway3/abinkowski/${THREADS}.txt"

blastp -query spike.fasta -db $DATABASE -out $OUTFILE  -num_threads $THREADS
```

Run as slurm job:
```
DATABASE=/project/mpcs56430/bioinformatics/pdbaa
sbatch benchmark.sbatch 
```

<del>
# Multiprocessing
----------------------------------------------------------------

Find information about each node:

```
# Dump CPU info about a machine
lscpu
```

Run a slurm job to see what you are running on:
```
cd RCC-Utilities/multiprocessing
sbatch node-info.sbatch
```

A biolerplate for running multiprocesser jobs submitted via 
SLURM. This can be the foundation for any job you want to run
on mult-core machines. If you loop this with an sbatch array job
you will have multi-node, multi-core jobs!

```
sbatch multi.py 

```



# MPI Blast (Deprecated)
----------------------------------------------------------------

Check out this repositories [wiki](https://github.com/uchicago-bio/RCC-Utilities/wiki) for
instructions on running the scripts. RCC no longer mainains their 
version but you can install your own.

</del>
