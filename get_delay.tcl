set tolerance 0.007
set cp 8
file mkdir reports

set clk_constraints [file join [pwd] "clk_constraints.xdc"]
set summary [file join [pwd] reports "summary.txt"]

set wns 0
set wpws 0
set tns 0
#set fid_clk_constraints [open $clk_constraints "w"]
#close $fid_clk_constraints

#add_files -fileset constrs_1 $clk_constraints

proc fl_rep {cp count} {
	global clk_constraints
	global cp
	global tolerance
	global wns
	global wpws
	global tns
	global summary
	
	reset_run synth_1; reset_run impl_1;

	set fid_clk_constraints [open $clk_constraints "w"]
	puts $fid_clk_constraints "create_clock -name clk -period $cp \[get_ports clk\]"
	close $fid_clk_constraints
	
	remove_files -fileset constrs_1 $clk_constraints 
	add_files -fileset constrs_1 $clk_constraints 
	
	launch_runs synth_1;
	wait_on_run synth_1;
	
	launch_runs impl_1;
	wait_on_run impl_1;
	open_run impl_1;
	
	set timing_summary [file join [pwd] reports timing_summary_${count}.txt]
	report_timing_summary -file $timing_summary
	
	set fid_timing_summary [open $timing_summary "r"]
	set contents [read $fid_timing_summary]
	close $fid_timing_summary
	
	regexp -lineanchor {\n\s+([-0-9.]+)\s+([-0-9.]+)\s+\d+\s+\d+\s+([-0-9.]+)} $contents -> wns tns wpws
	
	set fid_summary [open $summary "a"]
	puts $fid_summary "Iteration ${count}\ncp:\t${cp}\nwns:\t${wns}\nwpws:\t${wpws}\n\n"
	close $fid_summary
}

fl_rep $cp 1

set count 2
while {$wns >$tolerance} {
	set cp [expr {$cp - $wns}]
	fl_rep $cp $count
	set count [expr {$count + 1}]
}

puts "\n\nThe operating clock pulse period is ${cp}. Corresponding WNS = ${wns} and WPWS = ${wpws}"
