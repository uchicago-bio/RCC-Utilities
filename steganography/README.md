# A List of Images Data Sets
https://imerit.net/blog/22-free-image-datasets-for-computer-vision-all-pbm/

##############################################################################
# 
# Download Image Data Sets
#
##############################################################################

# Dogs
wget http://vision.stanford.edu/aditya86/ImageNetDogs/images.tar
tar -xvf images.tar 
mkdir 2022
mv Images/*/* dogs/

# Download Flowers
wget https://www.robots.ox.ac.uk/~vgg/data/flowers/102/102flowers.tgz
mv jpg/ flowers

##############################################################################
#
# Cleanup Data
#
##############################################################################

# Copy images to directory
mkdir 2022
cp dogs/* 2022/
cp flowers/* 2022/

##############################################################################
#
# Rename all the files sequentially using a `sinteractive` job
#
##############################################################################

sinteractive -A mpcs56420
cd 2022/

# Save a copy x.original.jpg (in case we mess up)
mkdir originals
cp * originals

# Rename sequentially
ls -v | cat -n | while read n f; do mv -n "$f" "$n.jpg"; done 
mkdir originals
mv *.original.jpg originals
