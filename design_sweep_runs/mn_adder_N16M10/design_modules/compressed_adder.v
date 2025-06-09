`timescale 1ns / 1ps
module compressed_adder #(parameter K=6)(
    input [5:0] A,B,
    input [2:0]group_carry,
    input Cin,
    output [5:0] sum
    );

(*RLOC = "X0Y0"*)LUT6_2 #(.INIT(64'hE11E877899996666))So_lut_0(
.O6(sum[1]),
.O5(sum[0]),
.I0(A[0]),
.I1(B[0]),
.I2(A[1]),
.I3(B[1]),
.I4(Cin),
.I5(1'b1)
);

(* RLOC = "X0Y1" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_1(
.O6(sum[3]),
.O5(sum[2]),
.I0(A[2]),
.I1(B[2]),
.I2(A[3]),
.I3(B[3]),
.I4(group_carry[0]),
.I5(1'b1));

(* RLOC = "X0Y1" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_2(
.O6(sum[5]),
.O5(sum[4]),
.I0(A[4]),
.I1(B[4]),
.I2(A[5]),
.I3(B[5]),
.I4(group_carry[1]),
.I5(1'b1));

endmodule
