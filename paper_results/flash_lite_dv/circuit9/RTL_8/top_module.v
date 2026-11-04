module top_module (
    input clk,
    input a,
    output reg [2:0] q
);

  always @(posedge clk) begin
    if (a) begin
      // Hold the current value
      q <= q;
    end else begin
      // Increment the value (modulo 8)
      q <= q + 1'b1;
    end
  end

endmodule