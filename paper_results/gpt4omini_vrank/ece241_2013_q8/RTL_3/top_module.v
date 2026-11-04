module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding
    parameter S0 = 2'b00, // Initial state
              S1 = 2'b01, // After seeing '1'
              S2 = 2'b10; // After seeing '10'

    reg [1:0] state, next_state;

    // Output logic
    always @(state or x) begin
        z = 1'b0; // Default output
        case (state)
            S0: if (x) next_state = S1; else next_state = S0;
            S1: if (x) next_state = S1; else next_state = S2;
            S2: if (x) begin
                    z = 1'b1; // Output asserted when "101" is detected
                    next_state = S1; // Stay in state S1 for overlapping
                end else next_state = S0;
            default: next_state = S0;
        endcase
    end

    // State transition
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0; // Reset to initial state
        else
            state <= next_state; // Move to next state
    end
endmodule