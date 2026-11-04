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

    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    parameter DIGGING = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;
    reg falling_dir;  // 0: left, 1: right
    reg dig_dir;      // 0: left, 1: right


    always @(*) begin
        next_state = state;
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (state)
            WALK_LEFT: begin
                walk_left = 1;
                if (!ground) begin
                    next_state = FALLING;
                    falling_dir = 0;
                    aaah = 1;
                end else if (dig && ground) begin
                    next_state = DIGGING;
                    dig_dir = 0;
                    digging = 1;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                walk_right = 1;
                if (!ground) begin
                    next_state = FALLING;
                    falling_dir = 1;
                    aaah = 1;
                end else if (dig && ground) begin
                    next_state = DIGGING;
                    dig_dir = 1;
                    digging = 1;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                end
            end
            FALLING: begin
                aaah = 1;
                if (ground) begin
                    if (falling_dir == 0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end
            end
            DIGGING: begin
                digging = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig_dir == 0 && bump_right) begin // for digging left
                    next_state = WALK_RIGHT;
                end else if (dig_dir == 1 && bump_left) begin   // for digging right
                    next_state = WALK_LEFT;
                end
            end
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

endmodule