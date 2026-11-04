module top_module(
    input clk,
    input d,
    output reg q
);

    reg clk_delayed;

    // Delay the clock by one clock cycle.
    always @(posedge clk) begin
        clk_delayed <= clk;
    end

    // Detect rising edge of clk
    wire rising_edge = clk & ~clk_delayed;

    // Detect falling edge of clk
    wire falling_edge = ~clk & clk_delayed;

    // Update q on rising and falling edges.
    always @(posedge clk or negedge clk) begin
        if (rising_edge || falling_edge) begin
            q <= d;
        end
    end

endmodule