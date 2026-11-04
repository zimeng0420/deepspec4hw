module top_module (
	input clk,
	input a, 
	output reg [2:0] q
);

  always @(posedge clk) begin
    if (a) begin
      q <= q; // No change when a is high
    end else begin
      case (q)
        3'd4: q <= 3'd5;
        3'd5: q <= 3'd6;
        3'd6: q <= 3'd0;
        3'd0: q <= 3'd1;
        3'd1: q <= q;
        default: q <= 3'd4;
      endcase
    end
  end
endmodule