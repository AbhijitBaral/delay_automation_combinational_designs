set gen_dump ""
set N $param_N
set M $param_M
set K [expr {$N-$M}]
set count 0;
set y 0;

append gen_dump "`timescale 1ns / 1ps"
append gen_dump "\n//parameter K has to be an even number"
append gen_dump "\nmodule carry_compressor #(parameter K=$K)("
append gen_dump "\n    input\[[expr {$K-1}]:0\] A,B,"
append gen_dump "\n    input Cin,"
append gen_dump "\n    //     a\[K+3-((K/2)%4):K\],   b\[K+3-((K/2)%4):K\]"
append gen_dump "\n    input  \[[expr {3-(($K/2)%4)}]:0\]a_rem, b_rem,         //operand bits belonging to the last M bits"
append gen_dump "\n    output \[[expr {3-(($K/2)%4)}]:0\]rca_sum,              //Sum of the \[K+3-((K/2)%4:K)\] stages of addition"
append gen_dump "\n    output \[[expr {$K/2-1}]:0\]group_carry,"
append gen_dump "\n    output Cout"
append gen_dump "\n    );\n"
    
    
append gen_dump "\n//--------------------------------------------------------------"
append gen_dump "\nwire \[[expr {$K/2-1}]:0\]group_propagate, group_generate;"
append gen_dump "\n//--------------------------------------------------------------\n"

for {set k 0 } {$k <= $K-1} {incr k} {
	set rloc "X0Y$y";
	if {$count == 4} {
		set count 0;
		set y [expr {$y+1}];
	}

	if {[expr {$k%2}] == 0} {
		append gen_dump "\n(*RLOC=\"$rloc\"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut${k}("
		append gen_dump "\n.O6(group_propagate\[[expr {$k/2}]\]),"
		append gen_dump "\n.O5(group_generate\[[expr {$k/2}]\]),"
		append gen_dump "\n.I0(A\[$k\]),"
		append gen_dump "\n.I1(B\[$k\]),"
		append gen_dump "\n.I2(A\[[expr {$k+1}]\]),"
		append gen_dump "\n.I3(B\[[expr {$k+1}]\]),"
		append gen_dump "\n.I4(1'b0),"
		append gen_dump "\n.I5(1'b1)"
		append gen_dump "\n);\n"
		
		set count [expr {$count+1}];
	}
}

set q [expr {($K/2)/4}]
set r [expr {($K/2)%4}]

for {set l 0} {$l <= $q-1} {incr l} {
       	if {$l==0} {
		append gen_dump "\n(*RLOC = \"X0Y0\"*)CARRY4 CC_carry4_0("
		append gen_dump "\n.CO(group_carry\[3:0\]),"
		append gen_dump "\n.O(),"
		append gen_dump "\n.CI(),"
		append gen_dump "\n.CYINIT(Cin),"
		append gen_dump "\n.DI(group_generate\[3:0\]),"
		append gen_dump "\n.S(group_propagate\[3:0\])"
		append gen_dump "\n);\n"
	} else {
		append gen_dump "\n(*RLOC = \"X0Y$l\"*)CARRY4 CC_carry4_${l}("
	        append gen_dump "\n.CO(group_carry\[[expr {4*$l+3}]:[expr {4*$l}]\]),"
		append gen_dump "\n.O(),"
		append gen_dump "\n.CI(group_carry\[[expr {4*$l-1}]\]),"
		append gen_dump "\n.CYINIT(),"
		append gen_dump "\n.DI(group_generate\[[expr {4*$l+3}]:[expr {4*$l}]\]),"
		append gen_dump "\n.S(group_propagate\[[expr {4*$l+3}]:[expr {4*$l}]\])"
		append gen_dump "\n);\n"
	}
}
  
