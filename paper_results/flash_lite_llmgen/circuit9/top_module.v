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
      // Increment the counter
      case (q)
        3'b000: q <= 3'b100; // 4
        3'b100: q <= 3'b100; // 4
        3'b101: q <= 3'b110; // 6
        3'b110: q <= 3'b000; // 0
        3'b001: q <= 3'b001; // 1
        3'b010: q <= 3'b010; // 2
        3'b011: q <= 3'b011; // 3
        3'b111: q <= 3'b001; // 1
        default: q <= 3'b100; // 4
      endcase
    end
  end

endmodule