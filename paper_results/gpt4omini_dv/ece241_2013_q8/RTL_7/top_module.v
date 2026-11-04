module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);
    
    // State encoding
    typedef enum reg [1:0] {
        S0 = 2'b00, // Initial state
        S1 = 2'b01, // State after seeing '1'
        S2 = 2'b10  // State after seeing '10'
    } state_t;

    state_t current_state, next_state;

    // Asynchronous reset and state transition
    always @(negedge aresetn or posedge clk) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: begin
                if (x) 
                    next_state = S1; // Move to S1 on '1'
                else 
                    next_state = S0; // Stay in S0 on '0'
            end
            S1: begin
                if (!x) 
                    next_state = S2; // Move to S2 on '0'
                else 
                    next_state = S1; // Stay in S1 on '1'
            end
            S2: begin
                if (x) 
                    next_state = S1; // Move to S1 on '1' after detecting '101'
                else 
                    next_state = S0; // Move back to S0 on '0'
            end
        endcase
    end

    // Output logic
    always @(*) begin
        z = 0; // Default output
        if (current_state == S2 && x) 
            z = 1; // Assert z when in S2 and x is '1'
    end

endmodule