#!/bin/bash
#SBATCH -A mpcs56430
#SBATCH --job-name=jpg2png            # Job name
#SBATCH --output=%j.%a.jpg2png.out
#SBATCH --error=%j.%a.jpg2png.err

#SBATCH --mail-type=ALL               # Mail events (NONE,BEGIN,END,FAIL,ALL)
#SBATCH --mail-user=abinkowski@uchicago.edu    # Where to send mail

#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --mem=1gb                     # Job memory request
#SBATCH --time=00:15:00               # Time limit hrs:min:sec

#SBATCH --array=0-9

# -----------------------------------------------------------------------------
# This will be run N number of times (array variable)
# -----------------------------------------------------------------------------
echo ">> Slurm Id:           "$SLURM_JOBID
echo ">> Array Task - Task : $SLURM_ARRAY_TASK_ID -- $SLURM_TASK_ID with id: $SLURM_JOBID"
echo ">> Tasks per node:     "$SLURM_TASKS_PER_NODE
echo ">> CPUS per task:      "$SLURM_CPUS_PER_TASK
echo -n ">> Date:            ";date
echo -n ">> Pwd:             ";pwd
echo -n ">> Hostname:        ";hostname
echo ">> Working On: $SLURM_ARRAY_TASK_ID $SLURM_TASK_ID"


# -----------------------------------------------------------------------------
IMAGES_DIR="/project2/mpcs56430/steganography/2022/jpg"
OUTPUT_DIR="/project2/mpcs56430/steganography/2022/png"
mkdir -p $OUTPUT_DIR

echo ">> Images Directory: $IMAGES_DIR"
echo ">> Output Directory: $OUTPUT_DIR"

# -----------------------------------------------------------------------------
# This job assumes that the there is a directory of images that are labeled
# *1*.jpg, *2.jpg
#
# Process the images by using the last digit of the file name ###1.jpg as the 
# variable changed for each $SLURM_ARRAY_TASK_ID
# -----------------------------------------------------------------------------

#magick mogrify -resize 16x12 -quality 100 -path ../new-thumbs *.jpg
#mogrify -format png -path pnpn  *9.jpg
# -----------------------------------------------------------------------------
# Process the images using imagemagik
# -----------------------------------------------------------------------------

# Add `time` to time how long the job runs
#time cp ${IMAGES_DIR}/*${SLURM_ARRAY_TASK_ID}.jpg ${OUTPUT_DIR}

time mogrify \
    -format png \
    -path $OUTPUT_DIR \
    $IMAGES_DIR/*${SLURM_ARRAY_TASK_ID}.jpg
