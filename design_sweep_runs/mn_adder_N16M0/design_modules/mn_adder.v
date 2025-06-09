`timescale 1ns / 1ps
module mn_adder #(parameter N=16,M=0)(
	input [15:0] A,B,
	input Cin,
	output [15:0] sum,
	output Cout
);

wire Cgen;
wire [7:0]group_carry;

(*RLOC_ORIGIN = "X1Y6" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(16)) compressed_adder_inst(.A(A[15:0]), .group_carry(group_carry), .B(B[15:0]), .Cin(Cin), .sum(sum[15:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(16)) CC_inst(.A(A[15:0]),.B(B[15:0]), .a_rem(), .b_rem(), .Cin(Cin), .group_carry(group_carry), .rca_sum(), .Cout(Cgen));

endmodule
