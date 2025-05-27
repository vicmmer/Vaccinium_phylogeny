#!/bin/bash
echo "Starting pipeline: $(date)"
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
# STEP 3: Trim poorly aligned regions with TrimAL
# Uses automated heuristic to clean up messy sites
# -----------------------------------------------
echo "Step 3: Trimming alignment with TrimAL"
trimal -in $ALN_FILE -out $TRIMMED_ALN -automated1 > trimal_log.txt 2>&1
echo "Step 3: Building tree with IQ-TREE"
iqtree2 -s $ALN_FILE -m MFP -B 1000 --prefix $TREE_PREFIX

# -----------------------------------------------
# STEP 4: Build a Maximum Likelihood tree with IQ-TREE
# ModelFinder Plus chooses best model; 1000 ultrafast bootstraps
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
echo "✅ Done! Outputs:"
echo " - $TRIMMED_ALN (trimmed alignment)"
echo " - ${TREE_PREFIX}.treefile (Newick tree for iTOL or ggtree)"
echo " - ${TREE_PREFIX}.iqtree (model info, tree length, etc.)"
echo " - ${TREE_PREFIX}.log (run log)"
echo " - ${TREE_PREFIX}.ufboot (bootstrap replicates)"

