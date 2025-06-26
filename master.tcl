######################Parse flow_config file and set variables appropriately#############################################
set fid_flow_config [open [file join [pwd] flow_config] "r"]
set content_flow_config [read $fid_flow_config]

set lines_content_config [split $content_flow_config "\n"]


set proj_name   [lindex $lines_content_config 1]
set part_name   [lindex $lines_content_config 4]
set top_module  [lindex $lines_content_config 7]
set param_sweep [lrange $lines_content_config 10 [llength $lines_content_config]-1]


set loop_body ""
set dict_def "set param_dict \[dict create "
set size 0
set id ""

# Convert the param_weep construct in config file into actual tcl loop syntax
# The loop construct along with calling of function `flow` with appropriate parameter variables are put inside `loop_body` variable as a string.
# The loop_body is `evale`d later, after the definition of all the functions
foreach line $param_sweep {
	if {[regexp {^foreach\s+(\w+)\s+\{(.*)\}} $line -> var list]} {
        	# Clean commas
        	regsub -all {,} $list "" clean_list
        	append loop_body "foreach $var \{$clean_list\} \{\n"
		append dict_def "$var \$${var} "
		set size [expr {$size + 1}]
    	}

	if {[regexp {^for\s+(\w+)\s+\{([^\s]+)\s+to\s+([^\}]+)\}\s+\{([^\}]+)\}} $line -> var start end step]} {
		append loop_body "for \{set $var $start\} {\$$var <= $end} \{incr $var $step\} \{\n"
		append dict_def "$var \$${var} "
		set size [expr {$size + 1}]
	}	
}
append loop_body [append dict_def "\]\n"]
append loop_body {dict for {key value} $param_dict {
	if {[regexp {param_(\w+)} $key -> suffix]} {
		append id "_${suffix}${value}"
	}
}
set proj_id "${proj_name}${id}"
set id ""
}
append loop_body "flow \$proj_id \$param_dict \$top_module\n"
append loop_body [string repeat } ${size}]



########################################Initialize necessary constants#####################################################
set tolerance 0.007
set cp 0.5

set wns 0
set wpws 0
set tns 0

################################### Create and put column heading in the final delay_summary file###########################
file mkdir [file join [pwd] out_dir]

set delay_summary [file join [pwd] out_dir delay_summary.txt]
set fid_delay_summary [open $delay_summary "w"]
set header [format "%-20s %-18s %-9s %-9s %-s" "Project_id" "Clock_period(ns)" "WNS(ns)" "WPWS(ns)" "Critical_path"]
puts $fid_delay_summary $header
close $fid_delay_summary

set delay_summary_csv [file join [pwd] out_dir delay_summary.csv]
set fid_delay_summary_csv [open $delay_summary_csv "w"]
puts $fid_delay_summary_csv "project_id,clock_period,WNS,WPWS,Critical_path"
close $fid_delay_summary_csv

set power_summary [file join [pwd] out_dir power_summary.csv]
set fid_power_summary [open $power_summary "w"]
puts $fid_power_summary "project_id,Total_On-Chip_Power(W),Dynamic_Power(W),Static_Power(W)"
close $fid_power_summary

set utilization_summary [file join [pwd] out_dir utilization_summary.csv]
set fid_utilization_summary [open $utilization_summary "w"]
puts $fid_utilization_summary "project_id,LUTs_Used,FlipFlops_Used,DSPs_Used,BRAMs_used,IOs_Used"
close $fid_utilization_summary

################################### Function needed in get_delay function ####################################################
proc fl_rep {cp count proj_id} {
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
	
	set timing_summary [file join [pwd] design_sweep_runs ${proj_id} reports timing_summary_${count}.txt]
	report_timing_summary -file $timing_summary
	
	set fid_timing_summary [open $timing_summary "r"]
	set contents [read $fid_timing_summary]
	close $fid_timing_summary
	
	regexp {\n\s*(-?[0-9.]+)\s+(?:-?[0-9.]+\s+){3}(-?[0-9.]+)\s+(?:-?[0-9.]+\s+){3}(-?[0-9.]+)} $contents -> wns whs wpws
	
	set fid_summary [open $summary "a"]
	puts $fid_summary "Iteration ${count}\ncp:\t${cp}\nwns:\t${wns}\nwpws:\t${wpws}\nwhs:\t${whs}\n\n"
	close $fid_summary
}

#########################################Calculates the minimum operating clock period ################################################
proc get_delay {proj_id} {
	global clk_constraints
	global cp
	global tolerance
	global wns
	global wpws
	global tns
	global summary
	
	file mkdir [file join [pwd] design_sweep_runs ${proj_id} reports]
	
	set clk_constraints [file join [pwd] design_sweep_runs ${proj_id} clk_constraints.xdc]
	set summary [file join [pwd] design_sweep_runs ${proj_id} reports summary.txt]

	fl_rep $cp 1 $proj_id;
	
	set p_wns [expr {$cp - $wns}]
	set p_wpws [expr {$cp - $wpws}]

	if {$p_wpws > $p_wns} {
		set cp $p_wpws
		fl_rep $cp 2 $proj_id
	} else {
		set cp $p_wns
		fl_rep $cp 2 $proj_id
	
		set count 3
		while {$wns <0} {
			set cp [expr {$cp - $wns}]
			fl_rep $cp $count
			set count [expr {$count + 1}]
		}
	}
}

