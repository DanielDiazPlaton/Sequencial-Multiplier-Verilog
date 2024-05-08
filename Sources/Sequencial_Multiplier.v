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
    // output [WIDTH-1:0] out,
    output             neg,
    
    // output display
    output            seg_a0,
    output            seg_b0,
    output            seg_c0,
    output            seg_d0,
    output            seg_e0,
    output            seg_f0,
    output            seg_g0,

    output            seg_a1,
    output            seg_b1,
    output            seg_c1,
    output            seg_d1,
    output            seg_e1,
    output            seg_f1,
    output            seg_g1,

    output            seg_a2,
    output            seg_b2,
    output            seg_c2,
    output            seg_d2,
    output            seg_e2,
    output            seg_f2,
    output            seg_g2

    //  ===============     signals testing  =========  //
    // output [WIDTH_MLTND-1:0] con,
    // output                   en_mux,
    // output                   en_ashr,
    // output                   en_acc,
    // output                   en_count,
    // output                   rst_count,
    // output                   ready,
    // output                   ready_bcd,
    // // output [WIDTH:0]         DO_acc,
    // output [11:0]            out_final_results,
    // output [11:0]            bcd_d_out,
    //  ===============     signals testing  =========  //
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
// wire [WIDTH:0] out_register_in_w;
// wire output register out
wire [WIDTH:0] out_register_out_w;
// wire output register flag
wire           out_register_flag_w;
// wire output register results
wire [WIDTH-1:0] out_register_results_w;
// wire output register results
wire [11:0] out_final_results_w;

// wire output FSM
wire en_mux_w;
wire en_ashr_w;
wire en_acc_w;
wire en_count_w;
wire en_bcd_w;
wire rst_count_w;
wire ready_fsm_w;

// Mux Complement 2
wire [WIDTH-1:0] DO_mux_cmpl_w;

// BCD Module
wire [11:0] bcd_d_out_w;
wire rdy_w;

// Display 0
wire seg_a0_w; 
wire seg_b0_w; 
wire seg_c0_w; 
wire seg_d0_w; 
wire seg_e0_w; 
wire seg_f0_w; 
wire seg_g0_w; 

// Display 1
wire seg_a1_w;
wire seg_b1_w;
wire seg_c1_w;
wire seg_d1_w;
wire seg_e1_w;
wire seg_f1_w;
wire seg_g1_w;

// Display 2
wire seg_a2_w;
wire seg_b2_w;
wire seg_c2_w;
wire seg_d2_w;
wire seg_e2_w;
wire seg_f2_w;
wire seg_g2_w;

// Display
assign seg_a0 = seg_a0_w;  
assign seg_b0 = seg_b0_w;  
assign seg_c0 = seg_c0_w;  
assign seg_d0 = seg_d0_w;  
assign seg_e0 = seg_e0_w;  
assign seg_f0 = seg_f0_w;  
assign seg_g0 = seg_g0_w;  
 
assign seg_a1 = seg_a1_w; 
assign seg_b1 = seg_b1_w; 
assign seg_c1 = seg_c1_w; 
assign seg_d1 = seg_d1_w; 
assign seg_e1 = seg_e1_w; 
assign seg_f1 = seg_f1_w; 
assign seg_g1 = seg_g1_w; 
 
assign seg_a2 = seg_a2_w; 
assign seg_b2 = seg_b2_w; 
assign seg_c2 = seg_c2_w; 
assign seg_d2 = seg_d2_w; 
assign seg_e2 = seg_e2_w; 
assign seg_f2 = seg_f2_w; 
assign seg_g2 = seg_g2_w; 

// The signal might be invert because the output pin is pull up
assign neg = ~out_register_flag_w;

// ========================================= SIGNALS TESTING =========================================== //
// assign con = count_out_w;
// assign en_mux = en_mux_w;
// assign en_ashr = en_ashr_w;
// assign en_acc = en_acc_w;
// assign en_count = en_count_w;
// assign rst_count = rst_count_w;
// assign ready = ready_fsm_w;
// assign ready_bcd = en_bcd_w;
// assign out_final_results = out_final_results_w;
// assign bcd_d_out = bcd_d_out_w;

// assign DO_acc = DO_acc_w;

//Output results
// assign out = out_register_results_w;

// ========================================= END TESTING =========================================== //



