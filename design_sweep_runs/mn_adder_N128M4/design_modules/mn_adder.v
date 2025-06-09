`timescale 1ns / 1ps
module mn_adder #(parameter N=128,M=4)(
	input [127:0] A,B,
	input Cin,
	output [127:0] sum,
	output Cout
);

wire Cgen;
wire [61:0]group_carry;

(*RLOC_ORIGIN = "X0Y23", KEEP_HIERARCHY="yes"*)RCA #(.M(4), .K(124)) RCA_inst(.A(A[127:126]), .B(B[127:126]), .Cin(Cgen), .sum(sum[127:126]), .Cout(Cout));

(*RLOC_ORIGIN = "X1Y6" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(124)) compressed_adder_inst(.A(A[123:0]), .group_carry(group_carry), .B(B[123:0]), .Cin(Cin), .sum(sum[123:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(124)) CC_inst(.A(A[123:0]),.B(B[123:0]), .a_rem(A[125:124]), .b_rem(B[125:124]), .Cin(Cin), .group_carry(group_carry), .rca_sum(sum[125:124]), .Cout(Cgen));

endmodule
