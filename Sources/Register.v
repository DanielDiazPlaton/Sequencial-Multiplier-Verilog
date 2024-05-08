/**********************************************************************************************
 * Project Name       : Register
 * Engineer           : Daniel Diaz Platon
 * Module description : 
 * Target             : 5CSXFC6D6F31C6
 * Date               : 2024/02/21
 **********************************************************************************************/

module Register #(parameter n = 10) (
    input              rst,
    input              clk,
    input              Enable,
    input      [n-1:0] DI,
    output reg [n-1:0] DO
);

always @(posedge clk, posedge rst) begin
    if (rst) begin
        DO <= 0;
    end else begin
        if(Enable)
            DO <= DI;
        else 
            DO <= DO;
    end
end

endmodule