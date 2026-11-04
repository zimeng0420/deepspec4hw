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
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING = 2'b10
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (~ground) begin
                    next_state = FALLING;
                    walk_left = 1;
                    walk_right = 0;
                    aaah = 1;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                    walk_left = 0;
                    walk_right = 1;
                    aaah = 0;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                    walk_left = 1;
                    walk_right = 0;
                    aaah = 0;
                end else begin
                    next_state = WALK_LEFT;
                    walk_left = 1;
                    walk_right = 0;
                    aaah = 0;
                end
            end

            WALK_RIGHT: begin
                if (~ground) begin
                    next_state = FALLING;
                    walk_left = 0;
                    walk_right = 1;
                    aaah = 1;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                    walk_left = 0;
                    walk_right = 1;
                    aaah = 0;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                    walk_left = 1;
                    walk_right = 0;
                    aaah = 0;
                end else begin
                    next_state = WALK_RIGHT;
                    walk_left = 0;
                    walk_right = 1;
                    aaah = 0;
                end
            end

            FALLING: begin
                if (ground) begin
                    next_state = (walk_left) ? WALK_LEFT : WALK_RIGHT;
                    walk_left = walk_left;
                    walk_right = ~walk_left;
                    aaah = 0;
                end else begin
                    next_state = FALLING;
                    walk_left = walk_left;
                    walk_right = ~walk_left;
                    aaah = 1;
                end
            end

            default: begin
                next_state = WALK_LEFT;
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
            end
        endcase
    end
endmodule