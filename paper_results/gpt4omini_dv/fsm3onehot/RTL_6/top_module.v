module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always @(*) begin
        case (1'b1) // one-hot state detection
            state[0]: begin // State A
                next_state = in ? 4'b0010 : 4'b0001; // A, B
            end
            state[1]: begin // State B
                next_state = in ? 4'b0010 : 4'b0100; // C, B
            end
            state[2]: begin // State C
                next_state = in ? 4'b1000 : 4'b0001; // A, D
            end
            state[3]: begin // State D
                next_state = in ? 4'b0010 : 4'b0100; // C, B
            end
            default: next_state = 4'b0001; // Default state
        endcase
    end

    assign out = state[3]; // Output logic

endmodule