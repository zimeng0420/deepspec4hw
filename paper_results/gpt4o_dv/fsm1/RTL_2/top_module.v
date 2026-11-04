module top_module (
	input clk,
	input in,
	input areset,
	output reg out
);

    // State encoding
    typedef enum logic [1:0] {A = 1'b0, B = 1'b1} state_t;
    state_t current_state, next_state;
    
    // State transition logic (combinational)
    always_comb begin
        case (current_state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B; // Default to state B
        endcase
    end
    
    // Output logic (combinational)
    always_comb begin
        case (current_state)
            B: out = 1'b1;
            A: out = 1'b0;
            default: out = 1'b1; // Default output for state B
        endcase
    end

    // State updating (sequential)
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= B;  // Asynchronous reset to state B
        else
            current_state <= next_state;  // Update state on clock edge
    end

endmodule