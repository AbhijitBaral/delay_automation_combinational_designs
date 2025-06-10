#set parameters
#set N 32
#set M 12
#set K [expr {$N-$M}]

set top_module "mn_adder_wrapper"
set part_name "xc7a200tlffv1156-2L"
set N_List {32}

set tolerance 0.007
set cp 8

set wns 0
set wpws 0
set tns 0

set delay_summary [file join [pwd] delay_summary.txt]
set fid_delay_summary [open $delay_summary "w"]
puts $fid_delay_summary "\t\tclock_period\tWNS\tWPWS"
close $fid_delay_summary

proc fl_rep {cp count n m} {
	global clk_constraints
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
	
	set timing_summary [file join [pwd] "design_sweep_runs" "mn_adder_N${n}M${m}" "reports" "timing_summary_${count}.txt"]
	report_timing_summary -file $timing_summary
	
	set fid_timing_summary [open $timing_summary "r"]
	set contents [read $fid_timing_summary]
	close $fid_timing_summary
	
	regexp -lineanchor {\n\s+([-0-9.]+)\s+([-0-9.]+)\s+\d+\s+\d+\s+([-0-9.]+)} $contents -> wns tns wpws
	
	set fid_summary [open $summary "a"]
	puts $fid_summary "Iteration ${count}\ncp:\t${cp}\nwns:\t${wns}\nwpws:\t${wpws}\n\n"
	close $fid_summary
}

proc get_delay {n m} {
	global clk_constraints
	global cp
	global tolerance
	global wns
	global wpws
	global tns
	global summary
	
	file mkdir [file join [pwd] "design_sweep_runs" "mn_adder_N${n}M${m}" "reports"]
	
	set clk_constraints [file join [pwd] "design_sweep_runs" "mn_adder_N${n}M${m}" "clk_constraints.xdc"]
	set summary [file join [pwd] "design_sweep_runs" "mn_adder_N${n}M${m}" "reports" "summary.txt"]

	fl_rep $cp 1 $n $m;
	
	set count 2
	while {$wns >$tolerance} {
		set cp [expr {$cp - $wns}]
		fl_rep $cp $count $n $m
		set count [expr {$count + 1}]
	}
}

puts "\n\nThe operating clock pulse period is ${cp}. Corresponding WNS = ${wns} and WPWS = ${wpws}"

proc gen_modules {n m} {
	#Generate the module descriptions in verilog and put in ./design_modules/
	file mkdir [file join [pwd] design_sweep_runs mn_adder_N${n}M${m} design_modules]
	set k [expr {$n - $m}]
	exec tclsh [file join [pwd] module_generator_scripts adder_wrapper_gen.tcl] $n $m > [file join [pwd] "design_sweep_runs" "mn_adder_N${n}M${m}" "design_modules" "adder_wrapper.v"]
	exec tclsh [file join [pwd] module_generator_scripts mn_adder_gen.tcl] $n $m > [file join [pwd] "design_sweep_runs" "mn_adder_N${n}M${m}" "design_modules" "mn_adder.v"]
	exec tclsh [file join [pwd] module_generator_scripts RCA_gen.tcl] $m $k > [file join [pwd] "design_sweep_runs" "mn_adder_N${n}M${m}" "design_modules" "RCA.v"]
	exec tclsh [file join [pwd] module_generator_scripts compressed_adder_gen.tcl] $k > [file join [pwd] "design_sweep_runs" "mn_adder_N${n}M${m}" "design_modules" "compressed_adder.v"]
	exec tclsh [file join [pwd] module_generator_scripts carry_compressor_gen.tcl] $k > [file join [pwd] "design_sweep_runs" "mn_adder_N${n}M${m}" "design_modules" "carry_compressor.v"]
	puts "All modules generated successfully\n\n"
}


proc flow {m n} {
	global top_module
	global part_name
	global delay_summary
	global cp
	global wns
	global wpws

	puts "\nRunning synthesis for N=$n and M=$m\n"	

	#create project
	create_project mn_adder_N${n}M${m} [file join [pwd] design_sweep_runs mn_adder_N${n}M${m}] -part $part_name
	
	#generate modules based on present parameter values
	gen_modules $n $m
	
	#add files
	set design_modules [glob [file join [pwd] "design_sweep_runs" "mn_adder_N${n}M${m}" "design_modules" *.v]]
	add_files -fileset sources_1 $design_modules
	update_compile_order -fileset sources_1
	
	
	#set top module
	set_property top $top_module [get_fileset sources_1]
	
	#call delay computation function
	get_delay $n $m
	set fid_delay_summary [open $delay_summary "a"]
	puts $fid_delay_summary "N${n}M${m}:  ${cp}\t${wns}\t${wpws}"
	close $fid_delay_summary
	set cp 8

        close_project
}

# Repeat flow for each parameter set
foreach n $N_List {
	for {set m 0} {$m <= 2} {incr m 2} {
		flow $m $n;
	}
}
