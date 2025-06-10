#set parameters
#set N 32
#set M 12
#set K [expr {$N-$M}]

set top_module "mn_adder_wrapper"
set part_name "xc7a200tlffv1156-2L"
set N_List {128}

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

	# run synthesis
	set status [catch {
            launch_runs synth_1
            wait_on_run synth_1

	    launch_runs impl_1
	    wait_on_run impl_1
        } result]

        if {$status != 0} {
            puts "!! Synthesis failed for N=$n, M=$m"
            puts "!! Error: $result"
        } else {
            puts "\nSynthesis and implementation completed successfully for N=$n, M=$m\n\n"
        }
        

        close_project
}

# Repeat flow for each parameter set
foreach n $N_List {
	for {set m 0} {$m <= 4} {incr m 2} {
		flow $m $n;
	}
}
