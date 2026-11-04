module top_module(
    input clk,
    input in,
    input reset,
    output reg out
);

    // State definition
    parameter A = 1'b0;
    parameter B = 1'b1;

    // State register
    reg state;

    // Next state logic
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            case (state)
                A:  state <= (in) ? A : B;
                B:  state <= (in) ? B : A;
                default: state <= B; // Should not happen, but good practice
            endcase
        end
    end

    // Output logic
    always @(*) begin
        case (state)
            A:  out = 1'b0;
            B:  out = 1'b1;
            default: out = 1'b1; // Should not happen, but good practice
        endcase
    end

endmodule