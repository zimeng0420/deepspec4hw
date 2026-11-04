module top_module(
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // Define states using one-hot encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // Next state logic
    always @(*) begin
        case (state)
            A: if (!in) next_state = A; else next_state = B;
            B: if (!in) next_state = C; else next_state = B;
            C: if (!in) next_state = A; else next_state = D;
            D: if (!in) next_state = C; else next_state = B;
            default: next_state = A; // Handle undefined states
        endcase
    end

    // Output logic
    assign out = state[3];

endmodule