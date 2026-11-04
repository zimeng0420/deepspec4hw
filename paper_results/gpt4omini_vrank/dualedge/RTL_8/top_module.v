module top_module(
    input clk,
    input d,
    output reg q
);

reg d_latch;

// Rising edge
always @(posedge clk) begin
    d_latch <= d;
end

// Falling edge (using the state of the latch)
always @(negedge clk) begin
    q <= d_latch;
end

endmodule