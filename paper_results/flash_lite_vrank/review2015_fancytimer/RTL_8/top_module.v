module top_module(
	input wire clk,
	input wire reset,
	input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    // State definitions
    localparam IDLE = 0;
    localparam READ_PATTERN = 1;
    localparam READ_DELAY = 2;
    localparam COUNTING = 3;
    localparam DONE = 4;

    // Internal signals
    reg [2:0] state;
    reg [3:0] pattern_buffer;
    reg [3:0] delay;
    reg [15:0] counter;
    reg [3:0] remaining_delay;
    reg [3:0] count_internal;

    // State machine logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            pattern_buffer <= 4'b0000;
            delay <= 4'b0000;
            counter <= 16'b0;
            remaining_delay <= 4'b0000;
            count_internal <= 4'b0000;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 0;
                    done <= 0;
                    count_internal <= 4'b0000;
                    pattern_buffer <= {pattern_buffer[2:0], data};
                    if (pattern_buffer == 4'b1101) begin
                        state <= READ_DELAY;
                    end
                end
                READ_DELAY: begin
                    delay <= {delay[2:0], data};
                    state <= COUNTING;
                    remaining_delay <= delay;
                    counter <= 0;
                end
                COUNTING: begin
                    counting <= 1;
                    if (counter == 999) begin
                        counter <= 0;
                        count_internal <= count_internal + 1;
                        remaining_delay <= remaining_delay - 1;
                    end else begin
                        counter <= counter + 1;
                    end

                    if(remaining_delay == 0 && counter == 999) begin
                        state <= DONE;
                        counting <= 0;
                    end
                end
                DONE: begin
                    counting <= 0;
                    done <= 1;
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end
                end
            endcase
        end
    end

    // Output assignments
    assign count = (counting) ? remaining_delay : 4'b0000;

endmodule