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
      // Increment q (modulo 8)
      q <= q + 1'b1;
      if (q == 3'b111) begin
        q <= 3'b000;
      end
    end
  end

endmodule