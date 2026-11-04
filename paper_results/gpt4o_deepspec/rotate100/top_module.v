module top_module(
	input clk,
	input load,
	input [1:0] ena,
	input [99:0] data,
	output reg [99:0] q);

	always @(posedge clk) begin
		if (load) begin
			// Load operation has the highest priority
			q <= data;
		end
		else begin
			case (ena)
				2'b01: begin
					// Rotate right by 1 bit
					q <= {q[0], q[99:1]};
				end
				2'b10: begin
					// Rotate left by 1 bit
					q <= {q[98:0], q[99]};
				end
				default: begin
					// No rotation, retain current value
					q <= q;
				end
			endcase
		end
	end

endmodule