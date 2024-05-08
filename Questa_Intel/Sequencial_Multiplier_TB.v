/**********************************************************************************************
 * Project Name       : Sequencial_Multiplier TB
 * Engineer           : Daniel Diaz Platon
 * Module description : 
 * Target             : 5CSXFC6D6F31C6
 * Date               : 2024/00/00
 **********************************************************************************************/
`timescale 1ns/1ps

module Sequencial_Multiplier_TB #(parameter WIDTH = 10) ();

reg              clk_s;
reg              rst_s;
reg              enable_s;
reg  [WIDTH-1:0] data_s;
wire [WIDTH-1:0] out_w;
wire [4:0] con_w;
wire      en_mux_w;    
wire      en_ashr_w;   
wire      en_acc_w;    
wire      en_count_w; 
wire      rst_count_w;
wire      ready_w;   
wire [WIDTH:0]  DO_acc_w; 

Sequencial_Multiplier #(.WIDTH(10)) UUT
(
    .clk(clk_s),
    .rst(rst_s),
    .enable(enable_s),
    .data(data_s),
    .out(out_w),
    .con(con_w),
    .en_mux(en_mux_w),   
    .en_ashr(en_ashr_w),  
    .en_acc(en_acc_w),   
    .en_count(en_count_w), 
    .rst_count(rst_count_w),
    .ready(ready_w),
    .DO_acc(DO_acc_w)   
);

initial 
    begin
        // data_s     = 10'b01011_01110;
        data_s     = 10'b11101_01000;
        clk_s      = 1'b1;
        rst_s      = 1'b1;
        #15;
        rst_s      = 1'b0;
        enable_s   = 1'b1;
        #80;
        enable_s   = 1'b0;
    end

always
    begin
        #40 clk_s = ~clk_s;
    end

always
    begin
        #1000 enable_s = 1'b1;
        #40  enable_s = 1'b0;
    end

// always
//     begin
//         #40;
//         enable_s   = 1'b1;
//         #40;    
//         enable_s   = 1'b0;
//         data_s     = data_s - 1'b1;
//     end

endmodule