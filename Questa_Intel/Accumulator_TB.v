/**********************************************************************************************
 * Project Name       : Sequencial_Multiplier TB
 * Engineer           : Daniel Diaz Platon
 * Module description : 
 * Target             : 5CSXFC6D6F31C6
 * Date               : 2024/00/00
 **********************************************************************************************/
`timescale 1ns/1ps

module Accumulator_TB #(parameter  WIDTH = 11, parameter WIDTH_ACC = 5) ();

reg  [WIDTH-1:0] DI_s;
reg              enable_s;
reg  [1:0]       s_s;
wire [WIDTH-1:0] DO_w;

Accumulator #(.WIDTH(WIDTH), .WIDTH_ACC(WIDTH_ACC)) UUT
(
    .DI(DI_s),
    .enable(enable_s),
    .s(s_s),
    .DO(DO_w)
);

initial 
    begin
        DI_s     = 11'b1010_1101_001;
        enable_s   = 1'b1;
        s_s        = 2'b01;
        #20;
        s_s        = 2'b10;     
    end

endmodule