module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);
    always @(posedge clk) begin
        if (a == 0) begin
            q <= (q + 1) % 8;
        end
        // If a is 1, q remains unchanged
    end
endmodule