`timescale 1ns / 1ps
module RCA #(parameter M=4, K=28)(
	input [1:0]A,B,
	input Cin,
	output [1:0]sum,
	output Cout
	);

wire [2-1:0]Propagate;
wire [2-1:0]carry;

(*RLOC = "X0Y0"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_2(
.O(Propagate[0]),
.I0(A[0]),
.I1(B[0]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y0"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_3(
.O(Propagate[1]),
.I0(A[1]),
.I1(B[1]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

wire [2:0] dummyDI ,dummySO, dummyCO, dummyS;

(*RLOC = "X0Y0"*)CARRY4 RCA_CARRY4_0(
.CO({dummyCO[1:0]  , carry[1:0]}),
.O ({dummySO[1:0]  , sum[1:0]}),
.CI(Cin),
.CYINIT(),
.DI({dummyDI[1:0], A[1:0]}),
.S ({dummyS[1:0] , Propagate[1:0]})
);

assign Cout=carry[2-1];

endmodule
