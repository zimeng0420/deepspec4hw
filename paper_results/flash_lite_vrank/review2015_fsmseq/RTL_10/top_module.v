module top_module(
	input clk,
	input reset,
	input data,
	output reg start_shifting
);

	parameter IDLE = 0;
	parameter S1 = 1;
	parameter S2 = 2;
	parameter S3 = 3;
	parameter S4 = 4;

	reg [2:0] state;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			start_shifting <= 0;
		end else begin
			case (state)
				IDLE: begin
					if (data)
						state <= S1;
					else
						state <= IDLE;
				end
				S1: begin
					if (data)
						state <= S2;
					else
						state <= IDLE;
				end
				S2: begin
					if (!data)
						state <= S3;
					else
						state <= S2;
				end
				S3: begin
					if (data)
						state <= S4;
					else
						state <= IDLE;
				end
				S4: begin
					state <= S4;
					start_shifting <= 1;
				end
				default: begin
					state <= IDLE;
				end
			endcase
		end
	end

endmodule