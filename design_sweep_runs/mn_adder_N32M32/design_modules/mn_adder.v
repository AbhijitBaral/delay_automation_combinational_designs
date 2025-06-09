`timescale 1ns / 1ps
module mn_adder #(parameter N=32,M=32)(
	input [31:0] A,B,
	input Cin,
	output [31:0] sum,
	output Cout
);

wire Cgen;
wire [-1:0]group_carry;

(*RLOC_ORIGIN = "X0Y7", KEEP_HIERARCHY="yes"*)RCA #(.M(32), .K(0)) RCA_inst(.A(A[31:0]), .B(B[31:0]), .Cin(Cgen), .sum(sum[31:0]), .Cout(Cout));

endmodule
