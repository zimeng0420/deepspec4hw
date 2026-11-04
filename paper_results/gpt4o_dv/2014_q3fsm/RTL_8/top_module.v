module top_module (
	input clk,
	input reset,
	input s,
	input w,
	output reg z
);

	typedef enum reg [1:0] {
		STATE_A = 2'b00,
		STATE_B = 2'b01
	} state_t;
	
	reg [1:0] state, next_state;
	reg [1:0] w_count;  // Count of w=1 in the current 3-cycle window
	reg [1:0] cycle_counter;  // Counter to track the number of cycles in state B

	always @(posedge clk) begin
		if (reset) begin
			state <= STATE_A;
			w_count <= 2'b00;
			cycle_counter <= 2'b00;
			z <= 1'b0;
		end else begin
			state <= next_state;
		end
	end

	always @(*) begin
		next_state = state;  // Default state is to remain in current state
		case (state)
			STATE_A: begin
				z = 0;
				if (s) begin
					next_state = STATE_B;
					w_count = 0;
					cycle_counter = 0;
				end
			end
		
			STATE_B: begin
				if (cycle_counter < 2) begin
					w_count = w_count + (w ? 1 : 0);
					cycle_counter = cycle_counter + 1;
					z = 0;
				end else begin  // When cycle_counter reaches 2, evaluate `z`
					z = (w_count + w == 2);
					w_count = 0;
					cycle_counter = 0;
				end
			end
		endcase
	end

endmodule