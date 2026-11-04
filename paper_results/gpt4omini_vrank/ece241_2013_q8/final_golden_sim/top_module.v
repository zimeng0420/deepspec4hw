module top_module (
	input clk,
	input aresetn,
	input x,
	output reg z
);
    
    typedef enum reg [1:0] {
        S0 = 2'b00,  // Initial state
        S1 = 2'b01,  // Received '1'
        S2 = 2'b10   // Received '10'
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= S0;
            z <= 1'b0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            S0: begin
                z = 1'b0;
                if (x) 
                    next_state = S1; // Move to S1 on '1'
                else 
                    next_state = S0; // Stay in S0
            end

            S1: begin
                z = 1'b0;
                if (x) 
                    next_state = S1; // Stay in S1 on '1'
                else 
                    next_state = S2; // Move to S2 on '0'
            end

            S2: begin
                z = 1'b1; // '101' detected
                if (x) 
                    next_state = S1; // Overlapping '1', move to S1
                else 
                    next_state = S0; // Move back to S0 on '0'
            end
            
            default: begin
                next_state = S0; // Default state
                z = 1'b0;
            end
        endcase
    end

endmodule