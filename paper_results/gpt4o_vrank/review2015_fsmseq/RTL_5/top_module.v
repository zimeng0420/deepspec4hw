module top_module(
	input clk,
	input reset,
	input data,
	output reg start_shifting
);

    typedef enum logic [2:0] {
        S0, // Initial state
        S1, // State after seeing '1'
        S2, // State after seeing "11"
        S3, // State after seeing "110"
        S4  // State after seeing "1101"
    } state_t;
    
    state_t state, next_state;
    
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (state == S4)
                start_shifting <= 1'b1;
        end
    end
    
    always_comb begin
        unique case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4; // Stay in S4 once sequence is detected
            default: next_state = S0; // Default to initial state
        endcase
    end

endmodule