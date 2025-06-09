`timescale 1ns / 1ps
module RCA #(parameter M=14, K=18)(
	input [10:0]A,B,
	input Cin,
	output [10:0]sum,
	output Cout
	);

wire [11-1:0]Propagate;
wire [11-1:0]carry;

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

(*RLOC = "X0Y0"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_6(
.O(Propagate[3]),
.I0(A[3]),
.I1(B[3]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y1"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_7(
.O(Propagate[4]),
.I0(A[4]),
.I1(B[4]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y1"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_8(
.O(Propagate[5]),
.I0(A[5]),
.I1(B[5]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y1"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_9(
.O(Propagate[6]),
.I0(A[6]),
.I1(B[6]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y1"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_10(
.O(Propagate[7]),
.I0(A[7]),
.I1(B[7]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y2"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_11(
.O(Propagate[8]),
.I0(A[8]),
.I1(B[8]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y2"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_12(
.O(Propagate[9]),
.I0(A[9]),
.I1(B[9]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y2"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_13(
.O(Propagate[10]),
.I0(A[10]),
.I1(B[10]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y0"*)CARRY4 RCA_CARRY4_0(
.CO(carry[3:0]),
.O(sum[3:0]),
.CI(Cin),
.CYINIT(),
.DI(A[3:0]),
.S(Propagate[3:0])
);

(*RLOC = "X0Y1"*)CARRY4 RCA_CARRY4_1(
.CO(carry[7:4]),
.O(sum[7:4]),
.CI(carry[3]),
.CYINIT(),
.DI(A[7:4]),
.S(Propagate[7:4])
);

wire [2:0] dummyDI ,dummySO, dummyCO, dummyS;

(*RLOC = "X0Y2"*)CARRY4 RCA_CARRY4_2(
.CO({dummyCO[0:0]  , carry[10:8]}),
.O ({dummySO[0:0]  , sum[10:8]}),
.CI(carry[7]),
.CYINIT(),
.DI({dummyDI[0:0], A[10:8]}),
.S ({dummyS[0:0] , Propagate[10:8]})
);

assign Cout=carry[11-1];

endmodule
