// wrapper module of adder for delay calculation
`timescale 1ns / 1ps
module mn_adder_wrapper #(parameter N=16, M=6)(
    input [15:0]A,B,
    input Cin, clk, rst,
    output [15:0] sum,
    output Cout
    );

    reg in_reg, out_reg_fa, out_reg_So;
    wire driver_fa, driver_So;
    mn_adder #(.N(16), .M(6))adder_inst(.A({A[15:1], in_reg}), .B(B), .Cin(Cin), .sum({driver_fa, sum[14:10], driver_So, sum[8:0]}), .Cout(Cout));

    always @(posedge clk) begin
        if (rst) begin
      out_reg_fa <= 1'b0;
	    out_reg_So <= 1'b0;
            in_reg<= 1'b0;
        end
        
        else begin
            in_reg<= A[0];
       out_reg_fa <= driver_fa;
	     out_reg_So <= driver_So;
        end
    end

    assign sum[15] = out_reg_fa;
    assign sum[9] = out_reg_So;

endmodule
