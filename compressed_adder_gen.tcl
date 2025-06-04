#set K [lindex $argv 0];
set K 20

puts "`timescale 1ns / 1ps"
puts "module compressed_adder #(parameter K=$K)("
puts "    input \[[expr {$K-1}]:0\] A,B,"
puts "    input \[[expr {$K/2-1}]:0\]group_carry,"
puts "    input Cin,"
puts "    output \[[expr {$K-1}]:0\] sum"
puts "    );\n"

puts "LUT6_2 #(.INIT(64'hE11E877899996666))So_lut_0("
puts ".O6(sum\[1\]),"
puts ".O5(sum\[0\]),"
puts ".I0(A\[0\]),"
puts ".I1(B\[0\]),"
puts ".I2(A\[1\]),"
puts ".I3(B\[1\]),"
puts ".I4(Cin),"
puts ".I5(1'b1)"
puts ");\n"

set y 0;
set count 1;
for {set i 2} {$i <= $K -2} {incr i 2} {
    	set rloc "X0Y$y";
	if {$count == 4} {
		set count 0;
		set y [expr {$y+1}];
	}
	
	puts "(* RLOC = \"$rloc\" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_[expr {$i/2}]("
	puts ".O6(sum\[[expr {$i+1}]\]),"
	puts ".O5(sum\[[expr {$i}]\]),"
	puts ".I0(A\[$i\]),"
	puts ".I1(B\[$i\]),"
	puts ".I2(A\[[expr {$i+1}]\]),"
	puts ".I3(B\[[expr {$i+1}]\]),"
	puts ".I4(group_carry\[[expr {$i/2-1}]\]),"
	puts ".I5(1'b1));\n"

	set count [expr {$count+1}];
}

puts "endmodule"
