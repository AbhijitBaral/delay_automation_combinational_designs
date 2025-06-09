`timescale 1ns / 1ps
module mn_adder #(parameter N=32,M=20)(
	input [31:0] A,B,
	input Cin,
	output [31:0] sum,
	output Cout
);

wire Cgen;
wire [5:0]group_carry;

(*RLOC_ORIGIN = "X0Y9", KEEP_HIERARCHY="yes"*)RCA #(.M(20), .K(12)) RCA_inst(.A(A[31:14]), .B(B[31:14]), .Cin(Cgen), .sum(sum[31:14]), .Cout(Cout));

(*RLOC_ORIGIN = "X1Y6" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(12)) compressed_adder_inst(.A(A[11:0]), .group_carry(group_carry), .B(B[11:0]), .Cin(Cin), .sum(sum[11:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(12)) CC_inst(.A(A[11:0]),.B(B[11:0]), .a_rem(A[13:12]), .b_rem(B[13:12]), .Cin(Cin), .group_carry(group_carry), .rca_sum(sum[13:12]), .Cout(Cgen));

endmodule
