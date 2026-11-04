module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    reg state;
    reg next_state;

    // State encoding
    localparam B = 1'b0; // B state
    localparam A = 1'b1; // A state

    // Synchronous state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            B: next_state = (in) ? B : A;
            A: next_state = (in) ? A : B;
            default: next_state = B; // Default state
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            B: out = 1'b1;
            A: out = 1'b0;
            default: out = 1'b1; // Default output
        endcase
    end

endmodule