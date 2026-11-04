module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State Definition
    parameter A = 1'b0;
    parameter B = 1'b1;

    // State Register
    reg state;

    // Next State Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= B;  // Synchronous reset to state B
        end else begin
            case (state)
                A:
                    state <= (in) ? A : B;
                B:
                    state <= (in) ? B : A;
                default:
                    state <= B; // should not happen, but added for safety
            endcase
        end
    end

    // Output Logic
    always @(*) begin
        out = (state == B) ? 1'b1 : 1'b0;
    end

endmodule