module top_module(
    input clk,
    input d,
    output reg q
);

    reg q1;  // Intermediate register to hold value at falling edge

    // Rising edge: capture 'd' into q1
    always @(posedge clk) begin
        q1 <= d;
    end

    // Falling edge: update 'q' with the previously captured 'q1'
    always @(negedge clk) begin
        q <= q1;
    end

endmodule