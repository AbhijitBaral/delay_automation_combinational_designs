`timescale 1ns / 1ps
module mn_adder #(parameter N=16,M=16)(
	input [15:0] A,B,
	input Cin,
	output [15:0] sum,
	output Cout
);

wire Cgen;
wire [-1:0]group_carry;

(*RLOC_ORIGIN = "X0Y7", KEEP_HIERARCHY="yes"*)RCA #(.M(16), .K(0)) RCA_inst(.A(A[15:0]), .B(B[15:0]), .Cin(Cgen), .sum(sum[15:0]), .Cout(Cout));

endmodule
