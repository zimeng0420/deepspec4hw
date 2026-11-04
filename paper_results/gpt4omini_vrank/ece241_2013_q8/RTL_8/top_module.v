module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);
    // State encoding
    typedef enum reg [1:0] {
        S0, // Initial state
        S1, // Detected '1'
        S2  // Detected '10'
    } state_t;
    
    state_t state, next_state;
    
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end
    
    always @(*) begin
        z = 1'b0; // Default output is 0
        case (state)
            S0: begin
                if (x) begin
                    next_state = S1; // Transition to S1 on '1'
                end else begin
                    next_state = S0; // Stay in S0 on '0'
                end
            end
            
            S1: begin
                if (x) begin
                    next_state = S1; // Stay in S1 on '1'
                end else begin
                    next_state = S2; // Transition to S2 on '0'
                end
            end
            
            S2: begin
                if (x) begin
                    z = 1'b1; // Output is 1 when "101" is completed
                    next_state = S1; // Transition back to S1 on '1'
                end else begin
                    next_state = S0; // Transition back to S0 on '0'
                end
            end
            
            default: begin
                next_state = S0; // Safe default
            end
        endcase
    end
endmodule