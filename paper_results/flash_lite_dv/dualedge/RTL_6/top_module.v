module top_module(
    input clk,
    input d,
    output reg q
);

    reg clk_delayed;

    // Delay the clock signal by a small amount
    always @(posedge clk) begin
        clk_delayed <= clk;
    end

    // Detect rising and falling edges
    wire rising_edge = clk & ~clk_delayed;
    wire falling_edge = ~clk & clk_delayed;

    // Capture data on rising and falling edges
    always @(posedge clk or negedge clk) begin
        if (rising_edge || falling_edge) begin
            q <= d;
        end
    end

endmodule