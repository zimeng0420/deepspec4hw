module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);
    always @(posedge clk) begin
        // Sequential logic: state transition
        case (state)
            0: state <= ~a & b ? 1 : state;
            1: state <= a & b ? 0 : state;
        endcase

        // Output logic based on state, a, and b
        case (state)
            0: q <= (~a & b) | (a & ~b);
            1: q <= (~a & ~b) | (a & b);
        endcase
    end
endmodule