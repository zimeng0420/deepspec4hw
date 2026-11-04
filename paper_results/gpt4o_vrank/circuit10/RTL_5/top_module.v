module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    always @(posedge clk) begin
        state <= q;
        if (a & b) 
            q <= 0;
        else if (~a & b)
            q <= 1;
        else 
            q <= ~q;
    end

endmodule