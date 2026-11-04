module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	input dig,
	output walk_left,
	output walk_right,
	output aaah,
	output digging
);

	parameter IDLE = 0;
	parameter WALK_LEFT = 1;
	parameter WALK_RIGHT = 2;
	parameter FALL = 3;
	parameter DIG = 4;

	reg [2:0] state, next_state;
	reg [2:0] prev_state; // to store the state before falling or digging
	reg dig_request; // to store dig request

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= WALK_LEFT;
			prev_state <= IDLE;
			dig_request <= 0;
		end else begin
			state <= next_state;
		end
	end

	always @(*) begin
		next_state = state;
		dig_request = dig_request;

		case (state)
			IDLE: begin
				next_state = WALK_LEFT;
			end
			WALK_LEFT: begin
				if (!ground) begin
					next_state = FALL;
					prev_state = WALK_LEFT;
				end else if (dig && ground) begin
					next_state = DIG;
					prev_state = WALK_LEFT;
					dig_request = 1;
				end else if (bump_right) begin
					next_state = WALK_RIGHT;
				end
			end
			WALK_RIGHT: begin
				if (!ground) begin
					next_state = FALL;
					prev_state = WALK_RIGHT;
				end else if (dig && ground) begin
					next_state = DIG;
					prev_state = WALK_RIGHT;
					dig_request = 1;
				end else if (bump_left) begin
					next_state = WALK_LEFT;
				end
			end
			FALL: begin
				if (ground) begin
					next_state = (prev_state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
					dig_request = 0;
				end
			end
			DIG: begin
				if (!ground) begin
					next_state = FALL;
					dig_request = 0;
				end
			end
			default: next_state = IDLE;
		endcase
	end

	assign walk_left = (state == WALK_LEFT || (state == FALL && prev_state == WALK_LEFT)) && (state != DIG);
	assign walk_right = (state == WALK_RIGHT || (state == FALL && prev_state == WALK_RIGHT)) && (state != DIG);
	assign aaah = (state == FALL);
	assign digging = (state == DIG);
endmodule