/**********************************************************************************************
 * Project Name       : Sequencial_Multiplier
 * Engineer           : Daniel Diaz Platon
 * Module description : 
 * Target             : 5CSXFC6D6F31C6
 * Date               : 2024/00/00
 **********************************************************************************************/

module Sequencial_Multiplier #(parameter WIDTH = 10, WIDTH_MLTND = 5)
(
    input              clk,
    input              rst,
    input              enable,
    input  [WIDTH-1:0] data,       // Multiplicand[9:5], Multiplier[4:0]
    output [WIDTH-1:0] out,
    // testing
    output [WIDTH_MLTND-1:0] con,
    output                   en_mux,
    output                   en_ashr,
    output                   en_acc,
    output                   en_count,
    output                   rst_count,
    output                   ready,
    output [WIDTH:0]         DO_acc
);

localparam [4:0] init_acc = 5'b00000;
// wire output ashr
wire ready_ashr_w;
wire [WIDTH:0] out_ashr_w;
// wire output accumulator
wire [WIDTH:0]     DO_acc_w;
// wire output counter param
wire [WIDTH_MLTND-1:0] count_out_w;
// wire output muxs
wire [WIDTH:0] y_mux_w;
wire [WIDTH:0] y_mux_ashr_w;
wire           y_mux_en_reg_w;
// wire output register in
wire [WIDTH:0] out_register_in_w;
// wire output register out
wire [WIDTH:0] out_register_out_w;
// wire output register results
wire [WIDTH-1:0] out_register_results_w;

// wire output FSM
wire en_mux_w;
wire en_ashr_w;
wire en_acc_w;
wire en_count_w;
wire rst_count_w;
wire ready_fsm_w;

assign out = out_register_results_w;

// testing
assign con = count_out_w;
assign en_mux = en_mux_w;
assign en_ashr = en_ashr_w;
assign en_acc = en_acc_w;
assign en_count = en_count_w;
assign rst_count = rst_count_w;
assign ready = ready_fsm_w;

assign DO_acc = DO_acc_w;

// =================== REGISTERS =====================//
// This is used to the multiplier algorithm
Register #( .n(11) ) reg_out 
(
    .rst(rst),
    .clk(clk),
    .Enable(y_mux_en_reg_w),
    .DI(y_mux_w),
    .DO(out_register_out_w)
);

// This is used to store the results of the multiplier algorithm
Register #( .n(10) ) reg_results 
(
    .rst(rst),
    .clk(clk),
    .Enable(ready_fsm_w),
    .DI(out_register_out_w[WIDTH:1]),
    .DO(out_register_results_w)
);


// ============= Counter Param ========================= //
Counter_Param # (.n(5) ) Counter_bits 
(
    .clk(clk), 
    .rst(rst_count_w), 
    .enable(en_count_w), 
    .Q(count_out_w)    
);

// ========= Multiplexor 2to11 ========================= //
Mux2 #( .WIDTH(11)) mux2_11_init
(
    .d0(out_ashr_w), 
    .d1({init_acc,data[4:0],1'b0}),
    .s(en_mux_w),
    .y(y_mux_w)
);

Mux2 #( .WIDTH(11)) mux_acc_or_reg
(
    .d0(out_register_out_w), 
    .d1(DO_acc_w),
    .s(en_acc_w),
    .y(y_mux_ashr_w)
);

Mux2 #( .WIDTH(1)) mux_en_reg
(
    .d0(ready_ashr_w), 
    .d1(en_mux_w),
    .s(en_mux_w),
    .y(y_mux_en_reg_w)
);


// =========== Finite State Machine =============== //
FSM #( .WIDTH_MUL(5) ) fsm 
(
    .clk(clk),
    .rst(rst),
    .Qn(out_register_out_w[0]),
    .Qlsb(out_register_out_w[1]),
    .enable_fsm(enable),
    .count(count_out_w),
    .en_mux(en_mux_w),
    .en_ashr(en_ashr_w),
    .en_acc(en_acc_w),
    .en_count(en_count_w),
    .rst_count(rst_count_w),
    .ready(ready_fsm_w)
);

// =========== Arithmetic Shift Right ================== //
Arithmeric_shift_rigth #( .WIDTH(11) ) ashr 
(
    .clk(clk),
    .enable(en_ashr_w),
    .ready(ready_ashr_w),
    .data(DO_acc_w),
    .out(out_ashr_w)
);


// =============== Accumulator Operation ================== //
Accumulator #( .WIDTH(11),  .WIDTH_ACC(5),  .WIDTH_MUL(5)) acc 
(
    .clk(clk),
    .rst(rst),
    .DI(out_register_out_w),
    .DI_MUL(data[9:5]),
    .enable(en_acc_w),
    .s(out_register_out_w[1:0]),
    .DO(DO_acc_w)
);


endmodule