// =================== REGISTERS =====================//
// This is used to the multiplier algorithm
Register #( .n(1) ) reg_flag 
(
    .rst(~rst),
    .clk(clk),
    .Enable(rdy_w),
    .DI(((data[WIDTH-1] == 1'b1) && (data[WIDTH_MLTND-1] == 1'b0)) ? 1'b1: 
             ((data[WIDTH-1] == 1'b0) && (data[WIDTH_MLTND-1] == 1'b1)) ? 1'b1:
             1'b0),
    .DO(out_register_flag_w)
);

// This is used to the multiplier algorithm
Register #( .n(11) ) reg_out 
(
    .rst(~rst),
    .clk(clk),
    .Enable(y_mux_en_reg_w),
    .DI(y_mux_w),
    .DO(out_register_out_w)
);

// This is used to store the results of the multiplier algorithm
Register #( .n(10) ) reg_results 
(
    .rst(~rst),
    .clk(clk),
    .Enable(ready_fsm_w),
    .DI(out_register_out_w[WIDTH:1]),
    .DO(out_register_results_w)
);

// This is used to store the final results of the BCD
Register #( .n(12) ) reg_final 
(
    .rst(~rst),
    .clk(clk),
    .Enable(rdy_w),
    .DI(bcd_d_out_w),
    .DO(out_final_results_w)
);


// ============= Counter Param ========================= //
// Counter the number of bits in the multiplier to stop the FSM.
Counter_Param # (.n(5) ) Counter_bits 
(
    .clk(clk), 
    .rst(rst_count_w), 
    .enable(en_count_w), 
    .Q(count_out_w)    
);

// ========= Multiplexor 2to11 ========================= //
// Select data input between init value or aritmetic shift output
Mux2 #( .WIDTH(11)) mux2_11_init
(
    .d0(out_ashr_w), 
    .d1({init_acc,data[4:0],1'b0}),
    .s(en_mux_w),
    .y(y_mux_w)
);

// Select enable input to the reg_out between enable mux or ready aritmetic shift
Mux2 #( .WIDTH(1)) mux_en_reg
(
    .d0(ready_ashr_w), 
    .d1(en_mux_w),
    .s(en_mux_w),
    .y(y_mux_en_reg_w)
);

// Select if convert negative number before BCD execution 
Mux_cmpl2 #(.n(10)) Mux_cmpl2 (
    .sel(out_register_results_w[WIDTH-1]),
    .DI(out_register_results_w),
    .DO(DO_mux_cmpl_w)
);

// BCD Convert
BCDConvert BCD (
    .clk(clk),
    .en(en_bcd_w),
    .bin_d_in(DO_mux_cmpl_w),
    .bcd_d_out(bcd_d_out_w),
    .rdy(rdy_w)
);


// =========== Finite State Machine =============== //
FSM #( .WIDTH_MUL(5) ) fsm 
(
    .clk(clk),
    .rst(~rst),
    .Qn(out_register_out_w[0]),
    .Qlsb(out_register_out_w[1]),
    .enable_fsm(~enable),                      // As buttom is pull up, I have to revert the logic of enable 
    .count(count_out_w),
    .en_mux(en_mux_w),
    .en_ashr(en_ashr_w),
    .en_acc(en_acc_w),
    .en_count(en_count_w),
    .en_bcd(en_bcd_w),
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
    .rst(~rst),
    .DI(out_register_out_w),
    .DI_MUL(data[9:5]),
    .enable(en_acc_w),
    .s(out_register_out_w[1:0]),
    .DO(DO_acc_w)
);

// Seven Segment 0
SevenSegment SevenSegment0 (
    .w(out_final_results_w[3]),
    .x(out_final_results_w[2]),
    .y(out_final_results_w[1]),
    .z(out_final_results_w[0]),
    .seg_a(seg_a0_w),
    .seg_b(seg_b0_w),
    .seg_c(seg_c0_w),
    .seg_d(seg_d0_w),
    .seg_e(seg_e0_w),
    .seg_f(seg_f0_w),
    .seg_g(seg_g0_w)
);

// Seven Segment 1
SevenSegment SevenSegment1 (
    .w(out_final_results_w[7]),
    .x(out_final_results_w[6]),
    .y(out_final_results_w[5]),
    .z(out_final_results_w[4]),
    .seg_a(seg_a1_w),
    .seg_b(seg_b1_w),
    .seg_c(seg_c1_w),
    .seg_d(seg_d1_w),
    .seg_e(seg_e1_w),
    .seg_f(seg_f1_w),
    .seg_g(seg_g1_w)
);

// Seven Segment 2
SevenSegment SevenSegment2 (
    .w(out_final_results_w[11]),
    .x(out_final_results_w[10]),
    .y(out_final_results_w[9]),
    .z(out_final_results_w[8]),
    .seg_a(seg_a2_w),
    .seg_b(seg_b2_w),
    .seg_c(seg_c2_w),
    .seg_d(seg_d2_w),
    .seg_e(seg_e2_w),
    .seg_f(seg_f2_w),
    .seg_g(seg_g2_w)
);


endmodule