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

    // State transition logic
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0; // Asynchronous reset to S0
        else
            current_state <= next_state; // Update state on clock edge
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: begin
                if (x) 
                    next_state = S1; // Transition to S1
                else 
                    next_state = S0; // Remain in S0
                z = 0; // Output is 0
            end
            
            S1: begin
                if (!x) 
                    next_state = S2; // Transition to S2
                else 
                    next_state = S1; // Remain in S1
                z = 0; // Output is 0
            end
            
            S2: begin
                if (x) begin
                    next_state = S1; // Return to S1 for overlapping detection
                    z = 1; // Output is 1 for detected '101'
                end else begin
                    next_state = S0; // Return to S0
                    z = 0; // Output is 0
                end
            end
            
            default: begin
                next_state = S0; // Default state
                z = 0; // Output is 0
            end
        endcase
    end
endmodule