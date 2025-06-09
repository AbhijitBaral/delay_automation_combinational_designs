`timescale 1ns / 1ps
module RCA #(parameter M=2, K=14)(
	input [0:0]A,B,
	input Cin,
	output [0:0]sum,
	output Cout
	);

wire [1-1:0]Propagate;
wire [1-1:0]carry;

(*RLOC = "X0Y0"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_1(
.O(Propagate[0]),
.I0(A[0]),
.I1(B[0]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

wire [2:0] dummyDI ,dummySO, dummyCO, dummyS;

(*RLOC = "X0Y0"*)CARRY4 RCA_CARRY4_0(
.CO({dummyCO[2:0]  , carry[0:0]}),
.O ({dummySO[2:0]  , sum[0:0]}),
.CI(Cin),
.CYINIT(),
.DI({dummyDI[2:0], A[0:0]}),
.S ({dummyS[2:0] , Propagate[0:0]})
);

assign Cout=carry[1-1];

endmodule
