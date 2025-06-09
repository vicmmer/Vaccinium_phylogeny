#!/bin/bash
echo "Starting pipeline: $(date)"

# This assumes cp_tree_env contains:
# - mafft
# - trimal
# - iqtree2
source /home/vmartinez/miniconda3/etc/profile.d/conda.sh
conda activate cp_tree_env

# Output file names
ALN_FILE="aligned_plastomes.fasta"
TRIMMED_ALN="aligned_plastomes_trimmed.fasta"
TREE_PREFIX="vaccinium_cp_tree"

# -----------------------------------------------
# STEP 1: Combine all FASTA files into one file
# Assuming I already renamed them and they’re all
# in this folder.
# -----------------------------------------------
echo "Step 1: Combining FASTAs"
cat vaccinium_data/*.fasta > all_plastomes.fasta

# -----------------------------------------------
# STEP 2: Align with MAFFT
# --auto = let it figure itself out
# --thread 20 = speed things up on the cluster
# This will take a few mins depending on # of samples
# -----------------------------------------------
echo "Step 2: Aligning with MAFFT"
mafft --thread 20 --auto all_plastomes.fasta > $ALN_FILE 2> mafft_log.txt

# -----------------------------------------------
# STEP 3: Trim poorly aligned regions with TrimAL
# Uses automated heuristic to clean up messy sites
# like indels, low-confidence alignment blocks, etc.
# Avoids including noise in tree-building
# -----------------------------------------------
echo "Step 3: Trimming alignment with TrimAL"
trimal -in $ALN_FILE -out $TRIMMED_ALN -automated1 > trimal_log.txt 2>&1

# -----------------------------------------------
# STEP 4: Build a Maximum Likelihood tree with IQ-TREE
# ModelFinder Plus chooses best model
# 1000 ultrafast bootstraps is standard
# Based on the TRIMMED alignment!
# -----------------------------------------------
echo "Step 4: Building tree with IQ-TREE"
iqtree2 -s $TRIMMED_ALN -m MFP -B 1000 --prefix $TREE_PREFIX > iqtree_log.txt 2>&1

# -----------------------------------------------
# DONE! Results:
# - .treefile = Newick tree for iTOL or ggtree
# - .iqtree = model info, tree length, etc
# - .log = run log if I need to troubleshoot
# - .ufboot = bootstrap replicates
# -----------------------------------------------
echo "Pipeline complete at $(date)"
echo "Done! Outputs:"
echo " - $TRIMMED_ALN (trimmed alignment)"
echo " - ${TREE_PREFIX}.treefile (Newick tree for iTOL or ggtree)"
echo " - ${TREE_PREFIX}.iqtree (model info, tree length, etc.)"
echo " - ${TREE_PREFIX}.log (run log)"
echo " - ${TREE_PREFIX}.ufboot (bootstrap replicates)"
