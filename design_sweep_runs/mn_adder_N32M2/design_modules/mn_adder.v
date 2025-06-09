`timescale 1ns / 1ps
module mn_adder #(parameter N=32,M=2)(
	input [31:0] A,B,
	input Cin,
	output [31:0] sum,
	output Cout
);

wire Cgen;
wire [14:0]group_carry;

(*RLOC_ORIGIN = "X0Y11", KEEP_HIERARCHY="yes"*)RCA #(.M(2), .K(30)) RCA_inst(.A(A[31:31]), .B(B[31:31]), .Cin(Cgen), .sum(sum[31:31]), .Cout(Cout));

(*RLOC_ORIGIN = "X1Y6" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(30)) compressed_adder_inst(.A(A[29:0]), .group_carry(group_carry), .B(B[29:0]), .Cin(Cin), .sum(sum[29:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(30)) CC_inst(.A(A[29:0]),.B(B[29:0]), .a_rem(A[30:30]), .b_rem(B[30:30]), .Cin(Cin), .group_carry(group_carry), .rca_sum(sum[30:30]), .Cout(Cgen));

endmodule
