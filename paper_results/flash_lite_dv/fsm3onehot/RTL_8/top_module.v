module top_module(
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // Define state constants (one-hot encoding)
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // Next state logic
    always @(*) begin
        case (1'b1) // using a case statement for clarity, though other logic is possible
            1'b1: begin
                next_state[0] = (!in & state[0]) | (!in & state[2]); // State A
                next_state[1] = (in & state[0]) | (in & state[1]) | (!in & state[3]); // State B
                next_state[2] = (!in & state[1]) | (in & state[2]) | (state[3]); // State C
                next_state[3] = (in & state[2]); // State D
            end
        endcase
    end

    // Output logic
    assign out = state[3]; // Output is high when in state D

endmodule