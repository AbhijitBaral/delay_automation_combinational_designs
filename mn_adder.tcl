set N [lindex $argv 0];
set M [lindex $argv 1];
set K [expr {$N-$M}]
set Y_offset 7

#module Header
puts "`timescale 1ns / 1ps"
puts "module fastAdder #(parameter N=$N,M=$M)("
puts "\tinput \[[expr {$N-1}]:0\] A,B,"
puts "\tinput Cin,"
puts "\toutput \[[expr {$N-1}]:0\] sum,"
puts "\toutput Cout"
puts ");\n"

#Internal wires
puts "wire Cgen;"
puts "wire \[[expr {$K/2-1}]:0\]group_carry;\n"

#Module instantiations and Location assignement
#RCA
puts "(*RLOC_ORIGIN = \"X0Y[expr {$Y_offset + ($K-1)/8 + 1}]\", KEEP_HIERARCHY=\"yes\"*)RCA #(.M(${M}), .K(${K})) RCA_inst(.A(A\[[expr {$N-1}]:[expr {$K+4-($K/2)%4}]\]), .B(B\[[expr {$N-1}]:[expr {$K+4-($K/2)%4}]\]), .Cin(Cgen), .sum(sum\[[expr {$N-1}]:[expr {$K+4-(($K/2)%4)}]\]), .Cout(Cout));\n"

#compressed_adder
puts "(*RLOC_ORIGIN = \"X1Y${Y_offset}\" , KEEP_HIERARCHY=\"yes\"*)compressed_adder #(.K(${K})) compressed_adder_inst(.A(A\[[expr {$K-1}]:0\]), .group_carry(group_carry), .B(B\[[expr {$K-1}]:0\]), .Cin(Cin), .sum(sum\[[expr {$K-1}]:0\]));\n"

#carry_compressor
puts "(*RLOC_ORIGIN = \"X0Y${Y_offset}\" , KEEP_HIERARCHY=\"yes\"*)carry_compressor #(.K(${K})) CC_inst(.A(A\[[expr {$K-1}]:0\]),.B(B\[[expr {$K-1}]:0\]), .a_rem(A\[[expr {$K+3-($K/2)%4}]:$K\]), .b_rem(B\[[expr {$K+3-($K/2)%4}]:$K\]), .Cin(Cin), .group_carry(group_carry), .rca_sum(sum\[[expr {$K+3-($K/2)%4}]:$K\]), .Cout(Cgen));\n"

puts "endmodule"
