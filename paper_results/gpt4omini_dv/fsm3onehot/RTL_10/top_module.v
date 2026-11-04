module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always @* begin
        // Default values for next_state
        next_state = 4'b0000; 
        case (1'b1) // One-hot encoding check
            state[0]: // State A
                if (in)
                    next_state = 4'b0010; // Next state B
                else
                    next_state = 4'b0001; // Stay in A
            state[1]: // State B
                if (in)
                    next_state = 4'b0010; // Stay in B
                else
                    next_state = 4'b0100; // Next state C
            state[2]: // State C
                if (in)
                    next_state = 4'b1000; // Next state D
                else
                    next_state = 4'b0001; // Next state A
            state[3]: // State D
                if (in)
                    next_state = 4'b0010; // Next state B
                else
                    next_state = 4'b0100; // Next state C
        endcase
    end

    assign out = state[3]; // Output from state D

endmodule