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
# GenBank assemblies from the paper (no raw reads, but still useful)
# These are the cpDNA assemblies submitted by the authors
################################################################################

# Array of GenBank accession numbers for the plastomes used in the study
assemblies=(
  "OM791342"     # V. corymbosum hybrid cv. ‘Arcadia’ (SHB)
  "OM791343"     # V. virgatum cv. ‘Ochlockonee’
  "BK061167"     # V. corymbosum cv. ‘Draper’
  "OM791344"     # V. angustifolium cv. ‘Brunswick’ 
  "OM809159"     # V. myrtillus genotype ‘OU-L2’:
  "MK715447.1"   # V. macrocarpon cv. ‘Stevens’  (cranberry, from a previous study)
)

# Pull down each GenBank cpDNA file
# These are just single .fasta sequences of the assembled chloroplast genome
for acc in "${assemblies[@]}"; do
  echo "Downloading GenBank assembly $acc..."
  esearch -db nucleotide -query "$acc" | efetch -format fasta > "${acc}.fasta"
done

echo "All downloads from paper complete"

echo "Downloading additional Vaccinium cpDNA genomes"

extra_assemblies=(
  "NC_042713.1"  # V. oldhamii also included in paper 
  "LC521967.1"   # V. bracteatum also included in paper 
  "MK816300.1"   # V. duclouxii also included in paper 
  "MK816301.1"   # V. fragile also included in paper 
  "LC521968.1"   # V. uliginosum also included in paper 
  "MW006668.1"   # V. japonicum also included in paper 
  "MK715444.1"   # V. microcarpum also included in paper  
  "LC521969.1"   # V. vitis-idaea also included in paper 
  "KJ463365.1"   # Chamaedaphne calyculata - outgroup 1
  "NC_059849.1"  # Gaultheria fragrantissima - outgroup 2
  "MW801381.1"   # Lyonia ovalifolia
  "MW801359.1"   # Pieris formosa ####################### EXTRA ONES NEW TO OUR ANALYSIS BELOW:
  "NC_058740.1"  # Vaccinium oxycoccos - european cranberry
  "ON480526.1"   # Vaccinium ashei 
  "PQ036140.1"   # Vaccinium supracostatum
  "PP788841.1"   # Vaccinium henryi
  "NC_073583.1"  # Vaccinium floribundum 
)

for acc in "${extra_assemblies[@]}"; do
  echo "Downloading cpDNA for accession $acc..."
  esearch -db nucleotide -query "$acc" | efetch -format fasta > "${acc}.fasta"
done

echo "All extra cpDNA genomes downloaded!"

echo "Renaming all cpDNA FASTA files..."

# From Fahrenkrog et al. 2022
mv OM791342.fasta   Vaccinium_corymbosum_hybrid_SHB.fasta
mv OM791343.fasta   Vaccinium_virgatum_.fasta
mv OM791344.fasta   Vaccinium_angustifolium.fasta
mv OM809159.fasta   Vaccinium_myrtillus.fasta
mv MK715447.1.fasta Vaccinium_macrocarpon.fasta
mv BK061167.fasta   Vaccinium_corymbosum_NHB.fasta

# Already-included extra species
mv NC_042713.1.fasta  Vaccinium_oldhamii.fasta
mv LC521967.1.fasta   Vaccinium_bracteatum.fasta
mv MK816300.1.fasta   Vaccinium_duclouxii.fasta
mv MK816301.1.fasta   Vaccinium_fragile.fasta
mv LC521968.1.fasta   Vaccinium_uliginosum.fasta
mv MW006668.1.fasta   Vaccinium_japonicum.fasta
mv MK715444.1.fasta   Vaccinium_microcarpum.fasta
mv LC521969.1.fasta   Vaccinium_vitis_idaea.fasta

# Outgroups and Ericaceae relatives
mv KJ463365.1.fasta   Chamaedaphne_calyculata.fasta
mv NC_059849.1.fasta  Gaultheria_fragrantissima.fasta
mv MW801381.1.fasta   Lyonia_ovalifolia.fasta
mv MW801359.1.fasta   Pieris_formosa.fasta

# New additions to our analysis
mv NC_058740.1.fasta  Vaccinium_oxycoccos.fasta  
mv ON480526.1.fasta   Vaccinium_ashei.fasta
mv PQ036140.1.fasta   Vaccinium_supracostatum.fasta 
mv PP788841.1.fasta   Vaccinium_henryi.fasta
mv NC_073583.1.fasta  Vaccinium_floribundum.fasta

echo "Files renamed"
