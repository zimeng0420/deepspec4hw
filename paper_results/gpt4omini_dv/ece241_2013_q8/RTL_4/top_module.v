module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        S0 = 2'b00, // Initial state, no '1' seen
        S1 = 2'b01, // '1' seen
        S2 = 2'b10  // '10' seen
    } state_t;

    state_t state, next_state;

    // Asynchronous reset
    always @(negedge aresetn) begin
        state <= S0;
    end

    // State transition logic
    always @(posedge clk) begin
        state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            S0: begin
                if (x) next_state = S1; // Transition to S1 on '1'
                else next_state = S0;   // Stay in S0
                z = 0;                  // Output logic
            end
            S1: begin
                if (~x) next_state = S2; // Transition to S2 on '0'
                else next_state = S1;    // Stay in S1
                z = 0;                   // Output logic
            end
            S2: begin
                if (x) begin
                    next_state = S1;      // Transition back to S1 on '1'
                    z = 1;                // Detect '101'
                end else begin
                    next_state = S0;      // Go back to S0 on '0'
                    z = 0;                // Reset output logic
                end
            end
            default: begin
                next_state = S0;         // Default state
                z = 0;                   // Default output
            end
        endcase
    end

endmodule