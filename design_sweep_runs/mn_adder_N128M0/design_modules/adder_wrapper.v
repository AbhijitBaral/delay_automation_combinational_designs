// wrapper module of adder for delay calculation
`timescale 1ns / 1ps
module mn_adder_wrapper #(parameter N=128, M=0)(
    input [127:0]A,B,
    input Cin, clk, rst,
    output [127:0] sum,
    output Cout
    );

    reg in_reg, out_reg_fa, out_reg_So;
    wire driver_fa, driver_So;
    mn_adder #(.N(128), .M(0))adder_inst(.A({A[127:1], in_reg}), .B(B), .Cin(Cin), .sum({driver_So, sum[126:0]}), .Cout(Cout));

    always @(posedge clk) begin
        if (rst) begin
	    out_reg_So <= 1'b0;
            in_reg<= 1'b0;
        end
        
        else begin
            in_reg<= A[0];
	    out_reg_So <= driver_So;
        end
    end

    assign sum[127] = out_reg_So;
endmodule
