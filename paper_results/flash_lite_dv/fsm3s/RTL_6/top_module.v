module top_module(
    input clk,
    input in,
    input reset,
    output out
);

    // State Encoding
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State Register
    reg [1:0] current_state;
    reg [1:0] next_state;

    // Output
    always_comb begin
        case (current_state)
            A: out = 1'b0;
            B: out = 1'b0;
            C: out = 1'b0;
            D: out = 1'b1;
            default: out = 1'b0; // Default output in case of unexpected state
        endcase
    end

    // Next State Logic
    always_comb begin
        case (current_state)
            A: next_state = (in) ? B : A;
            B: next_state = (in) ? B : C;
            C: next_state = (in) ? D : A;
            D: next_state = (in) ? B : C;
            default: next_state = A; // Default to state A if in an unexpected state
        endcase
    end

    // State Update with Synchronous Reset
    always_ff @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule