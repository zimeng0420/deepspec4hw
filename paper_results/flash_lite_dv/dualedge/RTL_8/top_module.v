module top_module(
    input clk,
    input d,
    output reg q
);

    reg clk_delayed;

    // Delay the clock signal
    always #1 clk_delayed = clk;

    always @(posedge clk or negedge clk) begin
        q <= d;
    end

endmodule