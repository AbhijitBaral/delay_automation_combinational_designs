`timescale 1ns / 1ps
module mn_adder #(parameter N=32,M=14)(
	input [31:0] A,B,
	input Cin,
	output [31:0] sum,
	output Cout
);

wire Cgen;
wire [8:0]group_carry;

(*RLOC_ORIGIN = "X0Y10", KEEP_HIERARCHY="yes"*)RCA #(.M(14), .K(18)) RCA_inst(.A(A[31:21]), .B(B[31:21]), .Cin(Cgen), .sum(sum[31:21]), .Cout(Cout));

(*RLOC_ORIGIN = "X1Y6" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(18)) compressed_adder_inst(.A(A[17:0]), .group_carry(group_carry), .B(B[17:0]), .Cin(Cin), .sum(sum[17:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(18)) CC_inst(.A(A[17:0]),.B(B[17:0]), .a_rem(A[20:18]), .b_rem(B[20:18]), .Cin(Cin), .group_carry(group_carry), .rca_sum(sum[20:18]), .Cout(Cgen));

endmodule
