/**********************************************************************************************
 * Project Name       : Finite State Machine Sequencial Multiplier
 * Engineer           : Daniel Diaz Platon
 * Module description : 
 * Target             : 5CSXFC6D6F31C6
 * Date               : 2024/05/02
 **********************************************************************************************/
// WIDTH_MUL is size on bits of multiplier
module FSM #(parameter WIDTH_MUL = 5)
(
    input                 clk,
    input                 rst,
    input                 Qn,
    input                 Qlsb,
    input                 enable_fsm,
    input [WIDTH_MUL-1:0] count,
    output reg            en_mux,
    output reg            en_ashr,
    output reg            en_acc,
    output reg            en_count,
    output reg            rst_count,
    output reg            ready
);

localparam [2:0] S_INIT    = 3'b000;
localparam [2:0] S_IDLE    = 3'b001;
localparam [2:0] S_01      = 3'b011;
localparam [2:0] S_10      = 3'b010;
localparam [2:0] S_11_00   = 3'b110;
localparam [2:0] S_READY   = 3'b100;
localparam [2:0] S_WAIT    = 3'b101;

reg [2:0]           state = S_INIT;

always @(posedge rst, posedge clk) 
    begin
        if (rst) 
            begin
                state <= S_INIT;
            end 
        else 
            begin
                case (state)
                    S_INIT: if (enable_fsm == 1'b1) 
                                begin
                                    if ({Qlsb,Qn} == 2'b01) 
                                        begin
                                            state <= S_01;
                                        end
                                    else if ({Qlsb,Qn} == 2'b10) 
                                        begin
                                            state <= S_10;
                                        end
                                    else
                                        begin
                                            state <= S_11_00;
                                        end
                                end
                    S_IDLE: if (count == 3'b101 ) 
                                begin
                                    state <= S_READY;
                                end 
                            else 
                                begin
                                    if ({Qlsb,Qn} == 2'b01) 
                                        begin
                                            state <= S_01;
                                        end
                                    else if ({Qlsb,Qn} == 2'b10) 
                                        begin
                                            state <= S_10;
                                        end
                                    else if ({Qlsb,Qn} == 2'b00) 
                                        begin
                                            state <= S_11_00;
                                        end
                                    else if ({Qlsb,Qn} == 2'b11) 
                                        begin
                                            state <= S_11_00;
                                        end
                                end
                    S_01: 
                                begin
                                    state <= S_11_00;
                                end 
                    S_10: 
                                begin
                                    state <= S_11_00;
                                end 
                    S_11_00 :
                                begin
                                    state <= S_WAIT;
                                end 
                    S_READY :
                                begin
                                    state <= S_INIT;
                                end
                    S_WAIT:    
                                begin
                                    state <= S_IDLE;
                                end 
                    default: 
                        begin
                            state <= S_INIT;
                        end
                endcase
            end
    end


always @(state) 
    begin
        case (state)
            S_INIT: 
                begin
                    en_mux    = 1'b1;
                    en_ashr   = 1'b0;
                    en_acc    = 1'b0;
                    en_count  = 1'b0;
                    rst_count = 1'b1;
                    ready     = 1'b0;       
                end
            S_IDLE: 
                begin
                    en_mux    = 1'b0;
                    en_ashr   = 1'b0;
                    en_acc    = 1'b0;
                    en_count  = 1'b0;
                    rst_count = 1'b0;
                    ready     = 1'b0;
                end
            S_01: 
                begin
                    en_mux    = 1'b0;
                    en_ashr   = 1'b0;
                    en_acc    = 1'b1;
                    en_count  = 1'b0;
                    rst_count = 1'b0;
                    ready     = 1'b0;
                end      
            S_10: 
                begin
                    en_mux    = 1'b0;
                    en_ashr   = 1'b0;
                    en_acc    = 1'b1;
                    en_count  = 1'b0;
                    rst_count = 1'b0;
                    ready     = 1'b0;
                end            
            S_11_00 :
                begin
                    en_mux    = 1'b0;
                    en_ashr   = 1'b1;
                    en_acc    = 1'b0;
                    en_count  = 1'b1;
                    rst_count = 1'b0;
                    ready     = 1'b0;
                end      
            S_READY :
                begin
                    en_mux    = 1'b0;
                    en_ashr   = 1'b0;
                    en_acc    = 1'b0;
                    en_count  = 1'b0;
                    rst_count = 1'b0;
                    ready     = 1'b1;
                end      
            S_WAIT :
                begin
                    en_mux    = 1'b0;
                    en_ashr   = 1'b0;
                    en_acc    = 1'b0;
                    en_count  = 1'b0;
                    rst_count = 1'b0;
                    ready     = 1'b0;
                end      
            default: 
                begin
                    en_mux    = 1'b0;
                    en_ashr   = 1'b0;
                    en_acc    = 1'b0;
                    en_count  = 1'b0;
                    rst_count = 1'b0;
                    ready     = 1'b0;
                end
        endcase
    end

endmodule