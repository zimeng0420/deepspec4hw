module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,       // Waiting for in[3]=1
        BYTE_1,     // Byte 1 detected
        BYTE_2,     // Byte 2 detected
        BYTE_3      // Byte 3 detected
    } state_t;
    
    state_t state, next_state;
    logic [1:0] byte_count; // Counter for number of bytes in the message
    
    // Output logic
    assign done = (state == BYTE_3); // Done is asserted when the FSM has reached BYTE_3

    // State transition logic
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        next_state = state; // Default: remain in the current state
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE_1; // Start of new message
                end
            end
            BYTE_1: begin
                next_state = BYTE_2; // Proceed to receive byte 2
            end
            BYTE_2: begin
                next_state = BYTE_3; // Proceed to receive byte 3
            end
            BYTE_3: begin
                if (in[3]) begin
                    next_state = BYTE_1; // Start new message if in[3]=1
                end else begin
                    next_state = IDLE;  // Otherwise, go back to IDLE
                end
            end
            default: next_state = IDLE; // Safety net
        endcase
    end

endmodule