#! /bin/bash

# The standard output after a `sbatch` submission is:
#       Submitted batch job XXXXXXXXX
#
# Pipe the `awk '{print $4}'` command to extract the fourth 
# space seperated string


# Submit first job with no dependencies
jid1=$(sbatch job_1.sbatch | awk '{print $4}')

# Submit second job dependent on the first
jid2=$(sbatch  --dependency=afterok:$jid1 job_2.sbatch | awk '{print $4}')

# Submit third job dependent on the second
jid3=$(sbatch  --dependency=afterany:$jid2 job_3.sbatch | awk '{print $4}')

# Show dependencies in squeue
squeue -u $USER -o "%.8A %.4C %.10m %.20E"