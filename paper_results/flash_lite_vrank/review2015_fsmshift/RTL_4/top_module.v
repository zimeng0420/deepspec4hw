module top_module(
	input clk,
	input reset,
	output shift_ena);

	parameter IDLE = 0;
	parameter COUNT1 = 1;
	parameter COUNT2 = 2;
	parameter COUNT3 = 3;
	parameter COUNT4 = 4;

	reg [2:0] state, next_state;
	reg [1:0] counter;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			counter <= 2'b00;
		end else begin
			state <= next_state;
			if (state == COUNT4)
			    counter <= 2'b00;
		end
	end

	always @(*) begin
		next_state = state;
		case(state)
			IDLE: begin
				if (reset)
				    next_state = COUNT1;
				else
				    next_state = IDLE;
			end
			COUNT1: begin
				next_state = COUNT2;
			end
			COUNT2: begin
				next_state = COUNT3;
			end
			COUNT3: begin
				next_state = COUNT4;
			end
			COUNT4: begin
				next_state = IDLE;
			end
			default: next_state = IDLE;
		endcase
	end

	always @(posedge clk) begin
		if(reset) begin
			counter <= 2'b00;
		end else if (state >= COUNT1 && state <= COUNT4) begin
			counter <= counter + 1'b1;
		end
	end

	assign shift_ena = (state >= COUNT1 && state <= COUNT4);

endmodule