puts "\n\nThe operating clock pulse period is ${cp}. Corresponding WNS = ${wns} and WPWS = ${wpws}"

################################Proc to extract source rtl or rtl generating tcl scripts from dir and put them into project dir###########
namespace eval gnspc {
	proc gen_modules {param_dict proj_id top_module} {

		file mkdir [file join [pwd] design_sweep_runs ${proj_id} design_modules]
		# setting variables (parameter values) from the dictionary
		foreach var [dict keys $param_dict] {
			set $var [dict get $param_dict $var]
		}

		# For case when rtl is being generated by tcl scripts
		if {[llength [glob -nocomplain [file join [pwd] rtl_src_dir *.tcl]]] > 0} {
			foreach rtl_gen_src [glob [file join [pwd] rtl_src_dir *.tcl]] {
				set rtl_destn [file join [pwd] design_sweep_runs ${proj_id} design_modules [file rootname [file tail $rtl_gen_src]].v]
				set fid_rtl_destn [open $rtl_destn "w"]
				source $rtl_gen_src
				puts $fid_rtl_destn $gen_dump
				close $fid_rtl_destn
			}
		}
		
		# For case when RTL is explicitly written in verilog
		if {[llength [glob -nocomplain [file join [pwd] rtl_src_dir *.v]]] > 0 } {
			foreach rtl_src [glob [file join [pwd] rtl_src_dir *.v]] {
				set rtl_content [read [open $rtl_src "r"]]
				# Overwrite the parameters if it is the top module 
				if {[file rootname [file tail $rtl_src]] == $top_module} {
					dict for {key value} $param_dict {
						regsub -all -- $key $rtl_content $value rtl_content
					}
				}
				set rtl_destn [file join [pwd] design_sweep_runs ${proj_id} design_modules [file tail $rtl_src]]
				set fid_rtl_destn [open $rtl_destn "w"]
				puts $fid_rtl_destn $rtl_content
				close $fid_rtl_destn
			}
		}
	}
}


######################################## Main Caller function that creates project, sets modules, and puts delays in log#################
proc flow {proj_id param_dict top_module} {
	#global top_module
	global part_name
	global delay_summary
	global delay_summary_csv
	global cp
	global wns
	global wpws
	global utilization_summary
	global power_summary

	#create project
	create_project ${proj_id} [file join [pwd] design_sweep_runs ${proj_id}] -part $part_name
	
	#generate modules based on present parameter values
	gnspc::gen_modules ${param_dict} ${proj_id} ${top_module}
	
	#add files
	set design_modules [glob [file join [pwd] design_sweep_runs ${proj_id} design_modules *.v]]
	add_files -fileset sources_1 $design_modules
	update_compile_order -fileset sources_1
	
	
	#set top module
	set_property top $top_module [get_fileset sources_1]
	
	#call delay computation function
	get_delay $proj_id
	set crit_path [get_timing_paths -max_paths 1]
	regexp {^[^_]+_(.*)} $proj_id -> trimmed 
	
	#Extract PPA and put into the appropriate output files
	set fid_delay_summary [open $delay_summary "a"]
	puts $fid_delay_summary [format "%-20s %-18.3f %-9.3f %-9.3f %-s" "${trimmed}:" ${cp} ${wns} ${wpws} ${crit_path}]
	close $fid_delay_summary
	set fid_delay_summary_csv [open $delay_summary_csv "a"]
	puts $fid_delay_summary_csv "${trimmed},[format "%.3f" ${cp}],[format "%.3f" ${wns}],[format "%.3f" ${wpws}],${crit_path}"
	close $fid_delay_summary_csv

	report_power -file [file join [pwd] design_sweep_runs ${proj_id} reports power_report.txt]
	set fid_power_report [open [file join [pwd] design_sweep_runs ${proj_id} reports power_report.txt] "r"]
	set power_content [read $fid_power_report]
	close $fid_power_report
	regexp {Total On-Chip Power \(W\)\s+\|\s+([0-9.]+)} $power_content -> total_power
	regexp {Dynamic \(W\)\s+\|\s+([0-9.]+)} $power_content -> dynamic_power
	regexp {Device Static \(W\)\s+\|\s+([0-9.]+)} $power_content -> static_power
	set fid_power_summary [open $power_summary "a"]
	puts $fid_power_summary "${trimmed},${total_power},${dynamic_power},${static_power}"
	close $fid_power_summary

	report_utilization -file [file join [pwd] design_sweep_runs ${proj_id} reports utilization_report.txt]
	set fid_utilization_report [open [file join [pwd] design_sweep_runs ${proj_id} reports utilization_report.txt] "r"]
	set utilization_content [read $fid_utilization_report]
	close $fid_utilization_report
	regexp {Slice LUTs\s+\|\s+(\d+)} $utilization_content -> lut_count
	regexp {Slice Registers\s+\|\s+(\d+)} $utilization_content -> ff_count
	regexp {DSPs\s+\|\s+(\d+)} $utilization_content -> dsp_count
	regexp {Block RAM Tile\s+\|\s+(\d+)} $utilization_content -> bram_count
	regexp {Bonded IOB\s+\|\s+(\d+)} $utilization_content -> io_count
	set fid_utilization_summary [open $utilization_summary "a"]
	puts $fid_power_summary "${trimmed},${lut_count},${ff_count},${dsp_count},${bram_count},${io_count}"
	close $fid_power_summary
	
	set cp 0.5

        close_project
}


###################################Flow Starts from Here#####################################################################


eval $loop_body
