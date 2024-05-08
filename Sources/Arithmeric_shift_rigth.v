/**********************************************************************************************
 * Project Name       : Arithmeric_shift_rigth
 * Engineer           : Daniel Diaz Platon
 * Module description : 
 * Target             : 5CSXFC6D6F31C6
 * Date               : 2024/00/00
 **********************************************************************************************/

module Arithmeric_shift_rigth #(parameter WIDTH = 11) 
(
    input                  clk,
    input                  enable,
    input      [WIDTH-1:0] data,
    output reg [WIDTH-1:0] out,
    output reg             ready
);


always @(posedge clk) 
begin
    if (enable == 1'b1) begin
        out     <= {data[WIDTH-1],data[WIDTH-1:1]};
        ready   <= 1'b1;
    end
    else    
        begin
            out     <= out;
            ready   <= 1'b0;
        end
end

endmodule