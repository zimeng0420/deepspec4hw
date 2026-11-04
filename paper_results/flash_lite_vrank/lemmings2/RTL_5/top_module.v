module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	output walk_left,
	output walk_right,
	output aaah
);

    parameter WALKING_LEFT = 2'b00;
    parameter WALKING_RIGHT = 2'b01;
    parameter FALLING = 2'b10;

    reg [1:0] state;
    reg [1:0] next_state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALKING_LEFT;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        aaah = 0;
        walk_left = 0;
        walk_right = 0;

        case (state)
            WALKING_LEFT: begin
                walk_left = 1;
                if (ground == 0) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (bump_right) begin
                    next_state = WALKING_RIGHT;
                end
            end

            WALKING_RIGHT: begin
                walk_right = 1;
                if (ground == 0) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (bump_left) begin
                    next_state = WALKING_LEFT;
                end
            end

            FALLING: begin
                aaah = 1;
                if (ground == 1) begin
                    if (state == FALLING) begin
                      if (walk_left) begin
                         next_state = WALKING_LEFT;
                      end else begin
                         next_state = WALKING_RIGHT;
                      end
                    end
                end
            end

            default: begin
                next_state = WALKING_LEFT;
            end
        endcase
    end

endmodule