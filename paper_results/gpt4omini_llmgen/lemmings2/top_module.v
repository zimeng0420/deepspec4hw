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
        STATE_WALK_LEFT = 2'b00,
        STATE_WALK_RIGHT = 2'b01,
        STATE_FALLING = 2'b10
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    always @* begin
        case (current_state)
            STATE_WALK_LEFT: begin
                if (ground == 0) begin
                    next_state = STATE_FALLING;
                end else if (bump_right) begin
                    next_state = STATE_WALK_RIGHT;
                end else begin
                    next_state = STATE_WALK_LEFT;
                end
            end

            STATE_WALK_RIGHT: begin
                if (ground == 0) begin
                    next_state = STATE_FALLING;
                end else if (bump_left) begin
                    next_state = STATE_WALK_LEFT;
                end else begin
                    next_state = STATE_WALK_RIGHT;
                end
            end

            STATE_FALLING: begin
                if (ground == 1) begin
                    if (current_state == STATE_WALK_LEFT) begin
                        next_state = STATE_WALK_LEFT;
                    end else begin
                        next_state = STATE_WALK_RIGHT;
                    end
                end else begin
                    next_state = STATE_FALLING;
                end
            end
            
            default: next_state = STATE_WALK_LEFT; // safety default
        endcase
    end

    always @* begin
        case (current_state)
            STATE_WALK_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
            end

            STATE_WALK_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
            end

            STATE_FALLING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
            end

            default: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0; // safety default
            end
        endcase
    end

endmodule