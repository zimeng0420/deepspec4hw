module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    typedef enum reg [1:0] {
        S0 = 2'b00, // Initial state
        S1 = 2'b01, // State after '1'
        S2 = 2'b10  // State after '10'
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0; // Reset state
        else 
            current_state <= next_state; // Next state
    end

    always @(*) begin
        // Default values
        next_state = current_state;
        z = 1'b0; // Default output

        case (current_state)
            S0: begin
                if (x) 
                    next_state = S1; // Next state, received '1'
            end
            S1: begin
                if (!x) 
                    next_state = S2; // Next state, received '10'
                else 
                    next_state = S1; // Stay in S1 if '1' is received
            end
            S2: begin
                if (x) begin
                    z = 1'b1; // Output '1' on detecting '101'
                    next_state = S1; // Move back to S1 for overlapping
                end else begin
                    next_state = S0; // Move to reset state on '0'
                end
            end
        endcase
    end

endmodule