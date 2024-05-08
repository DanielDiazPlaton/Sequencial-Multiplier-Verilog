/**********************************************************************************************
 * Project Name       : BCD Convert
 * Engineer           : Daniel Diaz Platon
 * Module description : 
 * Date               : 2024/02/24
 **********************************************************************************************/

 module BCDConvert(
    input           clk,
    input           en,
    input    [9:0]  bin_d_in,
    output   [11:0] bcd_d_out,
    output          rdy
 );

// State variables
parameter IDLE  = 3'b000;
parameter SETUP = 3'b001;
parameter ADD   = 3'b010;
parameter SHIFT = 3'b011;
parameter DONE  = 3'b100;

reg [21:0] bcd_data    = 0;
reg [2:0]  state       = 0;
reg        busy        = 0;
reg [3:0]  sh_counter  = 0;
reg [1:0]  add_counter = 0;
reg        result_rdy  = 0;

always @(posedge clk) begin
    if (en) begin
       if (~busy) begin
            bcd_data    <= {12'b0, bin_d_in};
            state       <= SETUP;
       end 
    end

    case(state)
        
            IDLE:
                begin
                    result_rdy  <= 0;
                    busy        <= 0;
                end
                
            SETUP:
                begin
                busy        <= 1;
                state       <= ADD;
                end
                    
            ADD:
                begin
                
                case(add_counter)
                    0:
                        begin
                        if(bcd_data[13:10] > 3'b100)
                            begin
                                bcd_data[21:10] <= bcd_data[21:10] + 2'b11;
                            end
                            add_counter <= add_counter + 1'b1;
                        end
                    
                    1:
                        begin
                        if(bcd_data[17:14] > 3'b100)
                            begin
                                bcd_data[21:14] <= bcd_data[21:14] + 2'b11;
                            end
                            add_counter <= add_counter + 1'b1;
                        end
                        
                    2:
                        begin
                        if((add_counter == 2'b10) && (bcd_data[21:18] > 3'b100))
                            begin
                                bcd_data[21:18] <= bcd_data[21:18] + 2'b11;
                            end
                            add_counter <= 1'b0;
                            state   <= SHIFT;
                        end
                    endcase
                end
                
            SHIFT:
                begin
                sh_counter  <= sh_counter + 1'b1;
                bcd_data    <= bcd_data << 1'b1;
                
                if(sh_counter == 9)
                    begin
                    sh_counter  <= 1'b0;
                    state       <= DONE;
                    end
                else
                    begin
                    state   <= ADD;
                    end

                end
 
            
            DONE:
                begin
                result_rdy  <= 1'b1;
                state       <= IDLE;
                end
            default:
                begin
                state <= IDLE;
                end
            
            endcase
            
end
    assign bcd_d_out    = bcd_data[21:10];
    assign rdy          = result_rdy;

endmodule