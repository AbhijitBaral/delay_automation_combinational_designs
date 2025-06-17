set gen_dump ""
set N $param_N
set M $param_M
set K [expr {$N-$M}]

append gen_dump "\n`timescale 1ns / 1ps"
append gen_dump "\nmodule compressed_adder #(parameter K=$K)("
append gen_dump "\n    input \[[expr {$K-1}]:0\] A,B,"
append gen_dump "\n    input \[[expr {$K/2-1}]:0\]group_carry,"
append gen_dump "\n    input Cin,"
append gen_dump "\n    output \[[expr {$K-1}]:0\] sum"
append gen_dump "\n    );\n"

append gen_dump "\n(*RLOC = \"X0Y0\"*)LUT6_2 #(.INIT(64'hE11E877899996666))So_lut_0("
append gen_dump "\n.O6(sum\[1\]),"
append gen_dump "\n.O5(sum\[0\]),"
append gen_dump "\n.I0(A\[0\]),"
append gen_dump "\n.I1(B\[0\]),"
append gen_dump "\n.I2(A\[1\]),"
append gen_dump "\n.I3(B\[1\]),"
append gen_dump "\n.I4(Cin),"
append gen_dump "\n.I5(1'b1)"
append gen_dump "\n);\n"

set y 0;
set count 1;
for {set i 2} {$i <= $K -2} {incr i 2} {
    	set rloc "X0Y[expr {$y+1}]";
	if {$count == 4} {
		set count 0;
		set y [expr {$y+1}];
	}
	
	append gen_dump "\n(* RLOC = \"$rloc\" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_[expr {$i/2}]("
	append gen_dump "\n.O6(sum\[[expr {$i+1}]\]),"
	append gen_dump "\n.O5(sum\[[expr {$i}]\]),"
	append gen_dump "\n.I0(A\[$i\]),"
	append gen_dump "\n.I1(B\[$i\]),"
	append gen_dump "\n.I2(A\[[expr {$i+1}]\]),"
	append gen_dump "\n.I3(B\[[expr {$i+1}]\]),"
	append gen_dump "\n.I4(group_carry\[[expr {$i/2-1}]\]),"
	append gen_dump "\n.I5(1'b1));\n"

	set count [expr {$count+1}];
}

append gen_dump "\nendmodule"
