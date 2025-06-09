`timescale 1ns / 1ps
module mn_adder #(parameter N=128,M=2)(
	input [127:0] A,B,
	input Cin,
	output [127:0] sum,
	output Cout
);

wire Cgen;
wire [62:0]group_carry;

(*RLOC_ORIGIN = "X0Y23", KEEP_HIERARCHY="yes"*)RCA #(.M(2), .K(126)) RCA_inst(.A(A[127:127]), .B(B[127:127]), .Cin(Cgen), .sum(sum[127:127]), .Cout(Cout));

(*RLOC_ORIGIN = "X1Y6" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(126)) compressed_adder_inst(.A(A[125:0]), .group_carry(group_carry), .B(B[125:0]), .Cin(Cin), .sum(sum[125:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(126)) CC_inst(.A(A[125:0]),.B(B[125:0]), .a_rem(A[126:126]), .b_rem(B[126:126]), .Cin(Cin), .group_carry(group_carry), .rca_sum(sum[126:126]), .Cout(Cgen));

endmodule
