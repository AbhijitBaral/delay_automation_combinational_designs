`timescale 1ns / 1ps
module fastAdder #(parameter N=32,M=12)(
	input [31:0] A,B,
	input Cin,
	output [31:0] sum,
	output Cout
);

wire Cgen;
wire [9:0]group_carry;

(*RLOC_ORIGIN = "X0Y10", KEEP_HIERARCHY="yes"*)RCA #(.M(12), .K(20)) RCA_inst(.A(A[31:22]), .B(B[31:22]), .Cin(Cgen), .sum(sum[31:22]), .Cout(Cout));

(*RLOC_ORIGIN = "X1Y7" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(20)) compressed_adder_inst(.A(A[19:0]), .group_carry(group_carry), .B(B[19:0]), .Cin(Cin), .sum(sum[19:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(20)) CC_inst(.A(A[19:0]),.B(B[19:0]), .a_rem(A[21:20]), .b_rem(B[21:20]), .Cin(Cin), .group_carry(group_carry), .rca_sum(sum[21:20]), .Cout(Cgen));

endmodule
