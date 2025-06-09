`timescale 1ns / 1ps
//parameter K has to be an even number
module carry_compressor #(parameter K=8)(
    input[7:0] A,B,
    input Cin,
    //     a[K+3-((K/2)%4):K],   b[K+3-((K/2)%4):K]
    input  [3:0]a_rem, b_rem,         //operand bits belonging to the last M bits
    output [3:0]rca_sum,              //Sum of the [K+3-((K/2)%4:K)] stages of addition
    output [3:0]group_carry,
    output Cout
    );

//--------------------------------------------------------------
wire [3:0]group_propagate, group_generate;
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

(*RLOC = "X0Y0"*)CARRY4 CC_carry4_0(
.CO(group_carry[3:0]),
.O(),
.CI(),
.CYINIT(Cin),
.DI(group_generate[3:0]),
.S(group_propagate[3:0])
);

//last carry4 or first&Last carry4
wire [3:0]dummyCO, dummyS, dummyDI, dummySO;
wire dummyCO_fl, dummyCO_K2;    //dummy wire for a CO for K<8 and K=2
//Propagate and Generate for RCA LUTs
wire [3:0]rca_prp, rca_gen;
assign rca_gen = a_rem;

assign Cout = group_carry[3];

endmodule
