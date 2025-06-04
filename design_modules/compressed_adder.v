`timescale 1ns / 1ps
module compressed_adder #(parameter K=20)(
    input [19:0] A,B,
    input [9:0]group_carry,
    input Cin,
    output [19:0] sum
    );

LUT6_2 #(.INIT(64'hE11E877899996666))So_lut_0(
.O6(sum[1]),
.O5(sum[0]),
.I0(A[0]),
.I1(B[0]),
.I2(A[1]),
.I3(B[1]),
.I4(Cin),
.I5(1'b1)
);

(* RLOC = "X0Y0" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_1(
.O6(sum[3]),
.O5(sum[2]),
.I0(A[2]),
.I1(B[2]),
.I2(A[3]),
.I3(B[3]),
.I4(group_carry[0]),
.I5(1'b1));

(* RLOC = "X0Y0" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_2(
.O6(sum[5]),
.O5(sum[4]),
.I0(A[4]),
.I1(B[4]),
.I2(A[5]),
.I3(B[5]),
.I4(group_carry[1]),
.I5(1'b1));

(* RLOC = "X0Y0" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_3(
.O6(sum[7]),
.O5(sum[6]),
.I0(A[6]),
.I1(B[6]),
.I2(A[7]),
.I3(B[7]),
.I4(group_carry[2]),
.I5(1'b1));

(* RLOC = "X0Y0" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_4(
.O6(sum[9]),
.O5(sum[8]),
.I0(A[8]),
.I1(B[8]),
.I2(A[9]),
.I3(B[9]),
.I4(group_carry[3]),
.I5(1'b1));

(* RLOC = "X0Y1" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_5(
.O6(sum[11]),
.O5(sum[10]),
.I0(A[10]),
.I1(B[10]),
.I2(A[11]),
.I3(B[11]),
.I4(group_carry[4]),
.I5(1'b1));

(* RLOC = "X0Y1" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_6(
.O6(sum[13]),
.O5(sum[12]),
.I0(A[12]),
.I1(B[12]),
.I2(A[13]),
.I3(B[13]),
.I4(group_carry[5]),
.I5(1'b1));

(* RLOC = "X0Y1" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_7(
.O6(sum[15]),
.O5(sum[14]),
.I0(A[14]),
.I1(B[14]),
.I2(A[15]),
.I3(B[15]),
.I4(group_carry[6]),
.I5(1'b1));

(* RLOC = "X0Y1" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_8(
.O6(sum[17]),
.O5(sum[16]),
.I0(A[16]),
.I1(B[16]),
.I2(A[17]),
.I3(B[17]),
.I4(group_carry[7]),
.I5(1'b1));

(* RLOC = "X0Y2" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_9(
.O6(sum[19]),
.O5(sum[18]),
.I0(A[18]),
.I1(B[18]),
.I2(A[19]),
.I3(B[19]),
.I4(group_carry[8]),
.I5(1'b1));

endmodule
