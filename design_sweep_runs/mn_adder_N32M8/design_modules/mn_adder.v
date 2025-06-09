`timescale 1ns / 1ps
module mn_adder #(parameter N=32,M=8)(
	input [31:0] A,B,
	input Cin,
	output [31:0] sum,
	output Cout
);

wire Cgen;
wire [11:0]group_carry;

(*RLOC_ORIGIN = "X0Y10", KEEP_HIERARCHY="yes"*)RCA #(.M(8), .K(24)) RCA_inst(.A(A[31:24]), .B(B[31:24]), .Cin(Cgen), .sum(sum[31:24]), .Cout(Cout));

(*RLOC_ORIGIN = "X1Y6" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(24)) compressed_adder_inst(.A(A[23:0]), .group_carry(group_carry), .B(B[23:0]), .Cin(Cin), .sum(sum[23:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(24)) CC_inst(.A(A[23:0]),.B(B[23:0]), .a_rem(), .b_rem(), .Cin(Cin), .group_carry(group_carry), .rca_sum(), .Cout(Cgen));

endmodule
