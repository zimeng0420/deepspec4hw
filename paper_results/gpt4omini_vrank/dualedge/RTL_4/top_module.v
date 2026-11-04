module top_module (
    input clk,
    input d,
    output reg q
);
    reg d_latch;

    always @(posedge clk) begin
        d_latch <= d; // Capture d on the rising edge
    end

    always @(negedge clk) begin
        q <= d_latch; // Output the captured value on the falling edge
    end
endmodule