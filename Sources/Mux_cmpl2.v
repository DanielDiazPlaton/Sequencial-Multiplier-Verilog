/**********************************************************************************************
 * Project Name       : Mux_cmpl2
 * Engineer           : Daniel Diaz Platon
 * Module description : Use to change the complement operation if is negative.
 * Target             : 5CSXFC6D6F31C6
 * Date               : 2024/02/27
 **********************************************************************************************/

module Mux_cmpl2 #(parameter n = 10) (
    input              sel,
    input      [n-1:0] DI,
    output     [n-1:0] DO
);

assign DO = (sel == 1'b1) ? (~DI[n-1:0] + 1'b1) : DI[n-1:0];

endmodule