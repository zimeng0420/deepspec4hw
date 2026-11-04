module top_module (
	input clk,
	input areset,
	input x,
	output z
);

	parameter IDLE = 2'b00;
	parameter SEARCH = 2'b01;
	parameter COMPLEMENT = 2'b10;

	reg [1:0] state, next_state;
	reg complement;
	reg z_reg;
	
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= IDLE;
		else
			state <= next_state;
	end

	always @(*) begin
		next_state = state;
		z_reg = 1'b0;
		complement = 1'b0;

		case (state)
			IDLE: begin
				if (!areset) begin
					next_state = SEARCH;
				end
				z_reg = 1'b0;
			end
			
			SEARCH: begin
				if (x) begin
					next_state = COMPLEMENT;
					z_reg = x;
				end else begin
					z_reg = x;
				end
			end

			COMPLEMENT: begin
				next_state = COMPLEMENT;
				z_reg = ~x;
			end

			default: begin
				next_state = IDLE;
				z_reg = 1'b0;
			end
		endcase
	end

	assign z = z_reg;

endmodule