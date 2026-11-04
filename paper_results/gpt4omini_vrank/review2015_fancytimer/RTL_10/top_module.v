module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    reg [1:0] state, next_state;
    reg [3:0] delay;
    reg [13:0] cycle_count;
    reg [9:0] total_count;

    parameter IDLE = 2'b00;
    parameter WAIT_PATTERN = 2'b01;
    parameter SHIFT_DELAY = 2'b10;
    parameter COUNTING = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            cycle_count <= 0;
            count <= 0;
            total_count <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                counting = 0;
                done = 0;
                if (data == 1) begin
                    next_state = WAIT_PATTERN;
                end
            end

            WAIT_PATTERN: begin
                if (cycle_count < 3) begin
                    if (data == (3'b110 >> cycle_count[1:0]) & 1) begin
                        cycle_count = cycle_count + 1;
                    end else begin
                        cycle_count = 0; // Reset if pattern doesn't match
                    end
                end else begin
                    next_state = SHIFT_DELAY;
                    cycle_count = 0; // Reset for shift
                end
            end

            SHIFT_DELAY: begin
                if (cycle_count < 4) begin
                    delay[3-cycle_count] = data; // Shift in 4 bits
                    cycle_count = cycle_count + 1;
                end else begin
                    total_count = (delay + 1) * 1000;
                    next_state = COUNTING;
                    counting = 1;
                    cycle_count = 0; // Reset for counting
                end
            end

            COUNTING: begin
                if (cycle_count < total_count) begin
                    count <= delay - (cycle_count / 1000);
                    cycle_count = cycle_count + 1;
                end else begin
                    done = 1;
                    counting = 0;
                    if (ack) begin
                        next_state = IDLE; // reset to initial state
                    end
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule