module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        S0 = 2'b00, // Initial state
        S1 = 2'b01, // State after seeing '1'
        S2 = 2'b10  // State after seeing '10'
    } state_t;

    state_t state, next_state;

    // Asynchronous reset and state transition logic
    always_ff @(negedge aresetn or posedge clk) begin
        if (!aresetn)
            state <= S0; // Reset to initial state
        else
            state <= next_state; // Transition to the next state
    end

    // Next state logic
    always_comb begin
        case (state)
            S0: begin
                if (x) 
                    next_state = S1; // Move to S1 if x is 1
                else 
                    next_state = S0; // Stay in S0 if x is 0
                z = 0; // z is 0 in S0
            end

            S1: begin
                if (x) 
                    next_state = S1; // Stay in S1 if x is 1
                else 
                    next_state = S2; // Move to S2 if x is 0
                z = 0; // z is 0 in S1
            end

            S2: begin
                if (x) begin 
                    next_state = S1; // Return to S1 if x is 1
                    z = 1; // z is 1 when detecting '101'
                end else begin
                    next_state = S0; // Return to S0 if x is 0
                    z = 0; // z is 0 in S2
                end
            end

            default: begin
                next_state = S0;
                z = 0; // Safe state
            end
        endcase
    end

endmodule