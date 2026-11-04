module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);
    
    // State declaration
    typedef enum reg [1:0] {
        S0 = 2'b00,  // Initial state
        S1 = 2'b01,  // Detected '1'
        S2 = 2'b10   // Detected '10'
    } state_t;
    
    state_t state, next_state;

    // Asynchronous reset and state transition
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and output logic
    always @(*) begin
        z = 0; // Default output
        case (state)
            S0: begin
                if (x) begin
                    next_state = S1;
                end else begin
                    next_state = S0;
                end
            end
            S1: begin
                if (x) begin
                    next_state = S1; // Stay in S1 on '1'
                end else begin
                    next_state = S2; // Move to S2 on '0'
                end
            end
            S2: begin
                if (x) begin
                    z = 1; // Output z = 1 on detecting '1' from S2 (101 detected)
                    next_state = S1; // Move back to S1
                end else begin
                    next_state = S0; // Move back to S0 on '0'
                end
            end
            default: next_state = S0; // Catch-all for safety
        endcase
    end
endmodule