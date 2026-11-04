module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

always @(*) begin
    // Default state
    next_state = 4'b0000;
    out = 1'b0;

    case (1'b1)
        state[0]: begin // State A
            if (in) next_state = 4'b0010; // Go to B
            else next_state = 4'b0001; // Stay in A
        end
        
        state[1]: begin // State B
            if (in) next_state = 4'b0010; // Stay in B
            else next_state = 4'b0100; // Go to C
        end
        
        state[2]: begin // State C
            if (in) next_state = 4'b1000; // Go to D
            else next_state = 4'b0001; // Go to A
        end
        
        state[3]: begin // State D
            if (in) next_state = 4'b0010; // Go to B
            else next_state = 4'b0100; // Go to C
            out = 1'b1; // Output is 1
        end
    endcase
end

endmodule