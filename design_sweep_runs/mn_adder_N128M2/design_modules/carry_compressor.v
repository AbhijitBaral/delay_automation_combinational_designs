`timescale 1ns / 1ps
//parameter K has to be an even number
module carry_compressor #(parameter K=126)(
    input[125:0] A,B,
    input Cin,
    //     a[K+3-((K/2)%4):K],   b[K+3-((K/2)%4):K]
    input  [0:0]a_rem, b_rem,         //operand bits belonging to the last M bits
    output [0:0]rca_sum,              //Sum of the [K+3-((K/2)%4:K)] stages of addition
    output [62:0]group_carry,
    output Cout
    );

//--------------------------------------------------------------
wire [62:0]group_propagate, group_generate;
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

(*RLOC="X0Y2"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut20(
.O6(group_propagate[10]),
.O5(group_generate[10]),
.I0(A[20]),
.I1(B[20]),
.I2(A[21]),
.I3(B[21]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y2"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut22(
.O6(group_propagate[11]),
.O5(group_generate[11]),
.I0(A[22]),
.I1(B[22]),
.I2(A[23]),
.I3(B[23]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y3"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut24(
.O6(group_propagate[12]),
.O5(group_generate[12]),
.I0(A[24]),
.I1(B[24]),
.I2(A[25]),
.I3(B[25]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y3"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut26(
.O6(group_propagate[13]),
.O5(group_generate[13]),
.I0(A[26]),
.I1(B[26]),
.I2(A[27]),
.I3(B[27]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y3"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut28(
.O6(group_propagate[14]),
.O5(group_generate[14]),
.I0(A[28]),
.I1(B[28]),
.I2(A[29]),
.I3(B[29]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y3"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut30(
.O6(group_propagate[15]),
.O5(group_generate[15]),
.I0(A[30]),
.I1(B[30]),
.I2(A[31]),
.I3(B[31]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y4"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut32(
.O6(group_propagate[16]),
.O5(group_generate[16]),
.I0(A[32]),
.I1(B[32]),
.I2(A[33]),
.I3(B[33]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y4"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut34(
.O6(group_propagate[17]),
.O5(group_generate[17]),
.I0(A[34]),
.I1(B[34]),
.I2(A[35]),
.I3(B[35]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y4"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut36(
.O6(group_propagate[18]),
.O5(group_generate[18]),
.I0(A[36]),
.I1(B[36]),
.I2(A[37]),
.I3(B[37]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y4"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut38(
.O6(group_propagate[19]),
.O5(group_generate[19]),
.I0(A[38]),
.I1(B[38]),
.I2(A[39]),
.I3(B[39]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y5"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut40(
.O6(group_propagate[20]),
.O5(group_generate[20]),
.I0(A[40]),
.I1(B[40]),
.I2(A[41]),
.I3(B[41]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y5"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut42(
.O6(group_propagate[21]),
.O5(group_generate[21]),
.I0(A[42]),
.I1(B[42]),
.I2(A[43]),
.I3(B[43]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y5"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut44(
.O6(group_propagate[22]),
.O5(group_generate[22]),
.I0(A[44]),
.I1(B[44]),
.I2(A[45]),
.I3(B[45]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y5"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut46(
.O6(group_propagate[23]),
.O5(group_generate[23]),
.I0(A[46]),
.I1(B[46]),
.I2(A[47]),
.I3(B[47]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y6"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut48(
.O6(group_propagate[24]),
.O5(group_generate[24]),
.I0(A[48]),
.I1(B[48]),
.I2(A[49]),
.I3(B[49]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y6"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut50(
.O6(group_propagate[25]),
.O5(group_generate[25]),
.I0(A[50]),
.I1(B[50]),
.I2(A[51]),
.I3(B[51]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y6"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut52(
.O6(group_propagate[26]),
.O5(group_generate[26]),
.I0(A[52]),
.I1(B[52]),
.I2(A[53]),
.I3(B[53]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y6"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut54(
.O6(group_propagate[27]),
.O5(group_generate[27]),
.I0(A[54]),
.I1(B[54]),
.I2(A[55]),
.I3(B[55]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y7"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut56(
.O6(group_propagate[28]),
.O5(group_generate[28]),
.I0(A[56]),
.I1(B[56]),
.I2(A[57]),
.I3(B[57]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y7"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut58(
.O6(group_propagate[29]),
.O5(group_generate[29]),
.I0(A[58]),
.I1(B[58]),
.I2(A[59]),
.I3(B[59]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y7"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut60(
.O6(group_propagate[30]),
.O5(group_generate[30]),
.I0(A[60]),
.I1(B[60]),
.I2(A[61]),
.I3(B[61]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y7"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut62(
.O6(group_propagate[31]),
.O5(group_generate[31]),
.I0(A[62]),
.I1(B[62]),
.I2(A[63]),
.I3(B[63]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y8"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut64(
.O6(group_propagate[32]),
.O5(group_generate[32]),
.I0(A[64]),
.I1(B[64]),
.I2(A[65]),
.I3(B[65]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y8"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut66(
.O6(group_propagate[33]),
.O5(group_generate[33]),
.I0(A[66]),
.I1(B[66]),
.I2(A[67]),
.I3(B[67]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y8"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut68(
.O6(group_propagate[34]),
.O5(group_generate[34]),
.I0(A[68]),
.I1(B[68]),
.I2(A[69]),
.I3(B[69]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y8"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut70(
.O6(group_propagate[35]),
.O5(group_generate[35]),
.I0(A[70]),
.I1(B[70]),
.I2(A[71]),
.I3(B[71]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y9"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut72(
.O6(group_propagate[36]),
.O5(group_generate[36]),
.I0(A[72]),
.I1(B[72]),
.I2(A[73]),
.I3(B[73]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y9"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut74(
.O6(group_propagate[37]),
.O5(group_generate[37]),
.I0(A[74]),
.I1(B[74]),
.I2(A[75]),
.I3(B[75]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y9"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut76(
.O6(group_propagate[38]),
.O5(group_generate[38]),
.I0(A[76]),
.I1(B[76]),
.I2(A[77]),
.I3(B[77]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y9"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut78(
.O6(group_propagate[39]),
.O5(group_generate[39]),
.I0(A[78]),
.I1(B[78]),
.I2(A[79]),
.I3(B[79]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y10"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut80(
.O6(group_propagate[40]),
.O5(group_generate[40]),
.I0(A[80]),
.I1(B[80]),
.I2(A[81]),
.I3(B[81]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y10"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut82(
.O6(group_propagate[41]),
.O5(group_generate[41]),
.I0(A[82]),
.I1(B[82]),
.I2(A[83]),
.I3(B[83]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y10"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut84(
.O6(group_propagate[42]),
.O5(group_generate[42]),
.I0(A[84]),
.I1(B[84]),
.I2(A[85]),
.I3(B[85]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y10"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut86(
.O6(group_propagate[43]),
.O5(group_generate[43]),
.I0(A[86]),
.I1(B[86]),
.I2(A[87]),
.I3(B[87]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y11"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut88(
.O6(group_propagate[44]),
.O5(group_generate[44]),
.I0(A[88]),
.I1(B[88]),
.I2(A[89]),
.I3(B[89]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y11"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut90(
.O6(group_propagate[45]),
.O5(group_generate[45]),
.I0(A[90]),
.I1(B[90]),
.I2(A[91]),
.I3(B[91]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y11"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut92(
.O6(group_propagate[46]),
.O5(group_generate[46]),
.I0(A[92]),
.I1(B[92]),
.I2(A[93]),
.I3(B[93]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y11"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut94(
.O6(group_propagate[47]),
.O5(group_generate[47]),
.I0(A[94]),
.I1(B[94]),
.I2(A[95]),
.I3(B[95]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y12"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut96(
.O6(group_propagate[48]),
.O5(group_generate[48]),
.I0(A[96]),
.I1(B[96]),
.I2(A[97]),
.I3(B[97]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y12"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut98(
.O6(group_propagate[49]),
.O5(group_generate[49]),
.I0(A[98]),
.I1(B[98]),
.I2(A[99]),
.I3(B[99]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y12"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut100(
.O6(group_propagate[50]),
.O5(group_generate[50]),
.I0(A[100]),
.I1(B[100]),
.I2(A[101]),
.I3(B[101]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y12"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut102(
.O6(group_propagate[51]),
.O5(group_generate[51]),
.I0(A[102]),
.I1(B[102]),
.I2(A[103]),
.I3(B[103]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y13"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut104(
.O6(group_propagate[52]),
.O5(group_generate[52]),
.I0(A[104]),
.I1(B[104]),
.I2(A[105]),
.I3(B[105]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y13"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut106(
.O6(group_propagate[53]),
.O5(group_generate[53]),
.I0(A[106]),
.I1(B[106]),
.I2(A[107]),
.I3(B[107]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y13"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut108(
.O6(group_propagate[54]),
.O5(group_generate[54]),
.I0(A[108]),
.I1(B[108]),
.I2(A[109]),
.I3(B[109]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y13"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut110(
.O6(group_propagate[55]),
.O5(group_generate[55]),
.I0(A[110]),
.I1(B[110]),
.I2(A[111]),
.I3(B[111]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y14"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut112(
.O6(group_propagate[56]),
.O5(group_generate[56]),
.I0(A[112]),
.I1(B[112]),
.I2(A[113]),
.I3(B[113]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y14"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut114(
.O6(group_propagate[57]),
.O5(group_generate[57]),
.I0(A[114]),
.I1(B[114]),
.I2(A[115]),
.I3(B[115]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y14"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut116(
.O6(group_propagate[58]),
.O5(group_generate[58]),
.I0(A[116]),
.I1(B[116]),
.I2(A[117]),
.I3(B[117]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y14"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut118(
.O6(group_propagate[59]),
.O5(group_generate[59]),
.I0(A[118]),
.I1(B[118]),
.I2(A[119]),
.I3(B[119]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y15"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut120(
.O6(group_propagate[60]),
.O5(group_generate[60]),
.I0(A[120]),
.I1(B[120]),
.I2(A[121]),
.I3(B[121]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y15"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut122(
.O6(group_propagate[61]),
.O5(group_generate[61]),
.I0(A[122]),
.I1(B[122]),
.I2(A[123]),
.I3(B[123]),
.I4(1'b0),
.I5(1'b1)
);

(*RLOC="X0Y15"*)LUT6_2 #(.INIT(64'h000006600000FAA0)) CC_lut124(
.O6(group_propagate[62]),
.O5(group_generate[62]),
.I0(A[124]),
.I1(B[124]),
.I2(A[125]),
.I3(B[125]),
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

(*RLOC = "X0Y2"*)CARRY4 CC_carry4_2(
.CO(group_carry[11:8]),
.O(),
.CI(group_carry[7]),
.CYINIT(),
.DI(group_generate[11:8]),
.S(group_propagate[11:8])
);

(*RLOC = "X0Y3"*)CARRY4 CC_carry4_3(
.CO(group_carry[15:12]),
.O(),
.CI(group_carry[11]),
.CYINIT(),
.DI(group_generate[15:12]),
.S(group_propagate[15:12])
);

(*RLOC = "X0Y4"*)CARRY4 CC_carry4_4(
.CO(group_carry[19:16]),
.O(),
.CI(group_carry[15]),
.CYINIT(),
.DI(group_generate[19:16]),
.S(group_propagate[19:16])
);

(*RLOC = "X0Y5"*)CARRY4 CC_carry4_5(
.CO(group_carry[23:20]),
.O(),
.CI(group_carry[19]),
.CYINIT(),
.DI(group_generate[23:20]),
.S(group_propagate[23:20])
);

(*RLOC = "X0Y6"*)CARRY4 CC_carry4_6(
.CO(group_carry[27:24]),
.O(),
.CI(group_carry[23]),
.CYINIT(),
.DI(group_generate[27:24]),
.S(group_propagate[27:24])
);

(*RLOC = "X0Y7"*)CARRY4 CC_carry4_7(
.CO(group_carry[31:28]),
.O(),
.CI(group_carry[27]),
.CYINIT(),
.DI(group_generate[31:28]),
.S(group_propagate[31:28])
);

(*RLOC = "X0Y8"*)CARRY4 CC_carry4_8(
.CO(group_carry[35:32]),
.O(),
.CI(group_carry[31]),
.CYINIT(),
.DI(group_generate[35:32]),
.S(group_propagate[35:32])
);

(*RLOC = "X0Y9"*)CARRY4 CC_carry4_9(
.CO(group_carry[39:36]),
.O(),
.CI(group_carry[35]),
.CYINIT(),
.DI(group_generate[39:36]),
.S(group_propagate[39:36])
);

(*RLOC = "X0Y10"*)CARRY4 CC_carry4_10(
.CO(group_carry[43:40]),
.O(),
.CI(group_carry[39]),
.CYINIT(),
.DI(group_generate[43:40]),
.S(group_propagate[43:40])
);

(*RLOC = "X0Y11"*)CARRY4 CC_carry4_11(
.CO(group_carry[47:44]),
.O(),
.CI(group_carry[43]),
.CYINIT(),
.DI(group_generate[47:44]),
.S(group_propagate[47:44])
);

(*RLOC = "X0Y12"*)CARRY4 CC_carry4_12(
.CO(group_carry[51:48]),
.O(),
.CI(group_carry[47]),
.CYINIT(),
.DI(group_generate[51:48]),
.S(group_propagate[51:48])
);

(*RLOC = "X0Y13"*)CARRY4 CC_carry4_13(
.CO(group_carry[55:52]),
.O(),
.CI(group_carry[51]),
.CYINIT(),
.DI(group_generate[55:52]),
.S(group_propagate[55:52])
);

(*RLOC = "X0Y14"*)CARRY4 CC_carry4_14(
.CO(group_carry[59:56]),
.O(),
.CI(group_carry[55]),
.CYINIT(),
.DI(group_generate[59:56]),
.S(group_propagate[59:56])
);

//last carry4 or first&Last carry4
//For K=2
(*RLOC = "X0Y15"*) CARRY4 CC_carry_chain_last(
.CO({dummyCO[0:0] , group_carry[62:60]}),
.O ({rca_sum[0:0] , dummySO[2:0]}),
.CI(group_carry[59]),
.CYINIT(),
.DI({rca_gen[0:0] , group_generate [62:60]}),
.S ({rca_prp[0:0] , group_propagate[62:60]})
);

wire [3:0]dummyCO, dummyS, dummyDI, dummySO;
wire dummyCO_fl, dummyCO_K2;    //dummy wire for a CO for K<8 and K=2
//Propagate and Generate for RCA LUTs
wire [0:0]rca_prp, rca_gen;
assign rca_gen = a_rem;

(*RLOC = "X0Y15"*) LUT6 #(.INIT(64'h0000000000000006))RCA_lut_0(
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
