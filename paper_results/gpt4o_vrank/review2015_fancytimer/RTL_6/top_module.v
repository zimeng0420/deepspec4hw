module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    reg [3:0] state;
    reg [3:0] delay;
    reg [13:0] cycle_counter;
    
    reg [3:0] pattern_shift_reg;
    reg [2:0] bit_count;
    
    parameter IDLE = 4'd0;
    parameter PATTERN_DETECT = 4'd1;
    parameter READ_DELAY = 4'd2;
    parameter COUNTDOWN = 4'd3;
    parameter WAIT_FOR_ACK = 4'd4;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            counting <= 0;
            delay <= 0;
            cycle_counter <= 0;
            pattern_shift_reg <= 0;
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    counting <= 0;
                    pattern_shift_reg <= {pattern_shift_reg[2:0], data};
                    if (pattern_shift_reg == 4'b1101)
                        state <= READ_DELAY;
                end
                READ_DELAY: begin
                    delay <= {delay[2:0], data};
                    bit_count <= bit_count + 1'b1;
                    if (bit_count == 3) begin
                        cycle_counter <= ({delay[2:0], data} + 1) * 1000;
                        state <= COUNTDOWN;
                        counting <= 1;
                        bit_count <= 0;
                    end
                end
                COUNTDOWN: begin
                    cycle_counter <= cycle_counter - 1;
                    if (cycle_counter == 0) begin
                        counting <= 0;
                        done <= 1;
                        state <= WAIT_FOR_ACK;
                    end
                end
                WAIT_FOR_ACK: begin
                    if (ack) 
                        state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

    assign count = counting ? cycle_counter[13:10] : 4'hx;

endmodule