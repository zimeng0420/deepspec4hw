module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum logic {S0, S1} state_t;
    state_t state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) 
            state <= S0;
        else 
            state <= next_state;
    end

    always_comb begin
        case (state)
            S0: begin
                if (x == 1'b0) 
                    z = 1'b1; // Output 1 when waiting in S0
                else 
                    z = 1'b1; // Still output 1 for the first '1' encountered
                next_state = S1; // Transition to S1 on first '1'
            end
            S1: begin
                z = ~x; // Output inverted value of x in S1
                next_state = S1; // Remain in S1 
            end
            default: begin
                z = 1'b0; // Default case to avoid latches
                next_state = S0; // Default to S0
            end
        endcase
    end

endmodule