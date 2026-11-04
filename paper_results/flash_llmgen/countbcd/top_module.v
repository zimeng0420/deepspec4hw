module top_module(
	input clk,
	input reset,
	output [3:1] ena,
	output reg [15:0] q);

	// Internal signals for each digit
	reg [3:0] ones;
	reg [3:0] tens;
	reg [3:0] hundreds;
	reg [3:0] thousands;

	//----------------------------------------------------------------------
	// Ones Digit
	//----------------------------------------------------------------------
	always @(posedge clk) begin
		if (reset) begin
			ones <= 4'b0000;
		end else begin
			if (ones == 4'b1001) begin
				ones <= 4'b0000;
			end else begin
				ones <= ones + 1'b1;
			end
		end
	end

	//----------------------------------------------------------------------
	// Tens Digit
	//----------------------------------------------------------------------
	always @(posedge clk) begin
		if (reset) begin
			tens <= 4'b0000;
		end else begin
			if (ones == 4'b1001) begin
				if (tens == 4'b1001) begin
					tens <= 4'b0000;
				end else begin
					tens <= tens + 1'b1;
				end
			end
		end
	end

	//----------------------------------------------------------------------
	// Hundreds Digit
	//----------------------------------------------------------------------
	always @(posedge clk) begin
		if (reset) begin
			hundreds <= 4'b0000;
		end else begin
			if ((ones == 4'b1001) && (tens == 4'b1001)) begin
				if (hundreds == 4'b1001) begin
					hundreds <= 4'b0000;
				end else begin
					hundreds <= hundreds + 1'b1;
				end
			end
		end
	end

	//----------------------------------------------------------------------
	// Thousands Digit
	//----------------------------------------------------------------------
	always @(posedge clk) begin
		if (reset) begin
			thousands <= 4'b0000;
		end else begin
			if ((ones == 4'b1001) && (tens == 4'b1001) && (hundreds == 4'b1001)) begin
				if (thousands == 4'b1001) begin
					thousands <= 4'b0000;
				end else begin
					thousands <= thousands + 1'b1;
				end
			end
		end
	end

	//----------------------------------------------------------------------
	// Enable Outputs
	//----------------------------------------------------------------------
	assign ena[1] = (ones == 4'b1001);  // Enable for tens digit
	assign ena[2] = (ones == 4'b1001) && (tens == 4'b1001); // Enable for hundreds digit
	assign ena[3] = (ones == 4'b1001) && (tens == 4'b1001) && (hundreds == 4'b1001); // Enable for thousands digit

	//----------------------------------------------------------------------
	// Output Assignment
	//----------------------------------------------------------------------
	always @(*) begin
		q[3:0]   = ones;
		q[7:4]   = tens;
		q[11:8]  = hundreds;
		q[15:12] = thousands;
	end

endmodule