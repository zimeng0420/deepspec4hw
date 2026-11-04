module top_module(
    input clk,
    input d,
    output reg q
);

    reg clk_delayed;

    // Delay the clock signal by one clock cycle
    always @(posedge clk) begin
        clk_delayed <= clk;
    end

    // Detect rising and falling edges
    wire rising_edge = clk & ~clk_delayed;
    wire falling_edge = ~clk & clk_delayed;

    // Capture data on both edges
    always @(posedge clk) begin
        if (rising_edge || falling_edge) begin
            q <= d;
        end
    end

endmodule