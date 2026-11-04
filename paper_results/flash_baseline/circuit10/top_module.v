module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state
);

    reg q;
    wire next_q;

    assign state = q;

    always @(posedge clk) begin
        q <= next_q;
    end

    assign next_q = (a & b) ? a : ((~a) & b) ? b : ((~a) & (~b)) ? 0 : q;

endmodule