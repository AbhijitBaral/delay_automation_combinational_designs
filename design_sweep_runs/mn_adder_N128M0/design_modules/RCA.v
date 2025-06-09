`timescale 1ns / 1ps
module RCA #(parameter M=0, K=128)(
	input [-1:0]A,B,
	input Cin,
	output [-1:0]sum,
	output Cout
	);

wire [0-1:0]Propagate;
wire [0-1:0]carry;

wire [2:0] dummyDI ,dummySO, dummyCO, dummyS;

assign Cout=carry[0-1];

endmodule
