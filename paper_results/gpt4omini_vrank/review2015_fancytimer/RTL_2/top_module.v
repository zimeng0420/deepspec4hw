module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    reg [3:0] delay;
    reg [3:0] state; // State variable
    reg [9:0] counter; // 10-bit counter for counting
    reg [3:0] current_delay; // To track the current counting delay
    reg [3:0] delay_counter; // To count down from delay

    parameter IDLE = 0, PATTERN = 1, SHIFT_DELAY = 2, COUNTING = 3, DONE = 4;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            count <= 4'bxxxx; // Don't care
            counter <= 0;
            delay <= 0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 0;
                    done <= 0;
                    if (data) begin
                        state <= PATTERN;
                        delay <= 0; // Reset delay
                    end
                end

                PATTERN: begin
                    if (data) begin
                        if (delay < 4) // Shift into delay value
                            delay[3 - delay] <= 1;
                        delay <= delay + 1;
                        if (delay == 4) begin
                            state <= SHIFT_DELAY;
                        end
                    end else begin
                        delay <= 0; // Resetting if the pattern is invalid
                    end
                end

                SHIFT_DELAY: begin
                    current_delay <= delay; // Store delay value
                    counting <= 1;
                    state <= COUNTING;
                    counter <= 0;
                    delay_counter <= current_delay; // Initialize delay counter
                end

                COUNTING: begin
                    if (counter < (current_delay + 1) * 1000) begin
                        count <= delay_counter;
                        counter <= counter + 1;
                    end else begin
                        counting <= 0;
                        done <= 1;
                        count <= 4'bxxxx; // Don't care
                        state <= DONE;
                    end

                    if (counter % 1000 == 0 && delay_counter > 0) begin
                        delay_counter <= delay_counter - 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE; // Reset to IDLE state
                    end
                end
            endcase
        end
    end
endmodule