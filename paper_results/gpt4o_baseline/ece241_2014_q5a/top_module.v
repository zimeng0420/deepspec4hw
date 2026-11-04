module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State declarations
    typedef enum logic [1:0] {
        S0, // Initial state: not inverting
        S1  // Inverting state
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0; // Reset to initial state
        end else begin
            state <= next_state;
        end
    end

    // Next-state logic
    always @(*) begin
        case (state)
            S0: begin
                if (x == 1) // If input is 1, start inverting
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                next_state = S1; // Stay inverting
            end

            default: next_state = S0; // Default fallback state
        endcase
    end

    // Output logic (Moore FSM: output only depends on the state)
    always @(*) begin
        case (state)
            S0: z = x;         // Pass through (not inverting)
            S1: z = ~x;        // Invert the input
            default: z = 0;    // Default fallback
        endcase
    end

endmodule