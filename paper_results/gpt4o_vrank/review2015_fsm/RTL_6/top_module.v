module top_module(
	input clk,
	input reset,
	input data,
	output reg shift_ena,
	output reg counting,
	input done_counting,
	output reg done,
	input ack );

	// State encoding
	typedef enum reg [2:0] {
		IDLE = 3'b000,
		DETECT_1_0 = 3'b001,
		DETECT_1_1 = 3'b010,
		DETECT_0 = 3'b011,
		SHIFT = 3'b100,
		COUNT = 3'b101,
		DONE = 3'b110
	} state_t;

	state_t current_state, next_state;
	reg [1:0] shift_counter;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			current_state <= IDLE;
			shift_ena <= 0;
			counting <= 0;
			done <= 0;
			shift_counter <= 0;
		end else begin
			current_state <= next_state;
			
			case(next_state)
				SHIFT: begin
					shift_ena <= 1;
					shift_counter <= shift_counter + 1'b1;
				end
				COUNT: begin
					shift_ena <= 0;
					counting <= 1;
				end
				DONE: begin
					counting <= 0;
					done <= 1;
				end
				default: begin
					shift_ena <= 0;
					counting <= 0;
					done <= 0;
					shift_counter <= 0;
				end
			endcase
		end
	end

	always @(*) begin
		next_state = current_state; // Default state is to remain in the same state
		case(current_state)
			IDLE: begin
				if (data)
					next_state = DETECT_1_0;
			end
			DETECT_1_0: begin
				if (data)
					next_state = DETECT_1_1;
				else
					next_state = IDLE;
			end
			DETECT_1_1: begin
				if (~data)
					next_state = DETECT_0;
				else
					next_state = DETECT_1_1;
			end
			DETECT_0: begin
				if (data)
					next_state = SHIFT;
				else
					next_state = IDLE;
			end
			SHIFT: begin
				if (shift_counter == 2'd3)
					next_state = COUNT;
			end
			COUNT: begin
				if (done_counting)
					next_state = DONE;
			end
			DONE: begin
				if (ack)
					next_state = IDLE;
			end
		endcase
	end

endmodule