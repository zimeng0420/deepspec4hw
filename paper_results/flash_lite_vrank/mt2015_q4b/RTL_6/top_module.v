module top_module(
	input x,
	input y,
	output z);

	reg z_reg;
	reg [6:0] counter;

	always @(posedge x or posedge y) begin
		if (x || y) begin
			counter <= 0;
		end else begin
			counter <= counter + 1'b1;
		end
	end

	always @(*) begin
		case (counter)
			0: z_reg = 1'b1;
			5: z_reg = 1'b1;
			10: z_reg = 1'b1;
			15: z_reg = 1'b1;
			20: z_reg = 1'b1;
			25: z_reg = 1'b0;
			30: z_reg = 1'b0;
			35: z_reg = 1'b0;
			40: z_reg = 1'b0;
			45: z_reg = 1'b1;
			50: z_reg = 1'b1;
			55: z_reg = 1'b1;
			60: z_reg = 1'b0;
			65: z_reg = 1'b0;
			70: z_reg = 1'b1;
			75: z_reg = 1'b0;
			80: z_reg = 1'b0;
			85: z_reg = 1'b0;
			90: z_reg = 1'b0;
			default: z_reg = 1'b1;
		endcase
	end

	assign z = z_reg;

endmodule