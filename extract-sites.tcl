proc get_sites { distance } {
set currentDir [pwd]
set pdbFiles [glob -nocomplain ${currentDir}/*.pdb]
set cutoffdistance $distance
file mkdir Data/Within$cutoffdistance
file mkdir Sites/Within$cutoffdistance

set filename "Data/Within$cutoffdistance/ReslistPerPDB.dat"
set cp [open $filename w]

if {[llength $pdbFiles] > 0} {
    foreach file $pdbFiles {
		set sitecount 0
    mol new $file
		set last8Chars [string range $file end-7 end]
		puts $cp "/n /n Structure: $last8Chars"
		set sites [atomselect top "resname NH4 and name N"]
		set numsites [$sites num]
		set NH4residlist [$sites get resid]
		set NH4chainlist [$sites get chain]
		set series []
		for {set i 1} {$i <= $numsites} {incr i} {
				set elementA [lindex $NH4residlist [expr $i-1]]
				set elementB [lindex $NH4chainlist [expr $i-1]]
				lappend series "${elementB} ${elementA}"
		}
		set series [getuniquenumbers $series]
		foreach NH4resid $series {
		set sitecount [expr $sitecount +1]
		puts "Reached loop 1"
		set chainName [lindex $NH4resid 0]
		set residNum [lindex $NH4resid 1]
		set nameofN [atomselect top "resname NH4 and resid $residNum and chain $chainName and name N"]
		set nameval [$nameofN get name]
		set uniquelist []
		set uniqueValues []
		#puts $cp "Resid $residNum & Chain $chainName"
		set prot [atomselect top "(within $cutoffdistance of resid $residNum and chain $chainName and name N) and (altloc \"A\" or altloc \"\")"]
		set numbers [$prot get resid]
		set chains [$prot get chain]
		set uniquelistatthissite []
		
		foreach number $numbers chain $chains {
				lappend uniquelist2 "${chain} ${number}"
				lappend uniquelistatthissite "${chain} ${number}"
				puts "Reached Loop 2"
		}
		set unique_residues_at_this_site [getuniquenumbers $uniquelistatthissite]
		set num_residues_at_this_site [llength $unique_residues_at_this_site] 
		
		
		
		set uniqueValues [getuniquenumbers $uniquelist2]
		set numres [llength $uniqueValues]
		puts "$uniqueValues"
		set selectiontext ""
		set j 0
		foreach at $uniqueValues {
						
							set uniqueresid [lindex $at 1]
							set uniquechain [lindex $at 0]
				if {$uniqueresid < 0} {
						append selectiontext " (resid \"$uniqueresid\" and chain $uniquechain) or "
				} else {
						append selectiontext " (resid $uniqueresid and chain $uniquechain) or "
				}							
							
	
		}
		puts "Reaching Selection"
		set seltext [string range $selectiontext 0 end-3]	
		set ressel [atomselect top $seltext]
		set file1 [molinfo top get name]
		set pdbfilename1 [string range $file1 0 end-4]
		
		set pdbfilenameExt ".pdb"
		set pdbfilename $pdbfilename1$sitecount$pdbfilenameExt
		puts "SavingSites"
		$ressel writepdb Sites/Within$cutoffdistance/$pdbfilename
		
		}
		mol delete all
		set uniqueValues []
		set uniquelist2 []

		}
				close $cp
								}
								}
								
								


