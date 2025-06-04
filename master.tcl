#set parameters
set N 32
set M 12
set K [expr {$N-$M}]



#Generate the module descriptions in verilog and put in ./design_modules/~~~~~~~~~~~~
exec tclsh mn_adder.tcl $N $M > design_modules/mn_adder.v
exec tclsh RCA_gen.tcl $M $K > design_modules/RCA_gen.v
exec tclsh compressed_adder_gen.tcl $K > design_modules/compressed_adder.v
exec tclsh carry_compressor_gen.tcl $K > design_modules/carry_compressor.v
puts "All modules generated successfully\n"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Start of flow~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#create project
create_project 
