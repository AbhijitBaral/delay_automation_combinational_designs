`timescale 1ns / 1ps
module mn_adder #(parameter N=32,M=6)(
	input [31:0] A,B,
	input Cin,
	output [31:0] sum,
	output Cout
);

wire Cgen;
wire [12:0]group_carry;

(*RLOC_ORIGIN = "X0Y11", KEEP_HIERARCHY="yes"*)RCA #(.M(6), .K(26)) RCA_inst(.A(A[31:29]), .B(B[31:29]), .Cin(Cgen), .sum(sum[31:29]), .Cout(Cout));

(*RLOC_ORIGIN = "X1Y6" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(26)) compressed_adder_inst(.A(A[25:0]), .group_carry(group_carry), .B(B[25:0]), .Cin(Cin), .sum(sum[25:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(26)) CC_inst(.A(A[25:0]),.B(B[25:0]), .a_rem(A[28:26]), .b_rem(B[28:26]), .Cin(Cin), .group_carry(group_carry), .rca_sum(sum[28:26]), .Cout(Cgen));

endmodule
