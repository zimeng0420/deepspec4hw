module top_module(
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
            state <= B;
        end else begin
            case (state)
                A:
                    if (in)
                        state <= A;
                    else
                        state <= B;
                B:
                    if (in)
                        state <= B;
                    else
                        state <= A;
            endcase
        end
    end

    // Output Logic
    always @(*) begin
        case (state)
            A: out = 1'b0;
            B: out = 1'b1;
            default: out = 1'b0; // Default case to handle unexpected states
        endcase
    end

endmodule