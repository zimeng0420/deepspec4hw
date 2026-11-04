module top_module(
	input clk,
	input reset,
	input data,
	output start_shifting
);

	parameter IDLE = 0;
	parameter S1 = 1;
	parameter S2 = 2;
	parameter S3 = 3;
	parameter S4 = 4;

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
						state <= S2;
					end else begin
						state <= IDLE;
					end
				end
				S2: begin
					if (!data) begin
						state <= S3;
					end else begin
						state <= S2;
					end
				end
				S3: begin
					if (data) begin
						state <= S4;
					end else begin
						state <= IDLE;
					end
				end
				S4: begin
					start_shifting_internal <= 1;
					state <= S4; // Remain in S4 forever
				end
				default: begin
					state <= IDLE;
				end
			endcase
		end
	end

	assign start_shifting = start_shifting_internal;

endmodule