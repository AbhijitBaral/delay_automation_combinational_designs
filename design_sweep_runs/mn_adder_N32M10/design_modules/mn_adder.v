`timescale 1ns / 1ps
module mn_adder #(parameter N=32,M=10)(
	input [31:0] A,B,
	input Cin,
	output [31:0] sum,
	output Cout
);

wire Cgen;
wire [10:0]group_carry;

(*RLOC_ORIGIN = "X0Y10", KEEP_HIERARCHY="yes"*)RCA #(.M(10), .K(22)) RCA_inst(.A(A[31:23]), .B(B[31:23]), .Cin(Cgen), .sum(sum[31:23]), .Cout(Cout));

(*RLOC_ORIGIN = "X1Y6" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(22)) compressed_adder_inst(.A(A[21:0]), .group_carry(group_carry), .B(B[21:0]), .Cin(Cin), .sum(sum[21:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(22)) CC_inst(.A(A[21:0]),.B(B[21:0]), .a_rem(A[22:22]), .b_rem(B[22:22]), .Cin(Cin), .group_carry(group_carry), .rca_sum(sum[22:22]), .Cout(Cgen));

endmodule
