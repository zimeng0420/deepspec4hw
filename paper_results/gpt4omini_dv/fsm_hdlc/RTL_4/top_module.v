module top_module (
	input clk,
	input reset,
	input in,
	output reg disc,
	output reg flag,
	output reg err
);

    typedef enum logic [2:0] {
        S0, // Initial state, expecting 0 or 1
        S1, // Received 1
        S2, // Received 11
        S3, // Received 111
        S4, // Received 1111
        S5, // Received 11111
        S6, // Received 111111 (disc state)
        S7, // Received 1111111 (err state)
        S8  // Received 11111110 (flag state)
    } state_t;

    state_t current_state, next_state;

    // Sequential logic (state transitions)
    always_ff @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= S0; 
        else 
            current_state <= next_state;
    end

    // Combinational logic (state transitions and output logic)
    always_comb begin
        // Default outputs
        disc = 0;
        flag = 0;
        err = 0;
        next_state = current_state; // Default to stay in the same state
        
        case (current_state)
            S0: begin
                if (in) 
                    next_state = S1; // Transition to S1 on receiving 1
            end
            
            S1: begin
                if (in) 
                    next_state = S2; // Transition to S2
                else 
                    next_state = S0; // Transition back to S0 on receiving 0
            end
            
            S2: begin
                if (in) 
                    next_state = S3; // Transition to S3
                else 
                    next_state = S0; // Transition back to S0
            end
            
            S3: begin
                if (in) 
                    next_state = S4; // Transition to S4
                else 
                    next_state = S0; // Transition back to S0
            end
            
            S4: begin
                if (in) 
                    next_state = S5; // Transition to S5
                else 
                    next_state = S0; // Transition back to S0
            end
            
            S5: begin
                if (in) 
                    next_state = S6; // Transition to S6 (disc state)
                else 
                    next_state = S0; // Transition back to S0
            end
            
            S6: begin
                // disc state
                disc = 1; // Assert disc
                if (in) 
                    next_state = S7; // Transition to S7 (err state)
                else 
                    next_state = S0; // Transition back to S0
            end
            
            S7: begin
                // err state
                err = 1; // Assert err
                if (in) 
                    next_state = S7; // Stay in err state
                else 
                    next_state = S0; // Transition back to S0
            end
            
            default: begin
                next_state = S0; // Default to S0
            end
        endcase

        // Check for flag state (in S5)
        if (current_state == S5 && in) begin
            flag = 1; // Assert flag
            next_state = S8; // Transition to flag state
        end
            
        if (current_state == S8) begin
            next_state = S0; // Transition back to S0 after flag
        end
    end

endmodule