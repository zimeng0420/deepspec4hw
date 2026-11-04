module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    typedef enum logic [0:0] {B = 1'b0, A = 1'b1} state_t; 
    state_t current_state, next_state;
    
    // Next state logic (combinational)
    always_comb begin
        case (current_state)
            B: next_state = (in == 0) ? A : B;
            A: next_state = (in == 0) ? B : A;
            default: next_state = B; // Default state to handle unknown
        endcase
    end
    
    // Sequential logic
    always_ff @(posedge clk) begin
        if (reset) 
            current_state <= B; // Reset to state B
        else 
            current_state <= next_state;
    end
    
    // Output logic (depends only on current state)
    always_comb begin
        case (current_state)
            B: out = 1'b1;
            A: out = 1'b0;
        endcase
    end

endmodule