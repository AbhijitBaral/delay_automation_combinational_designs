`timescale 1ns / 1ps
module mn_adder #(parameter N=32,M=24)(
	input [31:0] A,B,
	input Cin,
	output [31:0] sum,
	output Cout
);

wire Cgen;
wire [3:0]group_carry;

(*RLOC_ORIGIN = "X0Y8", KEEP_HIERARCHY="yes"*)RCA #(.M(24), .K(8)) RCA_inst(.A(A[31:8]), .B(B[31:8]), .Cin(Cgen), .sum(sum[31:8]), .Cout(Cout));

(*RLOC_ORIGIN = "X1Y6" , KEEP_HIERARCHY="yes"*)compressed_adder #(.K(8)) compressed_adder_inst(.A(A[7:0]), .group_carry(group_carry), .B(B[7:0]), .Cin(Cin), .sum(sum[7:0]));

(*RLOC_ORIGIN = "X0Y7" , KEEP_HIERARCHY="yes"*)carry_compressor #(.K(8)) CC_inst(.A(A[7:0]),.B(B[7:0]), .a_rem(), .b_rem(), .Cin(Cin), .group_carry(group_carry), .rca_sum(), .Cout(Cgen));

endmodule
