module top_module(
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

    always @(posedge clk) begin
        q <= (a & b) | (q & ~(a | b));
    end

    always @(*) begin
        state = q;
    end

endmodule