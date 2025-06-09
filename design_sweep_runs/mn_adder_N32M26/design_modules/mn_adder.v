`timescale 1ns / 1ps
module mn_adder #(parameter N=32,M=26)(
	input [31:0] A,B,
	input Cin,
	output [31:0] sum,
	output Cout
);

wire Cgen;
wire [2:0]group_carry;

(*RLOC_ORIGIN = "X0Y8", KEEP_HIERARCHY="yes"*)RCA #(.M(26), .K(6)) RCA_inst(.A(A[31:7]), .B(B[31:7]), .Cin(Cgen), .sum(sum[31:7]), .Cout(Cout));

(*RLOC_ORIGIN = "X1Y6" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(6)) compressed_adder_inst(.A(A[5:0]), .group_carry(group_carry), .B(B[5:0]), .Cin(Cin), .sum(sum[5:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(6)) CC_inst(.A(A[5:0]),.B(B[5:0]), .a_rem(A[6:6]), .b_rem(B[6:6]), .Cin(Cin), .group_carry(group_carry), .rca_sum(sum[6:6]), .Cout(Cgen));

endmodule
