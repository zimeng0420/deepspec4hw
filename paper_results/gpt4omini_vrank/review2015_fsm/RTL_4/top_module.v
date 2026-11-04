module top_module(
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack
);

    typedef enum logic [2:0] {
        S_IDLE,
        S_PATTERN,
        S_SHIFT,
        S_COUNTING,
        S_DONE
    } state_t;

    state_t current_state, next_state;
    reg [1:0] shift_cnt;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S_IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            shift_cnt <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(current_state or data or done_counting or ack) begin
        case (current_state)
            S_IDLE: begin
                shift_ena = 0;
                counting = 0;
                done = 0;
                if (data) begin
                    // Assuming data is shifted in bit by bit and we're looking for 1101
                    if (shift_cnt == 3 && data == 1) begin
                        next_state = S_PATTERN;
                    end else if (shift_cnt < 3) begin
                        shift_cnt <= shift_cnt + 1;
                    end else begin
                        shift_cnt <= 0; // Reset for next pattern
                    end
                end
                next_state = S_IDLE;
            end

            S_PATTERN: begin
                // Check for pattern 1101 (could be replaced with an FSM for more bits)
                if (data) begin
                    shift_cnt <= 0; // Reset the counter for next bits
                    next_state = S_SHIFT;
                end else begin
                    next_state = S_IDLE;
                end
            end

            S_SHIFT: begin
                shift_ena = 1;
                if (shift_cnt < 4) begin
                    shift_cnt <= shift_cnt + 1;
                    next_state = S_SHIFT;
                end else begin
                    shift_ena = 0;
                    counting = 1;
                    next_state = S_COUNTING;
                end
            end

            S_COUNTING: begin
                if (done_counting) begin
                    counting = 0;
                    done = 1;
                    next_state = S_DONE;
                end else begin
                    next_state = S_COUNTING;
                end
            end

            S_DONE: begin
                if (ack) begin
                    done = 0;
                    shift_cnt = 0;
                    next_state = S_IDLE;
                end else begin
                    next_state = S_DONE;
                end
            end

            default: next_state = S_IDLE;

        endcase
    end

endmodule