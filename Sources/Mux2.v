/**********************************************************************************************
 * Project Name       : Multiplexor sel 2
 * Engineer           : Daniel Diaz Platon
 * Module description : 
 * Target             : 5CSXFC6D6F31C6
 * Date               : 2024/05/02
 **********************************************************************************************/

module Mux2 #(parameter  WIDTH = 11)
(
    input  [WIDTH-1:0] d0, d1,
    input              s,
    output [WIDTH-1:0] y
);

assign y = s ? d1 : d0;

endmodule