module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    typedef enum reg [1:0] {
        S0 = 2'b00, // Initial state
        S1 = 2'b01, // State after detecting '1'
        S2 = 2'b10  // State after detecting '10'
    } state_t;

    state_t state, next_state;

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
                if (~x)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S2: begin
                if (x)
                    next_state = S1; // Detected '101', transition back to S1
                else
                    next_state = S0;
            end
            default: next_state = S0; // Default case
        endcase
    end

    // State update logic
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 0;
        end else begin
            state <= next_state;
            z <= (state == S2 && x); // Assert z when in S2 and x = 1
        end
    end

endmodule