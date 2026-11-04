module top_module(
	input wire clk,
	input wire reset,
	input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    // State Definitions
    parameter IDLE = 0;
    parameter READ_PATTERN = 1;
    parameter READ_DELAY = 2;
    parameter COUNTING = 3;
    parameter DONE_ACK = 4;

    // Internal Signals
    reg [2:0] state;
    reg [3:0] pattern_buffer;
    reg [3:0] delay;
    reg [11:0] counter;
    reg [3:0] count_internal;
    reg [3:0] delay_internal;
    reg [3:0] count_display;
    
    // State Machine Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counting <= 1'b0;
            done <= 1'b0;
            pattern_buffer <= 4'b0000;
            delay <= 4'b0000;
            counter <= 12'd0;
            count_internal <= 4'b0000;
            delay_internal <= 4'b0000;
            count_display <= 4'b0000;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    pattern_buffer <= {pattern_buffer[2:0], data};
                    if (pattern_buffer == 4'b1101) begin
                        state <= READ_DELAY;
                    end
                end
                READ_DELAY: begin
                    delay <= {delay[2:0], data};
                    state <= COUNTING;
                    counter <= 12'd0;
                    count_internal <= delay;
                    delay_internal <= delay;
                    count_display <= delay;
                    counting <= 1'b1;
                end
                COUNTING: begin
                    if (counter < 1000) begin
                        counter <= counter + 1'b1;
                    end else begin
                        counter <= 12'd0;
                        if (count_internal > 0) begin
                            count_internal <= count_internal - 1'b1;
                            count_display <= count_internal;
                        end else begin
                            state <= DONE_ACK;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end
                    end
                end
                DONE_ACK: begin
                    counting <= 1'b0;
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

    // Output Assignments
    assign count = count_display;

endmodule