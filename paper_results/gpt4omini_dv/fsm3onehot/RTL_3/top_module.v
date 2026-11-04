module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always @(*) begin
        next_state = 4'b0000; // Default to no next state

        case (1'b1) // One-hot encoding check
            state[0]: begin // State A
                if (~in) next_state = 4'b0001; // Stay in A
                else     next_state = 4'b0010; // Go to B
            end
            state[1]: begin // State B
                if (~in) next_state = 4'b0100; // Go to C
                else     next_state = 4'b0010; // Stay in B
            end
            state[2]: begin // State C
                if (~in) next_state = 4'b0001; // Go to A
                else     next_state = 4'b1000; // Go to D
            end
            state[3]: begin // State D
                if (~in) next_state = 4'b0100; // Go to C
                else     next_state = 4'b0010; // Go to B
            end
        endcase
    end

    assign out = state[3]; // Output depends only on current state D

endmodule