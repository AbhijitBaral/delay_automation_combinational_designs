set N [lindex $argv 0];
set M [lindex $argv 1];
set K [expr {$N-$M}];

puts "// wrapper module of adder for delay calculation"

puts "`timescale 1ns / 1ps"
puts "module mn_adder_wrapper #(parameter N=$N, M=$M)("
puts "    input \[[expr {$N-1}]:0\]A,B,"
puts "    input Cin, clk, rst,"
puts "    output \[[expr {$N-1}]:0\] sum,"
puts "    output Cout"
puts "    );\n"

puts "    reg in_reg, out_reg_fa, out_reg_So;"
puts "    wire driver_fa, driver_So;"

if {$M == 0 } {
	puts "    mn_adder #(.N(${N}), .M(${M}))adder_inst(.A({A\[[expr {$N-1}]:1\], in_reg}), .B(B), .Cin(Cin), .sum({driver_So, sum\[[expr {$K-2}]:0\]}), .Cout(Cout));\n"
} elseif {$K == 0} {
	puts "    mn_adder #(.N(${N}), .M(${M}))adder_inst(.A({A\[[expr {$N-1}]:1\], in_reg}), .B(B), .Cin(Cin), .sum({driver_fa, sum\[[expr {$M-2}]:0\]}), .Cout(Cout));\n"
} else {
	puts "    mn_adder #(.N(${N}), .M(${M}))adder_inst(.A({A\[[expr {$N-1}]:1\], in_reg}), .B(B), .Cin(Cin), .sum({driver_fa, sum\[[expr {$N-2}]:[expr {$K}]\], driver_So, sum\[[expr {$K-2}]:0\]}), .Cout(Cout));\n"
}

puts "    always @(posedge clk) begin"
puts "        if (rst) begin"
if {$M == 0} {
	puts "	    out_reg_So <= 1'b0;"
} elseif {$K == 0} {
	puts "	    out_reg_fa <= 1'b0;"
} else {
	puts "      out_reg_fa <= 1'b0;"
	puts "	    out_reg_So <= 1'b0;"
}
puts "            in_reg<= 1'b0;"
puts "        end"
puts "        "
puts "        else begin"
puts "            in_reg<= A\[0\];"
if {$M == 0} {
	puts "	    out_reg_So <= driver_So;"
} elseif {$K == 0} {
	puts "      out_reg_fa <= driver_fa;"
} else {
	puts "       out_reg_fa <= driver_fa;"
	puts "	     out_reg_So <= driver_So;"
}
puts "        end"
puts "    end\n"

if {$M == 0} {
	puts "    assign sum\[[expr {$N-1}]\] = out_reg_So;"
} elseif {$K == 0} {
	puts "    assign sum\[[expr {$N-1}]\] = out_reg_fa;"
} else {
	puts "    assign sum\[[expr {$N-1}]\] = out_reg_fa;"
	puts "    assign sum\[[expr {$K-1}]\] = out_reg_So;\n"
}
puts "endmodule"
