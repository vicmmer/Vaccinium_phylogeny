#!/bin/bash

# Make a directory to keep everything neat 
mkdir -p vaccinium_data
cd vaccinium_data

################################################################################
# Vaccinium: Northern Highbush Blueberry (NHB) aka 'Draper'
# This is the only sample from the Fahrenkrog et al. 2022 paper with raw WGS reads
# publicly available. The others just have GenBank assemblies.
#
# BioProject: PRJNA494180
# SRA Run: SRR7992602 — paired-end Illumina
################################################################################

#echo "Downloading V. corymbosum cv. Draper (NHB)"

# Grab the raw .sra file from NCBI's cloud server
#prefetch SRR7992602

# Convert .sra to gzipped FASTQ files, split into R1 and R2 (paired-end)
# Will generate: SRR7992602_1.fastq.gz and SRR7992602_2.fastq.gz
#fasterq-dump SRR7992602 --split-files --gzip
#Actually, maybe we will just download an available chloroplast genome instead of raw reads for this species so we have the same starting ground for all 

################################################################################
# GenBank assemblies from the same paper (no raw reads, but still useful)
# These are the cpDNA assemblies submitted by the authors
################################################################################

# Array of GenBank accession numbers for the plastomes used in the study
assemblies=(
  "OM791342"     # SHB - 'Arcadia' (southern highbush blueberry)
  "OM791343"     # RB - 'Ochlockonee' (rabbiteye blueberry)
  "BK061167"     # NHB - 'Draper' (same one we got raw reads for above)
  "OM791344"     # LB - 'Brunswick' (lowbush blueberry)
  "OM809159"     # BB - 'OU-L2' (bilberry)
  "MK715447.1"   # CB - 'Stevens' (cranberry, from a previous study)
)

# Pull down each GenBank cpDNA file
# These are just single .fasta sequences of the assembled chloroplast genome
for acc in "${assemblies[@]}"; do
  echo "Downloading GenBank assembly $acc..."
  esearch -db nucleotide -query "$acc" | efetch -format fasta > "${acc}.fasta"
done

echo "All downloads from paper complete"

echo "Downloading additional Vaccinium cpDNA genomes..."

extra_assemblies=(
  "MZ328079"     # V. corymbosum (NHB, different from Draper, complete cpDNA)
  "NC_042713.1"  # V. oldhamii
  "LC521968.1"   # V. uliginosum
  "LC521969.1"   # V. vitis-idaea
  "MW006668.1"   # V. japonicum
  "LC521967.1"   # V. bracteatum
)

for acc in "${extra_assemblies[@]}"; do
  echo "Downloading cpDNA for accession $acc..."
  esearch -db nucleotide -query "$acc" | efetch -format fasta > "${acc}.fasta"
done

echo "All extra cpDNA genomes downloaded!"

echo "Renaming all cpDNA FASTA files..."

# From Fahrenkrog et al. 2022
mv OM791342.fasta   Vaccinium_corymbosum_SHB_Arcadia.fasta
mv OM791343.fasta   Vaccinium_virgatum_RB_Ochlockonee.fasta
mv OM791344.fasta   Vaccinium_angustifolium_LB_Brunswick.fasta
mv OM809159.fasta   Vaccinium_myrtillus_BB_OUL2.fasta
mv MK715447.1.fasta Vaccinium_macrocarpon_CB_Stevens.fasta
mv BK061167.fasta   Vaccinium_corymbosum_NHB_Draper.fasta

# Extra species (GenBank plastomes)
mv MZ328079.fasta     Vaccinium_corymbosum_NHB_Complete.fasta
mv NC_042713.1.fasta  Vaccinium_oldhamii.fasta
mv LC521968.1.fasta   Vaccinium_uliginosum.fasta
mv LC521969.1.fasta   Vaccinium_vitis_idaea.fasta
mv MW006668.1.fasta   Vaccinium_japonicum.fasta
mv LC521967.1.fasta   Vaccinium_bracteatum.fasta

echo "Files renamed"
