`timescale 1ns / 1ps
//parameter K has to be an even number
module carry_compressor #(parameter K=6)(
    input[5:0] A,B,
    input Cin,
    //     a[K+3-((K/2)%4):K],   b[K+3-((K/2)%4):K]
    input  [0:0]a_rem, b_rem,         //operand bits belonging to the last M bits
    output [0:0]rca_sum,              //Sum of the [K+3-((K/2)%4:K)] stages of addition
    output [2:0]group_carry,
    output Cout
    );

//--------------------------------------------------------------
wire [2:0]group_propagate, group_generate;
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

//last carry4 or first&Last carry4
//For K=2
(*RLOC = "X0Y0"*)CARRY4 CC_carry_chain_last(
.CO({dummyCO[0:0] ,group_carry[2:0]}),
.O ({rca_sum[0:0] ,dummySO[2:0]}),
.CI(),
.CYINIT(Cin),
.DI({rca_gen[0:0],group_generate [2:0]}),
.S ({rca_prp[0:0],group_propagate[2:0]})
);

wire [3:0]dummyCO, dummyS, dummyDI, dummySO;
wire dummyCO_fl, dummyCO_K2;    //dummy wire for a CO for K<8 and K=2
//Propagate and Generate for RCA LUTs
wire [0:0]rca_prp, rca_gen;
assign rca_gen = a_rem;

(*RLOC = "X0Y0"*) LUT6 #(.INIT(64'h0000000000000006))RCA_lut_0(
.O(rca_prp[0]),
.I0(a_rem[0]),
.I1(b_rem[0]),
.I2(1'b0),
.I3(1'b0),
.I4(1'b0),
.I5(1'b0)
);

assign Cout = dummyCO[0];

endmodule
