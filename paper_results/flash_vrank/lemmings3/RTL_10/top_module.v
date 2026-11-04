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

    // State definition
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    parameter DIGGING = 2'b11;

    // State register
    reg [1:0] current_state;
    reg [1:0] next_state;

    // Walking direction register (to preserve direction after falling)
    reg walking_direction; // 0 for left, 1 for right
    reg next_walking_direction;

    // Output signals
    assign walk_left = (current_state == WALK_LEFT);
    assign walk_right = (current_state == WALK_RIGHT);
    assign aaah = (current_state == FALLING);
    assign digging = (current_state == DIGGING);

    // State transition logic
    always @(*) begin
        next_state = current_state;
        next_walking_direction = walking_direction;

        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                    next_walking_direction = 0;
                end else if (dig) begin
                    next_state = DIGGING;
                    next_walking_direction = 0;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_RIGHT;
                    next_walking_direction = 1;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                    next_walking_direction = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    next_walking_direction = 1;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                    next_walking_direction = 0;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (walking_direction == 0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                    next_walking_direction = walking_direction;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                    next_walking_direction = walking_direction;
                end
            end
            default: begin
                next_state = WALK_LEFT;
                next_walking_direction = 0;
            end
        endcase
    end

    // State update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            walking_direction <= 0;
        end else begin
            current_state <= next_state;
            walking_direction <= next_walking_direction;
        end
    end

endmodule