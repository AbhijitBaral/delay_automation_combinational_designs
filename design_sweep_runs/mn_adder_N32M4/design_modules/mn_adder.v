`timescale 1ns / 1ps
module mn_adder #(parameter N=32,M=4)(
	input [31:0] A,B,
	input Cin,
	output [31:0] sum,
	output Cout
);

wire Cgen;
wire [13:0]group_carry;

(*RLOC_ORIGIN = "X0Y11", KEEP_HIERARCHY="yes"*)RCA #(.M(4), .K(28)) RCA_inst(.A(A[31:30]), .B(B[31:30]), .Cin(Cgen), .sum(sum[31:30]), .Cout(Cout));

(*RLOC_ORIGIN = "X1Y6" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(28)) compressed_adder_inst(.A(A[27:0]), .group_carry(group_carry), .B(B[27:0]), .Cin(Cin), .sum(sum[27:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(28)) CC_inst(.A(A[27:0]),.B(B[27:0]), .a_rem(A[29:28]), .b_rem(B[29:28]), .Cin(Cin), .group_carry(group_carry), .rca_sum(sum[29:28]), .Cout(Cgen));

endmodule
