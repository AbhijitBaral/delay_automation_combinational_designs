set tolerance 0.005
set cp 8

set clk_constraints [file join [pwd] "clk_constraints.xdc"]
set fid_clk_constraints [file open $clk_constraints "w"]
puts $fid_clk_constraints "create_clock -name clk -period $cp \[get_ports clk\]"
file close $fid_clk_constraints

reset_run synth_1; reset_run impl_1;

launch_runs synth_1;
wait_on_run synth_1;

launch_runs impl_1;
wait_on_run impl_1;
open_run impl_1;

report_timing_summary -file [file join [pwd] reports timing_summary_1.txt]
