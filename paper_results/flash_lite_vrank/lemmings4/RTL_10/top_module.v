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

	// States
	localparam WALK_LEFT = 2'b00;
	localparam WALK_RIGHT = 2'b01;
	localparam FALL = 2'b10;
	localparam DIG = 2'b11;

	reg [1:0] state;
	reg [1:0] next_state;
	reg [5:0] fall_counter;
	reg [1:0] prev_state; // Store the state before falling or digging

	// Outputs
	always @(*) begin
		walk_left = 0;
		walk_right = 0;
		aaah = 0;
		digging = 0;
		
		case (state)
			WALK_LEFT: begin
				walk_left = 1;
				if (!ground)
					next_state = FALL;
				else if (dig && ground)
					next_state = DIG;
				else if (bump_right)
					next_state = WALK_RIGHT;
				else
					next_state = WALK_LEFT;
			end
			WALK_RIGHT: begin
				walk_right = 1;
				if (!ground)
					next_state = FALL;
				else if (dig && ground)
					next_state = DIG;
				else if (bump_left)
					next_state = WALK_LEFT;
				else
					next_state = WALK_RIGHT;
			end
			FALL: begin
				aaah = 1;
				if (ground) {
                    if(fall_counter > 20)
                        next_state = state; //splatter
                    else
				        next_state = prev_state;
                }
				else
					next_state = FALL;

			end
			DIG: begin
				digging = 1;
				if (!ground)
					next_state = FALL;
				else
					next_state = DIG;
			end
			default: begin
				next_state = WALK_LEFT;
			end
		endcase
	end

	// Sequential logic for state update
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= WALK_LEFT;
			fall_counter <= 0;
		end else begin
			state <= next_state;
		end
	end

    always @(posedge clk) begin
        if (state == FALL) begin
            if(ground)
                fall_counter <= (fall_counter > 20) ? fall_counter : 0;
            else
                fall_counter <= fall_counter + 1;
        end
        else
            fall_counter <= 0;
    end
    
    always @(posedge clk) begin
        if (state == FALL || state == DIG) begin
            prev_state <= (state == FALL && ground) ? prev_state : state;
        end
        else if (state != FALL && state != DIG)
            prev_state <= state;
    end


endmodule