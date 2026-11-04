module top_module(
    input clk,
    input d,
    output reg q
);

    reg clk_delayed;

    // Delay the clock signal by a small amount to create a delayed version
    always @(posedge clk) begin
        clk_delayed <= clk;
    end

    // Edge detection and data capture
    always @(posedge clk or negedge clk) begin
        q <= d;
    end

endmodule