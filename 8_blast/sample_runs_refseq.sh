#                                                                                                                     
# Database testing script for running BLAST with the refseq database
# on the RCC. This runs locally using the install blast module.                                                                                         
# The databases are in /project/mpcs56430/bioinformatics/.
#                                                                                                     

# Load the preinstalled RCC version of blast                                                                          
module load blast

# Get the username of person running the script                                                                       
USERNAME=$(whoami)

# Sample query in .fasta format                                                                                       
#QUERY=sample_queries/jurassic.fasta                                                                                  
QUERY=sample_queries/protein1.fasta


# Uncomment to try different databases                                                                                
#DATABASE=swissprot_100/swissprot.000.fasta                                                                           
#DATABASE=swissprot_100/swissprot.099.fasta                                                                           

#DATABASE=refseq/refseq.protein.fasta                                                                                 

# Refseq Chunks                                                                                                       
DATABASE=refseq/new/refseq_protein.26
DATABASE=refseq/new/refseq_protein.00
# Refseq (30G)                                                                                                        
DATABASE=refseq/refseq_protein


DATABASE_NAME=$(basename "$DATABASE")
COMMAND="blastp -query $QUERY -db $DATABASE -out sample_run.$USERNAME.$DATABASE_NAME.out"

# Print the command for debugging                                                                                     
echo $COMMAND

# Execute                                                                                                             
$COMMAND