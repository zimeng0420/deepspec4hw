module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack 
);
    reg [3:0] delay;
    reg [3:0] remaining_time;
    reg [3:0] bit_counter;
    reg [2:0] state; // 0: searching, 1: shifting, 2: counting, 3: done
    reg [9:0] cycle_counter;

    localparam WAIT_PATTERN = 3'd0;
    localparam SHIFT_DELAY = 3'd1;
    localparam COUNTING = 3'd2;
    localparam DONE_STATE = 3'd3;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_PATTERN;
            counting <= 0;
            done <= 0;
            count <= 4'bxxxx; // don't care value
            cycle_counter <= 0;
            bit_counter <= 0;
            remaining_time <= 0;
        end else begin
            case (state)
                WAIT_PATTERN: begin
                    if (data == 1) begin
                        // Check the pattern 1101
                        if (bit_counter == 3) begin
                            if (data == 1) begin
                                bit_counter <= 0;
                                state <= SHIFT_DELAY;
                            end
                        end else begin
                            if (bit_counter == 0 && data == 1) 
                                bit_counter <= 1;
                            else if (bit_counter == 1 && data == 1) 
                                bit_counter <= 2;
                            else if (bit_counter == 2 && data == 0) 
                                bit_counter <= 3;
                            else 
                                bit_counter <= 0; // Reset if pattern fails
                        end
                    end
                end

                SHIFT_DELAY: begin
                    if (bit_counter < 4) begin
                        delay[3 - bit_counter] <= data; // Shift in the next bit
                        bit_counter <= bit_counter + 1;
                    end
                    if (bit_counter == 4) begin
                        counting <= 1;
                        remaining_time <= delay + 1; // Start counting (delay + 1)
                        state <= COUNTING;
                        bit_counter <= 0;
                    end
                end

                COUNTING: begin
                    if (cycle_counter < (remaining_time * 1000)) begin
                        cycle_counter <= cycle_counter + 1;
                        if (cycle_counter % 1000 == 0) begin
                            count <= remaining_time; // Output current remaining time
                            if (remaining_time > 0)
                                remaining_time <= remaining_time - 1;
                        end
                    end else begin
                        counting <= 0;
                        done <= 1; // Notify the user the timer has timed out
                        state <= DONE_STATE;
                        cycle_counter <= 0;
                    end
                end

                DONE_STATE: begin
                    done <= 1;
                    count <= 4'bxxxx; // don't care value
                    if (ack) begin
                        state <= WAIT_PATTERN;
                        done <= 0; // Reset done
                    end
                end

                default: state <= WAIT_PATTERN; // Handle unexpected states
            endcase
        end
    end
endmodule