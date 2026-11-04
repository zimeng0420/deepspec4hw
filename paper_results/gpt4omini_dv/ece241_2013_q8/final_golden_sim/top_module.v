module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State Encoding
    typedef enum logic [1:0] {
        S0 = 2'b00, // Initial state
        S1 = 2'b01, // Detected '1'
        S2 = 2'b10  // Detected '10'
    } state_t;

    state_t state, next_state;

    // State Transition Logic
    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Next State Logic
    always_comb begin
        case(state)
            S0: begin
                if (x) next_state = S1; // Input '1' detected
                else next_state = S0;   // Stay in S0
                z = 0;                   // Output is low
            end
            S1: begin
                if (!x) next_state = S2; // Input '0' detected
                else next_state = S1;    // Stay in S1
                z = 0;                   // Output is low
            end
            S2: begin
                if (x) begin
                    next_state = S1;     // Detected '101', transition back to S1
                    z = 1;               // Output is high
                end else begin
                    next_state = S0;     // Reset to S0 on input '0'
                    z = 0;               // Output is low
                end
            end
            default: begin
                next_state = S0;         // Default to S0
                z = 0;                   // Output is low
            end
        endcase
    end

endmodule