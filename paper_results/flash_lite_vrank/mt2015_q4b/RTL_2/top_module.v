module top_module(
	input x,
	input y,
	output z
);

  reg z_internal;

  always @(x or y) begin
    case({x, y})
      2'b00: z_internal = 1'b1;
      2'b10: z_internal = 1'b0;
      2'b01: z_internal = 1'b0;
      2'b11: z_internal = 1'b1;
      default: z_internal = 1'b1; //should not reach here
    endcase
  end

  assign z = z_internal;

endmodule