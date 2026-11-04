module top_module(
    input clk,
    input d,
    output reg q
);

    reg q1_rising, q2_falling;

    always @(posedge clk) begin
        q1_rising <= d;  // Capture 'd' on the rising edge
    end

    always @(negedge clk) begin
        q2_falling <= d;  // Capture 'd' on the falling edge
    end

    always @(*) begin
        // When clk is high, q takes q1_rising; when clk is low, q takes q2_falling
        if (clk)
            q = q1_rising;
        else
            q = q2_falling;
    end

endmodule