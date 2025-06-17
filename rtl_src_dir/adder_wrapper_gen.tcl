set gen_dump ""
set N $param_N
set M $param_M
set K [expr {$N-$M}];

append gen_dump "\n// wrapper module of adder for delay calculation"

append gen_dump "\n`timescale 1ns / 1ps"
append gen_dump "\nmodule mn_adder_wrapper #(parameter N=$N, M=$M)("
append gen_dump "\n    input \[[expr {$N-1}]:0\]A,B,"
append gen_dump "\n    input Cin, clk, rst,"
append gen_dump "\n    output \[[expr {$N-1}]:0\] sum,"
append gen_dump "\n    output Cout"
append gen_dump "\n    );\n"

append gen_dump "\n    reg in_reg, out_reg_fa, out_reg_So;"
append gen_dump "\n    wire driver_fa, driver_So;"

if {$M == 0 } {
	append gen_dump "\n    mn_adder #(.N(${N}), .M(${M}))adder_inst(.A({A\[[expr {$N-1}]:1\], in_reg}), .B(B), .Cin(Cin), .sum({driver_So, sum\[[expr {$K-2}]:0\]}), .Cout(Cout));\n"
} elseif {$K == 0} {
	append gen_dump "\n    mn_adder #(.N(${N}), .M(${M}))adder_inst(.A({A\[[expr {$N-1}]:1\], in_reg}), .B(B), .Cin(Cin), .sum({driver_fa, sum\[[expr {$M-2}]:0\]}), .Cout(Cout));\n"
} else {
	append gen_dump "\n    mn_adder #(.N(${N}), .M(${M}))adder_inst(.A({A\[[expr {$N-1}]:1\], in_reg}), .B(B), .Cin(Cin), .sum({driver_fa, sum\[[expr {$N-2}]:[expr {$K}]\], driver_So, sum\[[expr {$K-2}]:0\]}), .Cout(Cout));\n"
}

append gen_dump "\n    always @(posedge clk) begin"
append gen_dump "\n        if (rst) begin"
if {$M == 0} {
	append gen_dump "\n	    out_reg_So <= 1'b0;"
} elseif {$K == 0} {
	append gen_dump "\n	    out_reg_fa <= 1'b0;"
} else {
	append gen_dump "\n      out_reg_fa <= 1'b0;"
	append gen_dump "\n	    out_reg_So <= 1'b0;"
}
append gen_dump "\n            in_reg<= 1'b0;"
append gen_dump "\n        end"
append gen_dump "\n        "
append gen_dump "\n        else begin"
append gen_dump "\n            in_reg<= A\[0\];"
if {$M == 0} {
	append gen_dump "\n	    out_reg_So <= driver_So;"
} elseif {$K == 0} {
	append gen_dump "\n      out_reg_fa <= driver_fa;"
} else {
	append gen_dump "\n       out_reg_fa <= driver_fa;"
	append gen_dump "\n	     out_reg_So <= driver_So;"
}
append gen_dump "\n        end"
append gen_dump "\n    end\n"

if {$M == 0} {
	append gen_dump "\n    assign sum\[[expr {$N-1}]\] = out_reg_So;"
} elseif {$K == 0} {
	append gen_dump "\n    assign sum\[[expr {$N-1}]\] = out_reg_fa;"
} else {
	append gen_dump "\n    assign sum\[[expr {$N-1}]\] = out_reg_fa;"
	append gen_dump "\n    assign sum\[[expr {$K-1}]\] = out_reg_So;\n"
}
append gen_dump "\nendmodule"
