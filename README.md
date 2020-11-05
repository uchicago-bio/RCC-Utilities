# Updated: May 1, 2020

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
