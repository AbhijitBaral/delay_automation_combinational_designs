set clk_name clk;
set start_period 0.5
set end_period 5
set step_period 0.1

file mkdir reports;

set sweep_results [file join [pwd] "reports" "sweep_results.txt"]
file delete -force $sweep_results
set fid_sweep_results [open $sweep_results "w"]
puts $fid_sweep_results "Clock_period(ns)\tWNS(ns)\tWPWS(ns)"
close $fid_sweep_results

set clk_constraints [file join [pwd] "clk_constraints.xdc"];

set cp_list "clock_period = \["
set wns_list "wns= \["
set wpws_list "wpws= \["

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

	set fid_timing_summary [open $timing_summary "r"]
	set contents [read $fid_timing_summary]
	close $fid_timing_summary

	set fid_sweep_results [open $sweep_results "a"];
	if {[regexp -lineanchor {\n\s*(-?[0-9.]+)\s+(-?[0-9.]+)(?:\s+-?[0-9.]+){6}\s+(-?[0-9.]+)} $contents -> wns tns wpws]} {
		puts $fid_sweep_results "[format "%.2f" ${p}]\t${wns}\t${wpws}"
	} else {
		puts "WNS and WPWS not found — check format or regex"
	}
	close $fid_sweep_results;
	
	append cp_list "${p}, "
	append wns_list "${wns}, "
	append wpws_list "${wpws}, "
}

puts $cp_list
puts $wns_list
puts $wpws_list

set cp_list "[string range ${cp_list} 0 [expr {[string length $cp_list] - 3}]] \]"
set wns_list "[string range ${wns_list} 0 [expr {[string length $wns_list] - 3}]] \]"
set wpws_list "[string range ${wpws_list} 0 [expr {[string length $wpws_list] - 3}]] \]"

set fid_python_plot [open [file join [pwd] plot.py] "w"]

puts $fid_python_plot {
import matplotlib.pyplot as plt
import numpy as np

# Define data
$cp_list
\n
$wns_list
\n
$wpws_list
\n

# Plot 1: WNS vs Clock Period
plt.figure(figsize=(8, 5))
plt.plot(clock_period, wns, 'bo-', linewidth=1.5, label='WNS')
plt.title('WNS vs Clock Period')
plt.xlabel('Clock Period (ns)')
plt.ylabel('Worst Negative Slack (ns)')
plt.grid(True)
plt.xlim(\[min(clock_period),max(clock_period)\])
plt.legend()
plt.tight_layout()

# Plot 2: WPWS vs Clock Period
plt.figure(figsize=(8, 5))
plt.plot(clock_period, wpws, 'rs-', linewidth=1.5, label='WPWS')
plt.title('WPWS vs Clock Period')
plt.xlabel('Clock Period (ns)')
plt.ylabel('Worst Pulse width Slack (ns)')
plt.grid(True)
plt.xlim(\[min(clock_period),max(clock_period)\])
plt.legend()
plt.tight_layout()
plt.show(block=False)
input("Enter to exit script")
}

close $fid_python_plot
