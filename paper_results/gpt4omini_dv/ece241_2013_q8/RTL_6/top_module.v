module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        S0 = 2'b00, // Initial state
        S1 = 2'b01, // State after detecting '1'
        S2 = 2'b10  // State after detecting '10'
    } state_t;

    state_t current_state, next_state;

    // Asynchronous reset
    always @(negedge aresetn) begin
        current_state <= S0; 
        z <= 0; // Reset output
    end

    // State transition logic
    always @(posedge clk or negedge aresetn) begin
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
                    next_state = S1; 
                else 
                    next_state = S0; 
                z = 0; // Output is low in state S0
            end
            S1: begin
                if (x) 
                    next_state = S1; // Stay in S1 on input '1'
                else 
                    next_state = S2; // Transition to S2 on input '0'
                z = 0; // Output is low in state S1
            end
            S2: begin
                if (x) begin
                    next_state = S1; // Transition back to S1 on input '1'
                    z = 1; // Output is high, sequence '101' detected
                end else begin
                    next_state = S0; // Transition back to S0 on input '0'
                    z = 0; // Output is low in state S2
                end
            end
            default: begin
                next_state = S0; // Default state to avoid latches
                z = 0;
            end
        endcase
    end

endmodule