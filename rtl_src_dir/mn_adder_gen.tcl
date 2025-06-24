set gen_dump ""
set N $param_N
set M $param_M
set K [expr {$N-$M}]
set Y_offset 7

if {[expr {($K/2)%4}] == 0} {
	set RCA_index_offset 0;
	set CC_port ".A(A\[[expr {$K-1}]:0\]),.B(B\[[expr {$K-1}]:0\]), .a_rem(), .b_rem(), .Cin(Cin), .group_carry(group_carry), .rca_sum(), .Cout(Cgen)"
} else {
	set RCA_index_offset [expr {4-($K/2)%4}]
	set CC_port ".A(A\[[expr {$K-1}]:0\]),.B(B\[[expr {$K-1}]:0\]), .a_rem(A\[[expr {$K+3-($K/2)%4}]:$K\]), .b_rem(B\[[expr {$K+3-($K/2)%4}]:$K\]), .Cin(Cin), .group_carry(group_carry), .rca_sum(sum\[[expr {$K+3-($K/2)%4}]:$K\]), .Cout(Cgen)"
}


#module Header
append gen_dump "\n`timescale 1ns / 1ps"
append gen_dump "\nmodule mn_adder #(parameter N=$N,M=$M)("
append gen_dump "\n\tinput \[[expr {$N-1}]:0\] A,B,"
append gen_dump "\n\tinput Cin,"
append gen_dump "\n\toutput \[[expr {$N-1}]:0\] sum,"
append gen_dump "\n\toutput Cout"
append gen_dump "\n);\n"

#Internal wires
append gen_dump "\nwire Cgen;"
append gen_dump "\nwire \[[expr {$K/2-1}]:0\]group_carry;\n"

#Module instantiations and Location assignement

if { $M == 0} {
	#compressed_adder
	append gen_dump "\n(*RLOC_ORIGIN = \"X1Y[expr {$Y_offset-1}]\" , KEEP_HIERARCHY=\"yes\"*)compressed_adder #(.K(${K})) compressed_adder_inst(.A(A\[[expr {$K-1}]:0\]), .group_carry(group_carry), .B(B\[[expr {$K-1}]:0\]), .Cin(Cin), .sum(sum\[[expr {$K-1}]:0\]));\n"

	#carry_compressor
	append gen_dump "\n(*RLOC_ORIGIN = \"X0Y${Y_offset}\" , KEEP_HIERARCHY=\"yes\"*)carry_compressor #(.K(${K})) CC_inst(.A(A\[[expr {$K-1}]:0\]),.B(B\[[expr {$K-1}]:0\]), .a_rem(), .b_rem(), .Cin(Cin), .group_carry(group_carry), .rca_sum(), .Cout(Cout));\n"

} elseif {$K == 0} {

	#RCA
	append gen_dump "\n(*RLOC_ORIGIN = \"X0Y${Y_offset}\", KEEP_HIERARCHY=\"yes\"*)RCA #(.M(${M}), .K(${K})) RCA_inst(.A(A\[[expr {$N-1}]:0\]), .B(B\[[expr {$N-1}]:0\]), .Cin(Cin), .sum(sum\[[expr {$N-1}]:0\]), .Cout(Cout));\n"

} else {

	#RCA
	append gen_dump "\n(*RLOC_ORIGIN = \"X0Y[expr {$Y_offset + ($K-1)/8 + 1}]\", KEEP_HIERARCHY=\"yes\"*)RCA #(.M(${M}), .K(${K})) RCA_inst(.A(A\[[expr {$N-1}]:[expr {$K+$RCA_index_offset}]\]), .B(B\[[expr {$N-1}]:[expr {$K+$RCA_index_offset}]\]), .Cin(Cgen), .sum(sum\[[expr {$N-1}]:[expr {$K+$RCA_index_offset}]\]), .Cout(Cout));\n"
	
	#compressed_adder
	append gen_dump "\n(*RLOC_ORIGIN = \"X1Y[expr {$Y_offset-1}]\" , KEEP_HIERARCHY=\"yes\"*)compressed_adder #(.K(${K})) compressed_adder_inst(.A(A\[[expr {$K-1}]:0\]), .group_carry(group_carry), .B(B\[[expr {$K-1}]:0\]), .Cin(Cin), .sum(sum\[[expr {$K-1}]:0\]));\n"
	
	#carry_compressor
	append gen_dump "\n(*RLOC_ORIGIN = \"X0Y${Y_offset}\" , KEEP_HIERARCHY=\"yes\"*)carry_compressor #(.K(${K})) CC_inst(${CC_port});\n"

}

append gen_dump "\nendmodule"
