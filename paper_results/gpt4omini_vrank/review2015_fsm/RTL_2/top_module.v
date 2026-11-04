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

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        PATTERN_DETECTED = 3'b001,
        SHIFT_ENABLE = 3'b010,
        WAIT_COUNTING = 3'b011,
        TIMER_DONE = 3'b100
    } state_t;

    state_t current_state, next_state;
    reg [1:0] shift_count; // To count the 4 clock cycles for shift_ena

    // State transition logic
    always_ff @(posedge clk or posedge reset) begin
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

    // Next state logic
    always_comb begin
        next_state = current_state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (current_state)
            IDLE: begin
                if (data == 1'b1) begin
                    // Check for pattern 1101
                    // Implement shift register logic to verify the sequence (not shown here)
                    // Placeholder condition for detected pattern
                    if (/* pattern detected */) begin
                        next_state = PATTERN_DETECTED;
                    end
                end
            end
            
            PATTERN_DETECTED: begin
                shift_ena = 1;
                if (shift_count < 2'b11) begin
                    shift_count = shift_count + 1;
                    next_state = SHIFT_ENABLE;
                end else begin
                    shift_count = 0;
                    next_state = WAIT_COUNTING;
                    counting = 1;
                end
            end

            WAIT_COUNTING: begin
                counting = 1;
                if (done_counting) begin
                    next_state = TIMER_DONE;
                end
            end
            
            TIMER_DONE: begin
                done = 1;
                if (ack) begin
                    next_state = IDLE; // Reset to idle waiting for next pattern
                end
            end
            
        endcase
    end

endmodule