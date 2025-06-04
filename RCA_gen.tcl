set M [lindex $argv 0];
set K [lindex $argv 1];
set r [expr {($K/2)%4}]
set rem $r

if {$r == 0} {
	set P $M;
} else {
	set P [expr {$M-4+$r}];
}

puts "`timescale 1ns / 1ps"

puts "module RCA #(parameter M=$M, K=$K)("
puts "\tinput \[[expr {$P-1}]:0\]A,B,"
puts "\tinput Cin,"
puts "\toutput \[[expr {$P-1}]:0\]sum,"
puts "\toutput Cout"
puts "\t);\n"

puts "wire \[$P-1:0\]Propagate;"
puts "wire \[$P-1:0\]carry;\n"

set y 0;
set count 1;
for {set i 0} {$i<= $P-1} {incr i} {
	set rloc "X0Y$y";
 	if {$count == 4} {
		set count 0;
		set y [expr {$y+1}];
		}	

	puts "(*RLOC = \"$rloc\"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_[expr $i+(4-$rem)]("
	puts ".O(Propagate\[$i\]),"
	puts ".I0(A\[$i\]),"
	puts ".I1(B\[$i\]),"
	puts ".I2(1'b0),"
	puts ".I3(1'b0),"
	puts ".I4(1'b0),"
	puts ".I5(1'b0)"
	puts ");\n"

	set count [expr {$count+1}];
}

set q [expr {$P/4}];
set r [expr {$P%4}]; 

for {set j 0} {$j <= $q-1} {incr j} {
	if {$j == 0} {
		puts "(*RLOC = \"X0Y0\"*)CARRY4 RCA_CARRY4_0("
		puts ".CO(carry\[[expr {$j+3}]:$j\]),"
		puts ".O(sum\[[expr {$j+3}]:$j\]),"
		puts ".CI(Cin),"
		puts ".CYINIT(),"
		puts ".DI(A\[[expr {$j+3}]:$j\]),"
		puts ".S(Propagate\[[expr {$j+3}]:$j\])"
		puts ");\n"
	} else {
		puts "(*RLOC = \"X0Y${j}\"*)CARRY4 RCA_CARRY4_${j}("
		puts ".CO(carry\[[expr {$j*4+3}]:[expr {$j*4}]\]),"
		puts ".O(sum\[[expr {$j*4+3}]:[expr {$j*4}]\]),"
		puts ".CI(carry\[[expr {$j*4-1}]\]),"
		puts ".CYINIT(),"
		puts ".DI(A\[[expr {$j*4+3}]:[expr {$j*4}]\]),"
		puts ".S(Propagate\[[expr {$j*4+3}]:[expr {$j*4}]\])"
		puts ");\n"
	}
}

puts "wire \[2:0\] dummyDI ,dummySO, dummyCO, dummyS;\n"

if {$r >0} {
	if {$P <4} {
		puts "(*RLOC = \"X0Y0\"*)CARRY4 RCA_CARRY4_0("
		puts ".CO({dummyCO\[[expr {3-$r}]:0\]  , carry\[[expr {$P-1}]:0\]}),"
		puts ".O ({dummySO\[[expr {3-$r}]:0\]  , sum\[[expr {$P-1}]:0\]}),"
		puts ".CI(Cin),"
		puts ".CYINIT(),"
		puts ".DI({dummyDI\[[expr {3-$r}]:0\], A\[[expr {$P-1}]:0\]}),"
		puts ".S ({dummyS\[[expr {3-$r}]:0\] , Propagate\[[expr {$P-1}]:0\]})"
		puts ");\n"
	} else {
		puts "(*RLOC = \"X0Y[expr {$q}]\"*)CARRY4 RCA_CARRY4_${q}("
		puts ".CO({dummyCO\[[expr {3-$r}]:0\]  , carry\[[expr {$P-1}]:[expr {$q*4}]\]}),"
		puts ".O ({dummySO\[[expr {3-$r}]:0\]  , sum\[[expr {$P-1}]:[expr {$q*4}]\]}),"
		puts ".CI(carry\[[expr {$q*4-1}]\]),"
		puts ".CYINIT(),"
		puts ".DI({dummyDI\[[expr {3-$r}]:0\], A\[[expr {$P-1}]:[expr {$q*4}]\]}),"
		puts ".S ({dummyS\[[expr {3-$r}]:0\] , Propagate\[[expr {$P-1}]:[expr {$q*4}]\]})"
		puts ");\n"
	}
}

puts "assign Cout=carry\[$P-1\];\n"

puts "endmodule"
