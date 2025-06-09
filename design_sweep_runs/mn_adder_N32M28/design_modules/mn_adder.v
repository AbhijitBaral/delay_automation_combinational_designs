`timescale 1ns / 1ps
module mn_adder #(parameter N=32,M=28)(
	input [31:0] A,B,
	input Cin,
	output [31:0] sum,
	output Cout
);

wire Cgen;
wire [1:0]group_carry;

(*RLOC_ORIGIN = "X0Y8", KEEP_HIERARCHY="yes"*)RCA #(.M(28), .K(4)) RCA_inst(.A(A[31:6]), .B(B[31:6]), .Cin(Cgen), .sum(sum[31:6]), .Cout(Cout));

(*RLOC_ORIGIN = "X1Y6" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(4)) compressed_adder_inst(.A(A[3:0]), .group_carry(group_carry), .B(B[3:0]), .Cin(Cin), .sum(sum[3:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(4)) CC_inst(.A(A[3:0]),.B(B[3:0]), .a_rem(A[5:4]), .b_rem(B[5:4]), .Cin(Cin), .group_carry(group_carry), .rca_sum(sum[5:4]), .Cout(Cgen));

endmodule
