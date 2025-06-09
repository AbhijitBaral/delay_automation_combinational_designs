`timescale 1ns / 1ps
module compressed_adder #(parameter K=128)(
    input [127:0] A,B,
    input [63:0]group_carry,
    input Cin,
    output [127:0] sum
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

(* RLOC = "X0Y1" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_3(
.O6(sum[7]),
.O5(sum[6]),
.I0(A[6]),
.I1(B[6]),
.I2(A[7]),
.I3(B[7]),
.I4(group_carry[2]),
.I5(1'b1));

(* RLOC = "X0Y1" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_4(
.O6(sum[9]),
.O5(sum[8]),
.I0(A[8]),
.I1(B[8]),
.I2(A[9]),
.I3(B[9]),
.I4(group_carry[3]),
.I5(1'b1));

(* RLOC = "X0Y2" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_5(
.O6(sum[11]),
.O5(sum[10]),
.I0(A[10]),
.I1(B[10]),
.I2(A[11]),
.I3(B[11]),
.I4(group_carry[4]),
.I5(1'b1));

(* RLOC = "X0Y2" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_6(
.O6(sum[13]),
.O5(sum[12]),
.I0(A[12]),
.I1(B[12]),
.I2(A[13]),
.I3(B[13]),
.I4(group_carry[5]),
.I5(1'b1));

(* RLOC = "X0Y2" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_7(
.O6(sum[15]),
.O5(sum[14]),
.I0(A[14]),
.I1(B[14]),
.I2(A[15]),
.I3(B[15]),
.I4(group_carry[6]),
.I5(1'b1));

(* RLOC = "X0Y2" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_8(
.O6(sum[17]),
.O5(sum[16]),
.I0(A[16]),
.I1(B[16]),
.I2(A[17]),
.I3(B[17]),
.I4(group_carry[7]),
.I5(1'b1));

(* RLOC = "X0Y3" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_9(
.O6(sum[19]),
.O5(sum[18]),
.I0(A[18]),
.I1(B[18]),
.I2(A[19]),
.I3(B[19]),
.I4(group_carry[8]),
.I5(1'b1));

(* RLOC = "X0Y3" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_10(
.O6(sum[21]),
.O5(sum[20]),
.I0(A[20]),
.I1(B[20]),
.I2(A[21]),
.I3(B[21]),
.I4(group_carry[9]),
.I5(1'b1));

(* RLOC = "X0Y3" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_11(
.O6(sum[23]),
.O5(sum[22]),
.I0(A[22]),
.I1(B[22]),
.I2(A[23]),
.I3(B[23]),
.I4(group_carry[10]),
.I5(1'b1));

(* RLOC = "X0Y3" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_12(
.O6(sum[25]),
.O5(sum[24]),
.I0(A[24]),
.I1(B[24]),
.I2(A[25]),
.I3(B[25]),
.I4(group_carry[11]),
.I5(1'b1));

(* RLOC = "X0Y4" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_13(
.O6(sum[27]),
.O5(sum[26]),
.I0(A[26]),
.I1(B[26]),
.I2(A[27]),
.I3(B[27]),
.I4(group_carry[12]),
.I5(1'b1));

(* RLOC = "X0Y4" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_14(
.O6(sum[29]),
.O5(sum[28]),
.I0(A[28]),
.I1(B[28]),
.I2(A[29]),
.I3(B[29]),
.I4(group_carry[13]),
.I5(1'b1));

(* RLOC = "X0Y4" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_15(
.O6(sum[31]),
.O5(sum[30]),
.I0(A[30]),
.I1(B[30]),
.I2(A[31]),
.I3(B[31]),
.I4(group_carry[14]),
.I5(1'b1));

(* RLOC = "X0Y4" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_16(
.O6(sum[33]),
.O5(sum[32]),
.I0(A[32]),
.I1(B[32]),
.I2(A[33]),
.I3(B[33]),
.I4(group_carry[15]),
.I5(1'b1));

(* RLOC = "X0Y5" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_17(
.O6(sum[35]),
.O5(sum[34]),
.I0(A[34]),
.I1(B[34]),
.I2(A[35]),
.I3(B[35]),
.I4(group_carry[16]),
.I5(1'b1));

(* RLOC = "X0Y5" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_18(
.O6(sum[37]),
.O5(sum[36]),
.I0(A[36]),
.I1(B[36]),
.I2(A[37]),
.I3(B[37]),
.I4(group_carry[17]),
.I5(1'b1));

(* RLOC = "X0Y5" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_19(
.O6(sum[39]),
.O5(sum[38]),
.I0(A[38]),
.I1(B[38]),
.I2(A[39]),
.I3(B[39]),
.I4(group_carry[18]),
.I5(1'b1));

(* RLOC = "X0Y5" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_20(
.O6(sum[41]),
.O5(sum[40]),
.I0(A[40]),
.I1(B[40]),
.I2(A[41]),
.I3(B[41]),
.I4(group_carry[19]),
.I5(1'b1));

(* RLOC = "X0Y6" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_21(
.O6(sum[43]),
.O5(sum[42]),
.I0(A[42]),
.I1(B[42]),
.I2(A[43]),
.I3(B[43]),
.I4(group_carry[20]),
.I5(1'b1));

(* RLOC = "X0Y6" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_22(
.O6(sum[45]),
.O5(sum[44]),
.I0(A[44]),
.I1(B[44]),
.I2(A[45]),
.I3(B[45]),
.I4(group_carry[21]),
.I5(1'b1));

(* RLOC = "X0Y6" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_23(
.O6(sum[47]),
.O5(sum[46]),
.I0(A[46]),
.I1(B[46]),
.I2(A[47]),
.I3(B[47]),
.I4(group_carry[22]),
.I5(1'b1));

(* RLOC = "X0Y6" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_24(
.O6(sum[49]),
.O5(sum[48]),
.I0(A[48]),
.I1(B[48]),
.I2(A[49]),
.I3(B[49]),
.I4(group_carry[23]),
.I5(1'b1));

(* RLOC = "X0Y7" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_25(
.O6(sum[51]),
.O5(sum[50]),
.I0(A[50]),
.I1(B[50]),
.I2(A[51]),
.I3(B[51]),
.I4(group_carry[24]),
.I5(1'b1));

(* RLOC = "X0Y7" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_26(
.O6(sum[53]),
.O5(sum[52]),
.I0(A[52]),
.I1(B[52]),
.I2(A[53]),
.I3(B[53]),
.I4(group_carry[25]),
.I5(1'b1));

(* RLOC = "X0Y7" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_27(
.O6(sum[55]),
.O5(sum[54]),
.I0(A[54]),
.I1(B[54]),
.I2(A[55]),
.I3(B[55]),
.I4(group_carry[26]),
.I5(1'b1));

(* RLOC = "X0Y7" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_28(
.O6(sum[57]),
.O5(sum[56]),
.I0(A[56]),
.I1(B[56]),
.I2(A[57]),
.I3(B[57]),
.I4(group_carry[27]),
.I5(1'b1));

(* RLOC = "X0Y8" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_29(
.O6(sum[59]),
.O5(sum[58]),
.I0(A[58]),
.I1(B[58]),
.I2(A[59]),
.I3(B[59]),
.I4(group_carry[28]),
.I5(1'b1));

(* RLOC = "X0Y8" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_30(
.O6(sum[61]),
.O5(sum[60]),
.I0(A[60]),
.I1(B[60]),
.I2(A[61]),
.I3(B[61]),
.I4(group_carry[29]),
.I5(1'b1));

(* RLOC = "X0Y8" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_31(
.O6(sum[63]),
.O5(sum[62]),
.I0(A[62]),
.I1(B[62]),
.I2(A[63]),
.I3(B[63]),
.I4(group_carry[30]),
.I5(1'b1));

(* RLOC = "X0Y8" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_32(
.O6(sum[65]),
.O5(sum[64]),
.I0(A[64]),
.I1(B[64]),
.I2(A[65]),
.I3(B[65]),
.I4(group_carry[31]),
.I5(1'b1));

(* RLOC = "X0Y9" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_33(
.O6(sum[67]),
.O5(sum[66]),
.I0(A[66]),
.I1(B[66]),
.I2(A[67]),
.I3(B[67]),
.I4(group_carry[32]),
.I5(1'b1));

(* RLOC = "X0Y9" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_34(
.O6(sum[69]),
.O5(sum[68]),
.I0(A[68]),
.I1(B[68]),
.I2(A[69]),
.I3(B[69]),
.I4(group_carry[33]),
.I5(1'b1));

(* RLOC = "X0Y9" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_35(
.O6(sum[71]),
.O5(sum[70]),
.I0(A[70]),
.I1(B[70]),
.I2(A[71]),
.I3(B[71]),
.I4(group_carry[34]),
.I5(1'b1));

(* RLOC = "X0Y9" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_36(
.O6(sum[73]),
.O5(sum[72]),
.I0(A[72]),
.I1(B[72]),
.I2(A[73]),
.I3(B[73]),
.I4(group_carry[35]),
.I5(1'b1));

(* RLOC = "X0Y10" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_37(
.O6(sum[75]),
.O5(sum[74]),
.I0(A[74]),
.I1(B[74]),
.I2(A[75]),
.I3(B[75]),
.I4(group_carry[36]),
.I5(1'b1));

(* RLOC = "X0Y10" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_38(
.O6(sum[77]),
.O5(sum[76]),
.I0(A[76]),
.I1(B[76]),
.I2(A[77]),
.I3(B[77]),
.I4(group_carry[37]),
.I5(1'b1));

(* RLOC = "X0Y10" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_39(
.O6(sum[79]),
.O5(sum[78]),
.I0(A[78]),
.I1(B[78]),
.I2(A[79]),
.I3(B[79]),
.I4(group_carry[38]),
.I5(1'b1));

(* RLOC = "X0Y10" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_40(
.O6(sum[81]),
.O5(sum[80]),
.I0(A[80]),
.I1(B[80]),
.I2(A[81]),
.I3(B[81]),
.I4(group_carry[39]),
.I5(1'b1));

(* RLOC = "X0Y11" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_41(
.O6(sum[83]),
.O5(sum[82]),
.I0(A[82]),
.I1(B[82]),
.I2(A[83]),
.I3(B[83]),
.I4(group_carry[40]),
.I5(1'b1));

(* RLOC = "X0Y11" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_42(
.O6(sum[85]),
.O5(sum[84]),
.I0(A[84]),
.I1(B[84]),
.I2(A[85]),
.I3(B[85]),
.I4(group_carry[41]),
.I5(1'b1));

(* RLOC = "X0Y11" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_43(
.O6(sum[87]),
.O5(sum[86]),
.I0(A[86]),
.I1(B[86]),
.I2(A[87]),
.I3(B[87]),
.I4(group_carry[42]),
.I5(1'b1));

(* RLOC = "X0Y11" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_44(
.O6(sum[89]),
.O5(sum[88]),
.I0(A[88]),
.I1(B[88]),
.I2(A[89]),
.I3(B[89]),
.I4(group_carry[43]),
.I5(1'b1));

(* RLOC = "X0Y12" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_45(
.O6(sum[91]),
.O5(sum[90]),
.I0(A[90]),
.I1(B[90]),
.I2(A[91]),
.I3(B[91]),
.I4(group_carry[44]),
.I5(1'b1));

(* RLOC = "X0Y12" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_46(
.O6(sum[93]),
.O5(sum[92]),
.I0(A[92]),
.I1(B[92]),
.I2(A[93]),
.I3(B[93]),
.I4(group_carry[45]),
.I5(1'b1));

(* RLOC = "X0Y12" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_47(
.O6(sum[95]),
.O5(sum[94]),
.I0(A[94]),
.I1(B[94]),
.I2(A[95]),
.I3(B[95]),
.I4(group_carry[46]),
.I5(1'b1));

(* RLOC = "X0Y12" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_48(
.O6(sum[97]),
.O5(sum[96]),
.I0(A[96]),
.I1(B[96]),
.I2(A[97]),
.I3(B[97]),
.I4(group_carry[47]),
.I5(1'b1));

(* RLOC = "X0Y13" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_49(
.O6(sum[99]),
.O5(sum[98]),
.I0(A[98]),
.I1(B[98]),
.I2(A[99]),
.I3(B[99]),
.I4(group_carry[48]),
.I5(1'b1));

(* RLOC = "X0Y13" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_50(
.O6(sum[101]),
.O5(sum[100]),
.I0(A[100]),
.I1(B[100]),
.I2(A[101]),
.I3(B[101]),
.I4(group_carry[49]),
.I5(1'b1));

(* RLOC = "X0Y13" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_51(
.O6(sum[103]),
.O5(sum[102]),
.I0(A[102]),
.I1(B[102]),
.I2(A[103]),
.I3(B[103]),
.I4(group_carry[50]),
.I5(1'b1));

(* RLOC = "X0Y13" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_52(
.O6(sum[105]),
.O5(sum[104]),
.I0(A[104]),
.I1(B[104]),
.I2(A[105]),
.I3(B[105]),
.I4(group_carry[51]),
.I5(1'b1));

(* RLOC = "X0Y14" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_53(
.O6(sum[107]),
.O5(sum[106]),
.I0(A[106]),
.I1(B[106]),
.I2(A[107]),
.I3(B[107]),
.I4(group_carry[52]),
.I5(1'b1));

(* RLOC = "X0Y14" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_54(
.O6(sum[109]),
.O5(sum[108]),
.I0(A[108]),
.I1(B[108]),
.I2(A[109]),
.I3(B[109]),
.I4(group_carry[53]),
.I5(1'b1));

(* RLOC = "X0Y14" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_55(
.O6(sum[111]),
.O5(sum[110]),
.I0(A[110]),
.I1(B[110]),
.I2(A[111]),
.I3(B[111]),
.I4(group_carry[54]),
.I5(1'b1));

(* RLOC = "X0Y14" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_56(
.O6(sum[113]),
.O5(sum[112]),
.I0(A[112]),
.I1(B[112]),
.I2(A[113]),
.I3(B[113]),
.I4(group_carry[55]),
.I5(1'b1));

(* RLOC = "X0Y15" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_57(
.O6(sum[115]),
.O5(sum[114]),
.I0(A[114]),
.I1(B[114]),
.I2(A[115]),
.I3(B[115]),
.I4(group_carry[56]),
.I5(1'b1));

(* RLOC = "X0Y15" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_58(
.O6(sum[117]),
.O5(sum[116]),
.I0(A[116]),
.I1(B[116]),
.I2(A[117]),
.I3(B[117]),
.I4(group_carry[57]),
.I5(1'b1));

(* RLOC = "X0Y15" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_59(
.O6(sum[119]),
.O5(sum[118]),
.I0(A[118]),
.I1(B[118]),
.I2(A[119]),
.I3(B[119]),
.I4(group_carry[58]),
.I5(1'b1));

(* RLOC = "X0Y15" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_60(
.O6(sum[121]),
.O5(sum[120]),
.I0(A[120]),
.I1(B[120]),
.I2(A[121]),
.I3(B[121]),
.I4(group_carry[59]),
.I5(1'b1));

(* RLOC = "X0Y16" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_61(
.O6(sum[123]),
.O5(sum[122]),
.I0(A[122]),
.I1(B[122]),
.I2(A[123]),
.I3(B[123]),
.I4(group_carry[60]),
.I5(1'b1));

(* RLOC = "X0Y16" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_62(
.O6(sum[125]),
.O5(sum[124]),
.I0(A[124]),
.I1(B[124]),
.I2(A[125]),
.I3(B[125]),
.I4(group_carry[61]),
.I5(1'b1));

(* RLOC = "X0Y16" *) LUT6_2 #(.INIT(64'hE11E877899996666)) So_lut_63(
.O6(sum[127]),
.O5(sum[126]),
.I0(A[126]),
.I1(B[126]),
.I2(A[127]),
.I3(B[127]),
.I4(group_carry[62]),
.I5(1'b1));

endmodule
