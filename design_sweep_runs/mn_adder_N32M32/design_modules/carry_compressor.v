`timescale 1ns / 1ps
//parameter K has to be an even number
module carry_compressor #(parameter K=0)(
    input[-1:0] A,B,
    input Cin,
    //     a[K+3-((K/2)%4):K],   b[K+3-((K/2)%4):K]
    input  [3:0]a_rem, b_rem,         //operand bits belonging to the last M bits
    output [3:0]rca_sum,              //Sum of the [K+3-((K/2)%4:K)] stages of addition
    output [-1:0]group_carry,
    output Cout
    );

//--------------------------------------------------------------
wire [-1:0]group_propagate, group_generate;
//--------------------------------------------------------------

//last carry4 or first&Last carry4
wire [3:0]dummyCO, dummyS, dummyDI, dummySO;
wire dummyCO_fl, dummyCO_K2;    //dummy wire for a CO for K<8 and K=2
//Propagate and Generate for RCA LUTs
wire [3:0]rca_prp, rca_gen;
assign rca_gen = a_rem;

assign Cout = group_carry[-1];

endmodule
