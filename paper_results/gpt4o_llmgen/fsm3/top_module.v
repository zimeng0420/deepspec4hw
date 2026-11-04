module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // State encoding
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b10,
                     D = 2'b11;

    reg [1:0] current_state, next_state;

    // Sequential logic for state transitions
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Combinational logic for next state logic
    always @(*) begin
        case (current_state)
            A: next_state = (in) ? B : A;
            B: next_state = (in) ? B : C;
            C: next_state = (in) ? D : A;
            D: next_state = (in) ? B : C;
            default: next_state = A;  // default case
        endcase
    end

    // Output logic based on the current state
    always @(*) begin
        case (current_state)
            D: out = 1;
            default: out = 0;
        endcase
    end

endmodule