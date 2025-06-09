set K [lindex $argv 0];
set count 0;
set y 0;

puts "`timescale 1ns / 1ps"
puts "//parameter K has to be an even number"
puts "module carry_compressor #(parameter K=$K)("
puts "    input\[[expr {$K-1}]:0\] A,B,"
puts "    input Cin,"
puts "    //     a\[K+3-((K/2)%4):K\],   b\[K+3-((K/2)%4):K\]"
puts "    input  \[[expr {3-(($K/2)%4)}]:0\]a_rem, b_rem,         //operand bits belonging to the last M bits"
puts "    output \[[expr {3-(($K/2)%4)}]:0\]rca_sum,              //Sum of the \[K+3-((K/2)%4:K)\] stages of addition"
puts "    output \[[expr {$K/2-1}]:0\]group_carry,"
puts "    output Cout"
puts "    );\n"
    
    
puts "//--------------------------------------------------------------"
puts "wire \[[expr {$K/2-1}]:0\]group_propagate, group_generate;"
puts "//--------------------------------------------------------------\n"

for {set k 0 } {$k <= $K-1} {incr k} {
	set rloc "X0Y$y";
	if {$count == 4} {
		set count 0;
		set y [expr {$y+1}];
	}

	if {[expr {$k%2}] == 0} {
		puts "(*RLOC=\"$rloc\"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut${k}("
		puts ".O6(group_propagate\[[expr {$k/2}]\]),"
		puts ".O5(group_generate\[[expr {$k/2}]\]),"
		puts ".I0(A\[$k\]),"
		puts ".I1(B\[$k\]),"
		puts ".I2(A\[[expr {$k+1}]\]),"
		puts ".I3(B\[[expr {$k+1}]\]),"
		puts ".I4(1'b0),"
		puts ".I5(1'b1)"
		puts ");\n"
		
		set count [expr {$count+1}];
	}
}

set q [expr {($K/2)/4}]
set r [expr {($K/2)%4}]

for {set l 0} {$l <= $q-1} {incr l} {
       	if {$l==0} {
		puts "(*RLOC = \"X0Y0\"*)CARRY4 CC_carry4_0("
		puts ".CO(group_carry\[3:0\]),"
		puts ".O(),"
		puts ".CI(),"
		puts ".CYINIT(Cin),"
		puts ".DI(group_generate\[3:0\]),"
		puts ".S(group_propagate\[3:0\])"
		puts ");\n"
	} else {
		puts "(*RLOC = \"X0Y$l\"*)CARRY4 CC_carry4_${l}("
	        puts ".CO(group_carry\[[expr {4*$l+3}]:[expr {4*$l}]\]),"
		puts ".O(),"
		puts ".CI(group_carry\[[expr {4*$l-1}]\]),"
		puts ".CYINIT(),"
		puts ".DI(group_generate\[[expr {4*$l+3}]:[expr {4*$l}]\]),"
		puts ".S(group_propagate\[[expr {4*$l+3}]:[expr {4*$l}]\])"
		puts ");\n"
	}
}
  
set y_rem "X0Y0";
puts "//last carry4 or first&Last carry4"
if {$r>0} {
	 puts "//For K=2"
	 if {$K==2} {
		puts "(*RLOC = \"$y_rem\"*)CARRY4 CC_carry_chain_last("
     	   	puts ".CO({dummyCO\[2:1\] ,dummyCO_fl ,dummyCO_K2}),"
     	   	puts ".O({rca_sum\[2:0\],dummySO\[0\]}),"
     	   	puts ".CI(),"
     	   	puts ".CYINIT(Cin),"
     	   	puts ".DI({rca_gen\[2:0\],group_generate \[0\]}),"
     	   	puts ".S ({rca_prp\[2:0\],group_propagate\[0\]})"
     	   	puts ");\n"
	} elseif {$K<8} {
	       	puts "(*RLOC = \"$y_rem\"*)CARRY4 CC_carry_chain_last("
     	   	puts ".CO({dummyCO\[[expr {3-$r}]:0\] ,group_carry\[[expr {$K/2-1}]:0\]}),"
     	   	puts ".O ({rca_sum\[[expr {3-$r}]:0\] ,dummySO\[[expr {$r-1}]:0\]}),"
     	   	puts ".CI(),"
     	   	puts ".CYINIT(Cin),"
     	   	puts ".DI({rca_gen\[[expr {3-$r}]:0\],group_generate \[[expr {$K/2-1}]:0\]}),"
     	   	puts ".S ({rca_prp\[[expr {3-$r}]:0\],group_propagate\[[expr {$K/2-1}]:0\]})"
     	   	puts ");\n"
	} else {
		set y_rem "X0Y$q"
     	   	puts "(*RLOC = \"$y_rem\"*) CARRY4 CC_carry_chain_last("
     	   	puts ".CO({dummyCO\[[expr {3-$r}]:0\] , group_carry\[[expr {$K/2-1}]:[expr {$q*4}]\]}),"
     	   	puts ".O ({rca_sum\[[expr {3-$r}]:0\] , dummySO\[[expr {$r-1}]:0\]}),"
     	   	puts ".CI(group_carry\[[expr {$q*4-1}]\]),"
     	   	puts ".CYINIT(),"
     	   	puts ".DI({rca_gen\[[expr {3-$r}]:0\] , group_generate \[[expr {$K/2-1}]:[expr {$q*4}]\]}),"
     	   	puts ".S ({rca_prp\[[expr {3-$r}]:0\] , group_propagate\[[expr {$K/2-1}]:[expr {$q*4}]\]})"
     	   	puts ");\n"
	}
}
 
puts "wire \[3:0\]dummyCO, dummyS, dummyDI, dummySO;"
puts "wire dummyCO_fl, dummyCO_K2;    //dummy wire for a CO for K<8 and K=2"

puts "//Propagate and Generate for RCA LUTs"
puts "wire \[[expr {3-$r}]:0\]rca_prp, rca_gen;"
puts "assign rca_gen = a_rem;\n"

  
              	
if {$r>0} {
	for {set m 0} {$m <= 3-$r} {incr m} {
		puts "(*RLOC = \"$y_rem\"*) LUT6 #(.INIT(64'h0000000000000006))RCA_lut_${m}("
		puts ".O(rca_prp\[$m\]),"
		puts ".I0(a_rem\[$m\]),"
		puts ".I1(b_rem\[$m\]),"
		puts ".I2(1'b0),"
		puts ".I3(1'b0),"
		puts ".I4(1'b0),"
		puts ".I5(1'b0)"
		puts ");\n"
	}
}

if {$r >0} {
	puts "assign Cout = dummyCO\[[expr {3-$r}]\];\n"
} else {
	puts "assign Cout = group_carry\[[expr {$K/2-1}]\];\n"
}

puts "endmodule"
