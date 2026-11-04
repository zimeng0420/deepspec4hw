module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    reg [3:0] state;
    reg [3:0] delay;
    reg [2:0] bit_counter;
    reg [10:0] cycle_counter; // 11 bits to count up to 2000*1000 cycles
    
    // State machine states
    localparam IDLE        = 4'b0000,
               DETECT_1    = 4'b0001,
               DETECT_11   = 4'b0010,
               DETECT_110  = 4'b0011,
               DETECT_1101 = 4'b0100,
               LOAD_DELAY  = 4'b0101,
               COUNTING    = 4'b0110,
               DONE_STATE  = 4'b0111;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            delay <= 4'b0;
            bit_counter <= 3'b0;
            cycle_counter <= 11'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    counting <= 0;
                    count <= 4'bxxxx;
                    if (data) state <= DETECT_1;
                end
                DETECT_1: state <= data ? DETECT_11 : IDLE;
                DETECT_11: state <= data ? DETECT_11 : DETECT_110;
                DETECT_110: state <= data ? DETECT_1101 : IDLE;
                DETECT_1101: begin
                    if (data) begin
                        state <= LOAD_DELAY;
                        delay <= {delay[2:0], data};
                        bit_counter <= 3'd1;
                    end else state <= IDLE;
                end
                LOAD_DELAY: begin
                    delay <= {delay[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 3'd3) begin
                        state <= COUNTING;
                        counting <= 1;
                        cycle_counter <= 11'b0;
                        count <= delay;
                    end
                end
                COUNTING: begin
                    cycle_counter <= cycle_counter + 1;
                    if (cycle_counter == 11'd999) begin
                        cycle_counter <= 0;
                        if (count == 0) begin
                            counting <= 0;
                            done <= 1;
                            state <= DONE_STATE;
                        end else
                            count <= count - 1;
                    end
                end
                DONE_STATE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end
                end
            endcase
        end
    end
endmodule