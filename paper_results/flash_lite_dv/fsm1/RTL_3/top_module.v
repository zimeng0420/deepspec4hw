module top_module(
    input clk,
    input in,
    input areset,
    output out
);

    // Define states using parameters for readability and maintainability
    parameter STATE_A = 0;
    parameter STATE_B = 1;

    // Internal state register
    reg state;

    // Combinational logic for next state
    always @(*) begin
        case (state)
            STATE_A: begin
                if (in)
                    state = STATE_A;  // Stay in A if in = 1
                else
                    state = STATE_B;  // Go to B if in = 0
            end
            STATE_B: begin
                if (in)
                    state = STATE_B;  // Stay in B if in = 1
                else
                    state = STATE_A;  // Go to A if in = 0
            end
            default: state = STATE_B; // Default to B (should not happen)
        endcase
    end

    // Sequential logic for state update and asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_B; // Asynchronous reset to state B
        else
            state <= state; // State update based on combinational logic
    end

    // Output logic (Moore machine)
    assign out = state;

endmodule