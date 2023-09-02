How these files were created-

/OriginalStructureFiles/: This folder contains the PDB files for the biomolecules downloaded using the RCSB API. Note: Biomolecules in this folder have not been filtered for proteins only.

/Sites/: This folder contains the extracted ammonium binding sites from the biomolecules that are present in the /OriginalStructureFiles/ folder. This folder contains further subfolders for sites extracted based on whether we consider a cutoff distance of 3.75A, 4A or 7A. These sites as well as those under the /ProteinsOnly/Sites/ folder were extracted using the extract-sites.tcl process in VMD.

/ProteinsOnly/: This contains the PDB files of proteins filtered out using the classify-prot-nonprot.sh bash script. 
