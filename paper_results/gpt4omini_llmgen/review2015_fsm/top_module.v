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
        S_IDLE        = 3'b000, // Waiting for the sequence 1101
        S_PATTERN     = 3'b001, // First bit of the pattern
        S_PATTERN1    = 3'b010, // Second bit of the pattern
        S_PATTERN2    = 3'b011, // Third bit of the pattern
        S_PATTERN3    = 3'b100, // Fourth bit of the pattern
        S_SHIFT       = 3'b101, // Shift enable state for 4 cycles
        S_COUNT       = 3'b110, // Waiting for counters to finish
        S_DONE        = 3'b111  // Timer finished state
    } state_t;

    state_t current_state, next_state;
    reg [1:0] shift_counter; // Counter for the 4 cycles of shift_ena

    // State Transition Logic
    always @(*) begin
        next_state = current_state; // Default to stay in the current state
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (current_state)
            S_IDLE: begin
                if (data) begin
                    next_state = S_PATTERN; // Start detecting the pattern
                end
            end
            S_PATTERN: begin
                if (data) begin
                    next_state = S_PATTERN1; // 1
                end else begin
                    next_state = S_IDLE; // Reset if pattern not matched
                end
            end
            S_PATTERN1: begin
                if (!data) begin
                    next_state = S_PATTERN2; // 0
                end else begin
                    next_state = S_IDLE; // Reset if pattern not matched
                end
            end
            S_PATTERN2: begin
                if (data) begin
                    next_state = S_PATTERN3; // 1
                end else begin
                    next_state = S_IDLE; // Reset if pattern not matched
                end
            end
            S_PATTERN3: begin
                if (!data) begin
                    shift_ena = 1; // 0 received, ready to shift
                    next_state = S_SHIFT; // Move to the shift state
                    shift_counter = 2'b00; // Initialize shift counter
                end else begin
                    next_state = S_IDLE; // Reset if pattern not matched
                end
            end
            S_SHIFT: begin
                if (shift_counter < 2'b11) begin
                    shift_ena = 1; // Enable shifting for 4 clock cycles
                    shift_counter = shift_counter + 1; // Increment shift counter
                end else begin
                    counting = 1; // After 4 cycles, start counting
                    next_state = S_COUNT;
                end
            end
            S_COUNT: begin
                if (done_counting) begin
                    done = 1; // Timer finished
                    next_state = S_DONE; // Move to done state
                end
            end
            S_DONE: begin
                if (ack) begin
                    next_state = S_IDLE; // Acknowledge received, reset to idle
                end
            end
        endcase
    end

    // State Update Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S_IDLE; // Reset state to idle
        end else begin
            current_state <= next_state; // Update to next state
        end
    end

endmodule