module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output state
);

    assign state = q;

    always @(posedge clk) begin
        if (a & b)
            q <= ~q;
        else if (a)
            q <= 0;
        else if (b)
            q <= 1;
    end

endmodule