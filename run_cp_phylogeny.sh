#!/bin/bash

# output file names
ALN_FILE="aligned_plastomes.fasta"
TREE_PREFIX="vaccinium_cp_tree"

# -----------------------------------------------
# STEP 1: Combine all FASTA files into one file
# Assuming I already renamed them and they’re all
# in this folder.
# -----------------------------------------------

echo "Step 1: Combining FASTAs"
cat *.fasta > all_plastomes.fasta

# -----------------------------------------------
# STEP 2: Align with MAFFT
# --auto = let it figure itself out
# This will take a few mins depending on # of samples
# -----------------------------------------------

echo "Step 2: Aligning with MAFFT"
#mafft --auto all_plastomes.fasta > $ALN_FILE  # taking forever, will try with more threads
mafft --thread 20 --auto all_plastomes.fasta > $ALN_FILE
# -----------------------------------------------
# STEP 3: Make a tree with IQ-TREE
# ML method (like the paper), automatic model selection
# 1000 ultrafast bootstraps is standard
# This takes a bit of time
# -----------------------------------------------

echo "Step 3: Building tree with IQ-TREE"
iqtree2 -s $ALN_FILE -m MFP -B 1000 --prefix $TREE_PREFIX

# -----------------------------------------------
# DONE! Results:
# - .treefile = Newick tree for iTOL or ggtree
# - .iqtree = model info, tree length, etc
# - .log = run log if I need to troubleshoot
# - .ufboot = bootstrap replicates
# -----------------------------------------------

echo "Done! Outputs:"
echo " - $ALN_FILE (alignment)"
echo " - ${TREE_PREFIX}.treefile (upload this to iTOL!)"
echo " - ${TREE_PREFIX}.iqtree (model info)"
echo " - ${TREE_PREFIX}.log (log, obv)"
echo " - ${TREE_PREFIX}.ufboot (bootstraps)"
