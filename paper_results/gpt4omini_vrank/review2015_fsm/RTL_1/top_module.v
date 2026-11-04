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

// State Encoding
typedef enum reg [2:0] {
    IDLE,
    CHECK_PATTERN,
    SHIFT,
    COUNTING,
    DONE
} state_t;

state_t current_state, next_state;
reg [3:0] shift_count;

// State Transition
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_count <= 0;
    end else begin
        current_state <= next_state;
    end
end

// Next State Logic
always @* begin
    next_state = current_state;
    shift_ena = 0;
    counting = 0;
    done = 0;

    case (current_state)
        IDLE: begin
            if (data == 1) begin
                next_state = CHECK_PATTERN;
            end
        end
        CHECK_PATTERN: begin
            if (data == 1) begin
                // Check for pattern 1101
                if ( /* Check previous data bits to confirm 1101 */ ) begin
                    next_state = SHIFT;
                    shift_count = 4; // Start shifting for 4 cycles
                end else begin
                    next_state = IDLE;
                end
            end
        end
        SHIFT: begin
            shift_ena = 1;
            if (shift_count > 0) begin
                shift_count = shift_count - 1;
            end else begin
                next_state = COUNTING;
            end
        end
        COUNTING: begin
            counting = 1;
            if (done_counting) begin
                done = 1;
                next_state = DONE;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
                done = 0; // Clear done flag
            end
        end
    endcase
end

endmodule