`timescale 1ns / 1ps
module mn_adder #(parameter N=16,M=14)(
	input [15:0] A,B,
	input Cin,
	output [15:0] sum,
	output Cout
);

wire Cgen;
wire [0:0]group_carry;

(*RLOC_ORIGIN = "X0Y8", KEEP_HIERARCHY="yes"*)RCA #(.M(14), .K(2)) RCA_inst(.A(A[15:5]), .B(B[15:5]), .Cin(Cgen), .sum(sum[15:5]), .Cout(Cout));

(*RLOC_ORIGIN = "X1Y6" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(2)) compressed_adder_inst(.A(A[1:0]), .group_carry(group_carry), .B(B[1:0]), .Cin(Cin), .sum(sum[1:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(2)) CC_inst(.A(A[1:0]),.B(B[1:0]), .a_rem(A[4:2]), .b_rem(B[4:2]), .Cin(Cin), .group_carry(group_carry), .rca_sum(sum[4:2]), .Cout(Cgen));

endmodule
