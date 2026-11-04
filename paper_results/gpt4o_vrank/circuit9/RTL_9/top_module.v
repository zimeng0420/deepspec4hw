module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);

    initial q = 4;

    always @(posedge clk) begin
        if (a == 0)
            q <= q + 1;
    end

endmodule