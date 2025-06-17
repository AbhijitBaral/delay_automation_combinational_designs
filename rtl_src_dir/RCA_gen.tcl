set gen_dump ""
set M $param_M
set N $param_N
set K [expr {$N-$M}]
set r [expr {($K/2)%4}]
set rem $r

if {$r == 0} {
	set P $M;
	set lut_index_offset 0;
} else {
	set P [expr {$M-4+$r}];
	set lut_index_offset [expr {4-$rem}];
}

append gen_dump "\n`timescale 1ns / 1ps"

append gen_dump "\nmodule RCA #(parameter M=$M, K=$K)("
append gen_dump "\n\tinput \[[expr {$P-1}]:0\]A,B,"
append gen_dump "\n\tinput Cin,"
append gen_dump "\n\toutput \[[expr {$P-1}]:0\]sum,"
append gen_dump "\n\toutput Cout"
append gen_dump "\n\t);\n"

append gen_dump "\nwire \[$P-1:0\]Propagate;"
append gen_dump "\nwire \[$P-1:0\]carry;\n"

set y 0;
set count 1;
for {set i 0} {$i<= $P-1} {incr i} {
	set rloc "X0Y$y";
 	if {$count == 4} {
		set count 0;
		set y [expr {$y+1}];
		}	

	append gen_dump "\n(*RLOC = \"$rloc\"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_[expr $i + $lut_index_offset]("
	append gen_dump "\n.O(Propagate\[$i\]),"
	append gen_dump "\n.I0(A\[$i\]),"
	append gen_dump "\n.I1(B\[$i\]),"
	append gen_dump "\n.I2(1'b0),"
	append gen_dump "\n.I3(1'b0),"
	append gen_dump "\n.I4(1'b0),"
	append gen_dump "\n.I5(1'b0)"
	append gen_dump "\n);\n"

	set count [expr {$count+1}];
}

set q [expr {$P/4}];
set r [expr {$P%4}]; 

for {set j 0} {$j <= $q-1} {incr j} {
	if {$j == 0} {
		append gen_dump "\n(*RLOC = \"X0Y0\"*)CARRY4 RCA_CARRY4_0("
		append gen_dump "\n.CO(carry\[[expr {$j+3}]:$j\]),"
		append gen_dump "\n.O(sum\[[expr {$j+3}]:$j\]),"
		append gen_dump "\n.CI(Cin),"
		append gen_dump "\n.CYINIT(),"
		append gen_dump "\n.DI(A\[[expr {$j+3}]:$j\]),"
		append gen_dump "\n.S(Propagate\[[expr {$j+3}]:$j\])"
		append gen_dump "\n);\n"
	} else {
		append gen_dump "\n(*RLOC = \"X0Y${j}\"*)CARRY4 RCA_CARRY4_${j}("
		append gen_dump "\n.CO(carry\[[expr {$j*4+3}]:[expr {$j*4}]\]),"
		append gen_dump "\n.O(sum\[[expr {$j*4+3}]:[expr {$j*4}]\]),"
		append gen_dump "\n.CI(carry\[[expr {$j*4-1}]\]),"
		append gen_dump "\n.CYINIT(),"
		append gen_dump "\n.DI(A\[[expr {$j*4+3}]:[expr {$j*4}]\]),"
		append gen_dump "\n.S(Propagate\[[expr {$j*4+3}]:[expr {$j*4}]\])"
		append gen_dump "\n);\n"
	}
}

append gen_dump "\nwire \[2:0\] dummyDI ,dummySO, dummyCO, dummyS;\n"

if {$r >0} {
	if {$P <4} {
		append gen_dump "\n(*RLOC = \"X0Y0\"*)CARRY4 RCA_CARRY4_0("
		append gen_dump "\n.CO({dummyCO\[[expr {3-$r}]:0\]  , carry\[[expr {$P-1}]:0\]}),"
		append gen_dump "\n.O ({dummySO\[[expr {3-$r}]:0\]  , sum\[[expr {$P-1}]:0\]}),"
		append gen_dump "\n.CI(Cin),"
		append gen_dump "\n.CYINIT(),"
		append gen_dump "\n.DI({dummyDI\[[expr {3-$r}]:0\], A\[[expr {$P-1}]:0\]}),"
		append gen_dump "\n.S ({dummyS\[[expr {3-$r}]:0\] , Propagate\[[expr {$P-1}]:0\]})"
		append gen_dump "\n);\n"
	} else {
		append gen_dump "\n(*RLOC = \"X0Y[expr {$q}]\"*)CARRY4 RCA_CARRY4_${q}("
		append gen_dump "\n.CO({dummyCO\[[expr {3-$r}]:0\]  , carry\[[expr {$P-1}]:[expr {$q*4}]\]}),"
		append gen_dump "\n.O ({dummySO\[[expr {3-$r}]:0\]  , sum\[[expr {$P-1}]:[expr {$q*4}]\]}),"
		append gen_dump "\n.CI(carry\[[expr {$q*4-1}]\]),"
		append gen_dump "\n.CYINIT(),"
		append gen_dump "\n.DI({dummyDI\[[expr {3-$r}]:0\], A\[[expr {$P-1}]:[expr {$q*4}]\]}),"
		append gen_dump "\n.S ({dummyS\[[expr {3-$r}]:0\] , Propagate\[[expr {$P-1}]:[expr {$q*4}]\]})"
		append gen_dump "\n);\n"
	}
}

append gen_dump "\nassign Cout=carry\[$P-1\];\n"

append gen_dump "\nendmodule"
