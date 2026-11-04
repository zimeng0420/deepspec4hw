module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output state
);

    assign state = q;

    always @(posedge clk) begin
        q <= (~a & b) | (a & b & ~q);
    end

endmodule