module top_module(
	input clk,
	input reset,
	input data,
	output start_shifting
);

	parameter IDLE = 0;
	parameter S1 = 1;
	parameter S11 = 2;
	parameter S110 = 3;
	parameter S1101 = 4;

	reg [2:0] state;
	reg start_shifting_internal;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			start_shifting_internal <= 0;
		end else begin
			case (state)
				IDLE: begin
					if (data) begin
						state <= S1;
					end else begin
						state <= IDLE;
					end
				end
				S1: begin
					if (data) begin
						state <= S11;
					end else begin
						state <= IDLE;
					end
				end
				S11: begin
					if (!data) begin
						state <= S110;
					end else begin
						state <= S11;
					end
				end
				S110: begin
					if (data) begin
						state <= S1101;
					end else begin
						state <= IDLE;
					end
				end
				S1101: begin
					start_shifting_internal <= 1;
					state <= S1101; // Stay in this state forever until reset
				end
				default: begin
					state <= IDLE;
				end
			endcase
		end
	end

	assign start_shifting = start_shifting_internal;

endmodule