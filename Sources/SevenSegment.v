/**********************************************************************************************
 * Project Name       : Seven segment
 * Engineer           : Daniel Diaz Platon
 * Module description : 
 * Target             : 5CSXFC6D6F31C6
 * Date               : 2024/02/27
 **********************************************************************************************/

module SevenSegment (
    input  w,
    input  x,
    input  y,
    input  z,
    output seg_a,
    output seg_b,
    output seg_c,
    output seg_d,
    output seg_e,
    output seg_f,
    output seg_g
    //output an
);

//assign an = 1'b1;

assign seg_a = (~w&~x&~y&z) | (~w&x&~y&~z) | (w&x&~y&z) | (w&~x&y&z);
assign seg_b = (~w&x&~y&z) | (w&y&z) | (x&y&~z) | (w&x&~z);
assign seg_c = (~w&~x&y&~z) | (w&x&y) | (w&x&~z);
assign seg_d = (~w&x&~y&~z) | (~w&~x&~y&z) | (w&~x&y&~z) | (x&y&z) | (w&~x&y&~z);
assign seg_e = (~w&z) | (~w&x&~y) | (~x&~y&z);
assign seg_f = (w&x&~y&z) | (~w&~x&z) | (~w&~x&y) | (~w&y&z);
assign seg_g = (~w&~x&~y) | (~w&x&y&z) | (w&x&~y&~z);

endmodule