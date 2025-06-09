`timescale 1ns / 1ps
module RCA #(parameter M=6, K=10)(
	input [2:0]A,B,
	input Cin,
	output [2:0]sum,
	output Cout
	);

wire [3-1:0]Propagate;
wire [3-1:0]carry;

(*RLOC = "X0Y0"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_3(
.O(Propagate[0]),
.I0(A[0]),
.I1(B[0]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y0"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_4(
.O(Propagate[1]),
.I0(A[1]),
.I1(B[1]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y0"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_5(
.O(Propagate[2]),
.I0(A[2]),
.I1(B[2]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

wire [2:0] dummyDI ,dummySO, dummyCO, dummyS;

(*RLOC = "X0Y0"*)CARRY4 RCA_CARRY4_0(
.CO({dummyCO[0:0]  , carry[2:0]}),
.O ({dummySO[0:0]  , sum[2:0]}),
.CI(Cin),
.CYINIT(),
.DI({dummyDI[0:0], A[2:0]}),
.S ({dummyS[0:0] , Propagate[2:0]})
);

assign Cout=carry[3-1];

endmodule
