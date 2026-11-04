module top_module (
	input clk,
	input reset,
	input s,
	input w,
	output reg z
);

	// State Definitions
	localparam STATE_A = 1'b0;
	localparam STATE_B = 1'b1;
	
	// State Registers
	reg state, next_state;
	reg [1:0] cycle_count;
	reg [1:0] w_count;
	
	// State Transition Logic
	always @(posedge clk) begin
		if (reset) begin
			state <= STATE_A;
			cycle_count <= 2'b00;
			w_count <= 2'b00;
			z <= 0;
		end else begin
			state <= next_state;
			if (state == STATE_B) begin
				cycle_count <= cycle_count + 1'b1;
				if (w) w_count <= w_count + 1'b1;
				
				if (cycle_count == 2'b10) begin
					if (w_count == 2'b10) z <= 1'b1;
					else z <= 1'b0;
					cycle_count <= 2'b00;
					w_count <= 2'b00;
				end
			end
		end
	end
	
	// Next State Logic
	always @(*) begin
		case (state)
			STATE_A: next_state = (s) ? STATE_B : STATE_A;
			STATE_B: next_state = STATE_B;
			default: next_state = STATE_A;
		endcase
	end

endmodule