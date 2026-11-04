module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a) begin
            // When a is high, keep q unchanged
            q <= q; 
        end else begin
            // When a is low, increment q modulo 8
            q <= (q + 1) % 8;
        end
    end

endmodule