module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);
    // State encoding
    reg current_state, next_state;
    parameter B = 1'b0, A = 1'b1;
    
    // Combinational logic for next state and output
    always @(*) begin
        // Default next state
        next_state = current_state;
        case (current_state)
            B: begin
                out = 1'b1; // Output for state B
                if (in == 1'b0)
                    next_state = A;
            end
            A: begin
                out = 1'b0; // Output for state A
                if (in == 1'b0)
                    next_state = B;
            end
        endcase
    end
    
    // Sequential logic for state transitions
    always @(posedge clk) begin
        if (reset)
            current_state <= B; // Synchronous reset to state B
        else
            current_state <= next_state;
    end
endmodule