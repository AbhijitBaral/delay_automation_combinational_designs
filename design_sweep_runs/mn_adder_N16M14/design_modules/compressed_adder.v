`timescale 1ns / 1ps
module compressed_adder #(parameter K=2)(
    input [1:0] A,B,
    input [0:0]group_carry,
    input Cin,
    output [1:0] sum
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

endmodule
