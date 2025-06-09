`timescale 1ns / 1ps
module mn_adder #(parameter N=32,M=22)(
	input [31:0] A,B,
	input Cin,
	output [31:0] sum,
	output Cout
);

wire Cgen;
wire [4:0]group_carry;

(*RLOC_ORIGIN = "X0Y9", KEEP_HIERARCHY="yes"*)RCA #(.M(22), .K(10)) RCA_inst(.A(A[31:13]), .B(B[31:13]), .Cin(Cgen), .sum(sum[31:13]), .Cout(Cout));

(*RLOC_ORIGIN = "X1Y6" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(10)) compressed_adder_inst(.A(A[9:0]), .group_carry(group_carry), .B(B[9:0]), .Cin(Cin), .sum(sum[9:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(10)) CC_inst(.A(A[9:0]),.B(B[9:0]), .a_rem(A[12:10]), .b_rem(B[12:10]), .Cin(Cin), .group_carry(group_carry), .rca_sum(sum[12:10]), .Cout(Cgen));

endmodule
