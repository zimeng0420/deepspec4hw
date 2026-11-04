module top_module(
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    // Define state parameters
    typedef enum logic [2:0] {
        IDLE,    // Waiting for the pattern 1101
        PATTERN, // Pattern has been matched
        SHIFT,   // Shift in 4 more bits
        COUNT,   // Waiting for the counter
        DONE     // Notify user and wait for acknowledgment
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_counter;

    // State transition logic (sequential)
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always_comb begin
        // Default assignments
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                if (data == 1'b1 && bit_counter == 3'd0) begin // First 1 of 1101
                    bit_counter = bit_counter + 1'b1;
                end else if (data == 1'b1 && bit_counter == 3'd1) begin // Second 1 of 1101
                    bit_counter = bit_counter + 1'b1;
                end else if (data == 1'b0 && bit_counter == 3'd2) begin // 0 of 1101
                    bit_counter = bit_counter + 1'b1;
                end else if (data == 1'b1 && bit_counter == 3'd3) begin // Last 1 of 1101
                    next_state = PATTERN;
                end else if (data == 1'b0 || bit_counter > 3'd0) begin
                    bit_counter = 3'd0; // Reset counter if pattern breaks
                end
            end
            PATTERN: begin
                shift_ena = 1'b1;
                bit_counter = 3'd0;
                next_state = SHIFT;
            end
            SHIFT: begin
                shift_ena = 1'b1;
                if (bit_counter == 3'd3)
                    next_state = COUNT;
                else
                    bit_counter = bit_counter + 1'b1;
            end
            COUNT: begin
                counting = 1'b1;
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                done = 1'b1;
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end
    
    // Counter for SHIFT state
    always_ff @(posedge clk or posedge reset) begin
        if (reset) 
            bit_counter <= 3'd0;
        else if (state == IDLE || state == PATTERN)
            bit_counter <= 3'd0;
    end

endmodule