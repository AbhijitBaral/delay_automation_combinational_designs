`timescale 1ns / 1ps
module RCA #(parameter M=18, K=14)(
	input [16:0]A,B,
	input Cin,
	output [16:0]sum,
	output Cout
	);

wire [17-1:0]Propagate;
wire [17-1:0]carry;

(*RLOC = "X0Y0"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_1(
.O(Propagate[0]),
.I0(A[0]),
.I1(B[0]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y0"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_2(
.O(Propagate[1]),
.I0(A[1]),
.I1(B[1]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y0"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_3(
.O(Propagate[2]),
.I0(A[2]),
.I1(B[2]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y0"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_4(
.O(Propagate[3]),
.I0(A[3]),
.I1(B[3]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y1"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_5(
.O(Propagate[4]),
.I0(A[4]),
.I1(B[4]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y1"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_6(
.O(Propagate[5]),
.I0(A[5]),
.I1(B[5]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y1"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_7(
.O(Propagate[6]),
.I0(A[6]),
.I1(B[6]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y1"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_8(
.O(Propagate[7]),
.I0(A[7]),
.I1(B[7]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y2"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_9(
.O(Propagate[8]),
.I0(A[8]),
.I1(B[8]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y2"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_10(
.O(Propagate[9]),
.I0(A[9]),
.I1(B[9]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y2"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_11(
.O(Propagate[10]),
.I0(A[10]),
.I1(B[10]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y2"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_12(
.O(Propagate[11]),
.I0(A[11]),
.I1(B[11]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y3"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_13(
.O(Propagate[12]),
.I0(A[12]),
.I1(B[12]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y3"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_14(
.O(Propagate[13]),
.I0(A[13]),
.I1(B[13]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y3"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_15(
.O(Propagate[14]),
.I0(A[14]),
.I1(B[14]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y3"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_16(
.O(Propagate[15]),
.I0(A[15]),
.I1(B[15]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y4"*)LUT6 #(.INIT(64'h0000000000000006))RCA_LUT_17(
.O(Propagate[16]),
.I0(A[16]),
.I1(B[16]),
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

(*RLOC = "X0Y2"*)CARRY4 RCA_CARRY4_2(
.CO(carry[11:8]),
.O(sum[11:8]),
.CI(carry[7]),
.CYINIT(),
.DI(A[11:8]),
.S(Propagate[11:8])
);

(*RLOC = "X0Y3"*)CARRY4 RCA_CARRY4_3(
.CO(carry[15:12]),
.O(sum[15:12]),
.CI(carry[11]),
.CYINIT(),
.DI(A[15:12]),
.S(Propagate[15:12])
);

wire [2:0] dummyDI ,dummySO, dummyCO, dummyS;

(*RLOC = "X0Y4"*)CARRY4 RCA_CARRY4_4(
.CO({dummyCO[2:0]  , carry[16:16]}),
.O ({dummySO[2:0]  , sum[16:16]}),
.CI(carry[15]),
.CYINIT(),
.DI({dummyDI[2:0], A[16:16]}),
.S ({dummyS[2:0] , Propagate[16:16]})
);

assign Cout=carry[17-1];

endmodule
