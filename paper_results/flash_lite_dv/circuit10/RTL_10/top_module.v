module top_module(
    input clk,
    input a,
    input b,
    output reg q,
    output state
);

    always @(posedge clk) begin
        q <= (a & b) | (q & !(a | b));
    end

    assign state = q;
endmodule