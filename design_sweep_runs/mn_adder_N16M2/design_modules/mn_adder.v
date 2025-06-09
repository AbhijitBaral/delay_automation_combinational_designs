`timescale 1ns / 1ps
module mn_adder #(parameter N=16,M=2)(
	input [15:0] A,B,
	input Cin,
	output [15:0] sum,
	output Cout
);

wire Cgen;
wire [6:0]group_carry;

(*RLOC_ORIGIN = "X0Y9", KEEP_HIERARCHY="yes"*)RCA #(.M(2), .K(14)) RCA_inst(.A(A[15:15]), .B(B[15:15]), .Cin(Cgen), .sum(sum[15:15]), .Cout(Cout));

(*RLOC_ORIGIN = "X1Y6" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(14)) compressed_adder_inst(.A(A[13:0]), .group_carry(group_carry), .B(B[13:0]), .Cin(Cin), .sum(sum[13:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(14)) CC_inst(.A(A[13:0]),.B(B[13:0]), .a_rem(A[14:14]), .b_rem(B[14:14]), .Cin(Cin), .group_carry(group_carry), .rca_sum(sum[14:14]), .Cout(Cgen));

endmodule
