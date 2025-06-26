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
