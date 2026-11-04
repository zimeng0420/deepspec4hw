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

    state_t state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    always @(state or bump_left or bump_right or ground) begin
        aaah = 0; // reset aaah signal
        case (state)
            WALK_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                if (ground == 0) begin
                    aaah = 1; // falling
                    next_state = FALLING;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT; // switch direction
                end else if (bump_left) begin
                    next_state = WALK_RIGHT; // switch direction
                end else begin
                    next_state = WALK_LEFT; // continue walking left
                end
            end

            WALK_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                if (ground == 0) begin
                    aaah = 1; // falling
                    next_state = FALLING;
                end else if (bump_left) begin
                    next_state = WALK_LEFT; // switch direction
                end else if (bump_right) begin
                    next_state = WALK_LEFT; // switch direction
                end else begin
                    next_state = WALK_RIGHT; // continue walking right
                end
            end

            FALLING: begin
                walk_left = 0;
                walk_right = 0;
                if (ground == 1) begin
                    if (walk_left) begin
                        next_state = WALK_LEFT; // resume walking left
                    end else begin
                        next_state = WALK_RIGHT; // resume walking right
                    end
                end else begin
                    next_state = FALLING; // still falling
                end
            end

            default: begin
                next_state = WALK_LEFT; // Default state
            end
        endcase
    end

endmodule