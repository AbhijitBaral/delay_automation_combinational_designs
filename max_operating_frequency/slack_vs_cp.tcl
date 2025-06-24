set clk_name clk;
set start_period 0.5
set end_period 10
set step_period 0.1

file mkdir reports;

# output in txt file
set sweep_results [file join [pwd] "reports" "sweep_results.txt"]
file delete -force $sweep_results
set fid_sweep_results [open $sweep_results "w"]
set header [format "%-18s %-9s %-9s %-s" "Clock_period(ns)" "WNS(ns)" "WPWS(ns)" "Critical_path"]
puts $fid_sweep_results $header
close $fid_sweep_results

#Outputs in csv file
set sweep_results_csv [file join [pwd] "reports" sweep_results.csv]
file delete -force $sweep_results_csv
set fid_sweep_results_csv [open $sweep_results_csv "w"]
puts $fid_sweep_results_csv "Clock_period(ns),WNS(ns),WPWS(ns),Critical_path"
close $fid_sweep_results_csv

set clk_constraints [file join [pwd] "clk_constraints.xdc"];

set count 0;
for {set p $start_period} {$p <= $end_period + 1e-6} {set p [expr {$p+$step_period}]} {
	set count [expr {$count+1}]	
	
	set fid_clk_constraints [open $clk_constraints "w"]
	puts $fid_clk_constraints "create_clock -name clk -period [format "%.2f" ${p}] \[get_ports clk\]"
	close $fid_clk_constraints;

	reset_runs synth_1; reset_runs impl_1;

	remove_files -fileset constrs_1 $clk_constraints; add_files -fileset constrs_1 $clk_constraints
	
	launch_runs synth_1; wait_on_runs synth_1;
	launch_runs impl_1;  wait_on_runs impl_1;

	open_run impl_1;

	set timing_summary [file join [pwd] "reports" "timing_summary_run_${count}.txt"]
	report_timing_summary -file $timing_summary
	set crit_path [get_timing_paths -max_paths 1]

	set fid_timing_summary [open $timing_summary "r"]
	set contents [read $fid_timing_summary]
	close $fid_timing_summary

	set fid_sweep_results [open $sweep_results "a"];
	set fid_sweep_results_csv [open $sweep_results_csv "a"]
	if {[regexp -lineanchor {\n\s*(-?[0-9.]+)\s+(-?[0-9.]+)(?:\s+-?[0-9.]+){6}\s+(-?[0-9.]+)} $contents -> wns tns wpws]} {
		puts $fid_sweep_results [format "%-18.2f %-9s %-9s %-s" $p $wns $wpws $crit_path]
		puts $fid_sweep_results_csv "[format "%.3f" ${p}],${wns},${wpws},${crit_path}"
	} else {
		puts "WNS and WPWS not found — check format or regex"
	}
	close $fid_sweep_results;
	close $fid_sweep_results_csv;
	
}

