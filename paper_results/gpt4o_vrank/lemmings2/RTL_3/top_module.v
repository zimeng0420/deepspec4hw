module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    typedef enum reg [1:0] {
        LEFT_WALK = 2'b00,
        RIGHT_WALK = 2'b01,
        LEFT_FALL = 2'b10,
        RIGHT_FALL = 2'b11
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= LEFT_WALK;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            LEFT_WALK: begin
                if (!ground)
                    next_state = LEFT_FALL;
                else if (bump_left || bump_right)
                    next_state = RIGHT_WALK;
                else
                    next_state = LEFT_WALK;
            end

            RIGHT_WALK: begin
                if (!ground)
                    next_state = RIGHT_FALL;
                else if (bump_right || bump_left)
                    next_state = LEFT_WALK;
                else
                    next_state = RIGHT_WALK;
            end

            LEFT_FALL: begin
                if (ground)
                    next_state = LEFT_WALK;
                else
                    next_state = LEFT_FALL;
            end

            RIGHT_FALL: begin
                if (ground)
                    next_state = RIGHT_WALK;
                else
                    next_state = RIGHT_FALL;
            end

            default: next_state = LEFT_WALK;
        endcase
    end

    always @(*) begin
        walk_left = (current_state == LEFT_WALK);
        walk_right = (current_state == RIGHT_WALK);
        aaah = (current_state == LEFT_FALL) || (current_state == RIGHT_FALL);
    end

endmodule