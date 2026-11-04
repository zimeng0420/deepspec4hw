module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        S0 = 2'b00, // Initial state
        S1 = 2'b01, // Detected '1'
        S2 = 2'b10  // Detected '10'
    } state_t;

    state_t state, next_state;

    // Asynchronous reset and state transition on clock edge
    always @(negedge aresetn or posedge clk) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (x)
                    next_state = S1; // Stay in S1 on '1'
                else
                    next_state = S2; // Move to S2 on '0'
            end
            S2: begin
                if (x) begin
                    z = 1; // Output z = 1 when '101' is detected
                    next_state = S1; // Overlapping allowed, go back to S1
                end else
                    next_state = S0; // Go back to S0 on '0'
            end
            default: next_state = S0; // Default case should not occur
        endcase
    end

    // Output logic
    always @(*) begin
        z = 0; // Default output
        if (state == S2 && x)
            z = 1; // Assert z when in S2 and x is 1
    end

endmodule