set y_rem "X0Y0";
append gen_dump "//last carry4 or first&Last carry4"
if {$r>0} {
	 append gen_dump "//For K=2"
	 if {$K==2} {
		append gen_dump "\n(*RLOC = \"$y_rem\"*)CARRY4 CC_carry_chain_last("
     	   	append gen_dump "\n.CO({dummyCO\[2:1\] ,dummyCO_fl ,dummyCO_K2}),"
     	   	append gen_dump "\n.O({rca_sum\[2:0\],dummySO\[0\]}),"
     	   	append gen_dump "\n.CI(),"
     	   	append gen_dump "\n.CYINIT(Cin),"
     	   	append gen_dump "\n.DI({rca_gen\[2:0\],group_generate \[0\]}),"
     	   	append gen_dump "\n.S ({rca_prp\[2:0\],group_propagate\[0\]})"
     	   	append gen_dump "\n);\n"
	} elseif {$K<8} {
	       	append gen_dump "\n(*RLOC = \"$y_rem\"*)CARRY4 CC_carry_chain_last("
     	   	append gen_dump "\n.CO({dummyCO\[[expr {3-$r}]:0\] ,group_carry\[[expr {$K/2-1}]:0\]}),"
     	   	append gen_dump "\n.O ({rca_sum\[[expr {3-$r}]:0\] ,dummySO\[[expr {$r-1}]:0\]}),"
     	   	append gen_dump "\n.CI(),"
     	   	append gen_dump "\n.CYINIT(Cin),"
     	   	append gen_dump "\n.DI({rca_gen\[[expr {3-$r}]:0\],group_generate \[[expr {$K/2-1}]:0\]}),"
     	   	append gen_dump "\n.S ({rca_prp\[[expr {3-$r}]:0\],group_propagate\[[expr {$K/2-1}]:0\]})"
     	   	append gen_dump "\n);\n"
	} else {
		set y_rem "X0Y$q"
     	   	append gen_dump "\n(*RLOC = \"$y_rem\"*) CARRY4 CC_carry_chain_last("
     	   	append gen_dump "\n.CO({dummyCO\[[expr {3-$r}]:0\] , group_carry\[[expr {$K/2-1}]:[expr {$q*4}]\]}),"
     	   	append gen_dump "\n.O ({rca_sum\[[expr {3-$r}]:0\] , dummySO\[[expr {$r-1}]:0\]}),"
     	   	append gen_dump "\n.CI(group_carry\[[expr {$q*4-1}]\]),"
     	   	append gen_dump "\n.CYINIT(),"
     	   	append gen_dump "\n.DI({rca_gen\[[expr {3-$r}]:0\] , group_generate \[[expr {$K/2-1}]:[expr {$q*4}]\]}),"
     	   	append gen_dump "\n.S ({rca_prp\[[expr {3-$r}]:0\] , group_propagate\[[expr {$K/2-1}]:[expr {$q*4}]\]})"
     	   	append gen_dump "\n);\n"
	}
}
 
append gen_dump "\nwire \[3:0\]dummyCO, dummyS, dummyDI, dummySO;"
append gen_dump "\nwire dummyCO_fl, dummyCO_K2;    //dummy wire for a CO for K<8 and K=2"

append gen_dump "\n//Propagate and Generate for RCA LUTs"
append gen_dump "\nwire \[[expr {3-$r}]:0\]rca_prp, rca_gen;"
append gen_dump "\nassign rca_gen = a_rem;\n"

  
              	
if {$r>0} {
	for {set m 0} {$m <= 3-$r} {incr m} {
		append gen_dump "\n(*RLOC = \"$y_rem\"*) LUT6 #(.INIT(64'h0000000000000006))RCA_lut_${m}("
		append gen_dump "\n.O(rca_prp\[$m\]),"
		append gen_dump "\n.I0(a_rem\[$m\]),"
		append gen_dump "\n.I1(b_rem\[$m\]),"
		append gen_dump "\n.I2(1'b0),"
		append gen_dump "\n.I3(1'b0),"
		append gen_dump "\n.I4(1'b0),"
		append gen_dump "\n.I5(1'b0)"
		append gen_dump "\n);\n"
	}
}

if {$r >0} {
	append gen_dump "\nassign Cout = dummyCO\[[expr {3-$r}]\];\n"
} else {
	append gen_dump "\nassign Cout = group_carry\[[expr {$K/2-1}]\];\n"
}

append gen_dump "endmodule"
