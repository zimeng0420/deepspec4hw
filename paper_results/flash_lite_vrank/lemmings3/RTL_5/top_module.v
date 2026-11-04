module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	input dig,
	output reg walk_left,
	output reg walk_right,
	output reg aaah,
	output reg digging
);

    parameter IDLE = 2'b00;
    parameter WALK_LEFT = 2'b01;
    parameter WALK_RIGHT = 2'b10;
    parameter FALL = 2'b11;
    parameter DIG = 2'b10;

    reg [1:0] state, next_state;
    reg prev_ground;
    reg dig_req;
    reg walk_dir; // 0: left, 1: right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            digging <= 0;
            aaah <= 0;
            walk_left <= 1;
            walk_right <= 0;
            walk_dir <= 0;
            prev_ground <= 1;
        end else begin
            state <= next_state;
            prev_ground <= ground;
        end
    end

    always @(*) begin
        next_state = state;
        dig_req = dig && ground && (state == IDLE || state == WALK_LEFT || state == WALK_RIGHT);

        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (state)
            IDLE: begin
                if (ground == 0) begin
                    next_state = FALL;
                    aaah = 1;
                end else if (dig_req) begin
                    next_state = DIG;
                    digging = 1;
                end else begin
                   if(walk_dir == 0) begin
                       walk_left = 1;
                   end else begin
                       walk_right = 1;
                   end
                end
            end
            WALK_LEFT: begin
                if (ground == 0) begin
                    next_state = FALL;
                    aaah = 1;
                end else if (dig_req) begin
                    next_state = DIG;
                    digging = 1;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                    walk_dir = 1;
                    walk_right = 1;
                end else begin
                    next_state = IDLE;
                    walk_left = 1;
                end
            end
            WALK_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALL;
                    aaah = 1;
                end else if (dig_req) begin
                    next_state = DIG;
                    digging = 1;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                    walk_dir = 0;
                    walk_left = 1;
                end else begin
                    next_state = IDLE;
                    walk_right = 1;
                end
            end
            FALL: begin
                aaah = 1;
                if (ground) begin
                    next_state = IDLE;
                end
            end
            DIG: begin
                digging = 1;
                if(ground == 0) begin
                    next_state = FALL;
                    aaah = 1;
                end else begin
                   if (walk_dir == 0) begin
                       walk_left = 1;
                   end else begin
                       walk_right = 1;
                   end
                end
            end
            default: begin
                next_state = IDLE;
                walk_left = 1;
            end
        endcase

    end
end