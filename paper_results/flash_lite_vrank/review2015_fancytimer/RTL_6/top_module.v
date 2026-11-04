module top_module(
	input wire clk,
	input wire reset,
	input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    parameter IDLE = 0;
    parameter READ_PATTERN = 1;
    parameter READ_DELAY = 2;
    parameter COUNTING = 3;
    parameter DONE = 4;

    reg [2:0] state;
    reg [3:0] pattern_buffer;
    reg [3:0] delay;
    reg [11:0] counter;
    reg [3:0] count_internal;
    reg [2:0] bit_counter;


    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            pattern_buffer <= 4'b0;
            delay <= 4'b0;
            counter <= 12'b0;
            count_internal <= 4'b0;
            bit_counter <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 0;
                    done <= 0;
                    bit_counter <= 3'b0;
                    pattern_buffer <= {pattern_buffer[2:0], data};
                    if (pattern_buffer == 4'b1101) begin
                        state <= READ_DELAY;
                    end
                end
                READ_DELAY: begin
                    bit_counter <= bit_counter + 1;
                    delay[3-bit_counter] <= data;
                    if (bit_counter == 3) begin
                        state <= COUNTING;
                        counter <= 0;
                        count_internal <= delay;
                        counting <= 1;
                    end
                end
                COUNTING: begin
                    if (counter < ((delay + 1) * 1000) - 1) begin
                        counter <= counter + 1;
                    end else begin
                        counter <= 0;
                        count_internal <= count_internal - 1;
                        if (count_internal == 0) begin
                            state <= DONE;
                            counting <= 0;
                            done <= 1;
                        end
                    end
                end
                DONE: begin
                    counting <= 0;
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end
                end
            endcase
        end
    end

    assign count = (counting) ? count_internal : 4'b0;

endmodule