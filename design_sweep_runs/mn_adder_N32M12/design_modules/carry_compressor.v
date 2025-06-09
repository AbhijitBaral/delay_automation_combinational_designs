`timescale 1ns / 1ps
//parameter K has to be an even number
module carry_compressor #(parameter K=20)(
    input[19:0] A,B,
    input Cin,
    //     a[K+3-((K/2)%4):K],   b[K+3-((K/2)%4):K]
    input  [1:0]a_rem, b_rem,         //operand bits belonging to the last M bits
    output [1:0]rca_sum,              //Sum of the [K+3-((K/2)%4:K)] stages of addition
    output [9:0]group_carry,
    output Cout
    );

//--------------------------------------------------------------
wire [9:0]group_propagate, group_generate;
//--------------------------------------------------------------

(*RLOC="X0Y0"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut0(
.O6(group_propagate[0]),
.O5(group_generate[0]),
.I0(A[0]),
.I1(B[0]),
.I2(A[1]),
.I3(B[1]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y0"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut2(
.O6(group_propagate[1]),
.O5(group_generate[1]),
.I0(A[2]),
.I1(B[2]),
.I2(A[3]),
.I3(B[3]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y0"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut4(
.O6(group_propagate[2]),
.O5(group_generate[2]),
.I0(A[4]),
.I1(B[4]),
.I2(A[5]),
.I3(B[5]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y0"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut6(
.O6(group_propagate[3]),
.O5(group_generate[3]),
.I0(A[6]),
.I1(B[6]),
.I2(A[7]),
.I3(B[7]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y1"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut8(
.O6(group_propagate[4]),
.O5(group_generate[4]),
.I0(A[8]),
.I1(B[8]),
.I2(A[9]),
.I3(B[9]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y1"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut10(
.O6(group_propagate[5]),
.O5(group_generate[5]),
.I0(A[10]),
.I1(B[10]),
.I2(A[11]),
.I3(B[11]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y1"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut12(
.O6(group_propagate[6]),
.O5(group_generate[6]),
.I0(A[12]),
.I1(B[12]),
.I2(A[13]),
.I3(B[13]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y1"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut14(
.O6(group_propagate[7]),
.O5(group_generate[7]),
.I0(A[14]),
.I1(B[14]),
.I2(A[15]),
.I3(B[15]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y2"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut16(
.O6(group_propagate[8]),
.O5(group_generate[8]),
.I0(A[16]),
.I1(B[16]),
.I2(A[17]),
.I3(B[17]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y2"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut18(
.O6(group_propagate[9]),
.O5(group_generate[9]),
.I0(A[18]),
.I1(B[18]),
.I2(A[19]),
.I3(B[19]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC = "X0Y0"*)CARRY4 CC_carry4_0(
.CO(group_carry[3:0]),
.O(),
.CI(),
.CYINIT(Cin),
.DI(group_generate[3:0]),
.S(group_propagate[3:0])
);

(*RLOC = "X0Y1"*)CARRY4 CC_carry4_1(
.CO(group_carry[7:4]),
.O(),
.CI(group_carry[3]),
.CYINIT(),
.DI(group_generate[7:4]),
.S(group_propagate[7:4])
);

//last carry4 or first&Last carry4
//For K=2
(*RLOC = "X0Y2"*) CARRY4 CC_carry_chain_last(
.CO({dummyCO[1:0] , group_carry[9:8]}),
.O ({rca_sum[1:0] , dummySO[1:0]}),
.CI(group_carry[7]),
.CYINIT(),
.DI({rca_gen[1:0] , group_generate [9:8]}),
.S ({rca_prp[1:0] , group_propagate[9:8]})
);

wire [3:0]dummyCO, dummyS, dummyDI, dummySO;
wire dummyCO_fl, dummyCO_K2;    //dummy wire for a CO for K<8 and K=2
//Propagate and Generate for RCA LUTs
wire [1:0]rca_prp, rca_gen;
assign rca_gen = a_rem;

(*RLOC = "X0Y2"*) LUT6 #(.INIT(64'h0000000000000006))RCA_lut_0(
.O(rca_prp[0]),
.I0(a_rem[0]),
.I1(b_rem[0]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

(*RLOC = "X0Y2"*) LUT6 #(.INIT(64'h0000000000000006))RCA_lut_1(
.O(rca_prp[1]),
.I0(a_rem[1]),
.I1(b_rem[1]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

assign Cout = dummyCO[1];

endmodule
