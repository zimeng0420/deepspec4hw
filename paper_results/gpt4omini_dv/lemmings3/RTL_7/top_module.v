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

    typedef enum reg [1:0] {
        STATE_WALK_LEFT = 2'b00,
        STATE_WALK_RIGHT = 2'b01,
        STATE_FALLING = 2'b10,
        STATE_DIGGING = 2'b11
    } state_t;

    state_t current_state, next_state;

    always @ (posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    always @* begin
        // Default outputs
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        
        case (current_state)
            STATE_WALK_LEFT: begin
                walk_left = 1;
                if (ground == 0) begin
                    next_state = STATE_FALLING;
                end else if (dig == 1) begin
                    next_state = STATE_DIGGING;
                end else if (bump_right == 1) begin
                    next_state = STATE_WALK_RIGHT;
                end else begin
                    next_state = STATE_WALK_LEFT;
                end
            end

            STATE_WALK_RIGHT: begin
                walk_right = 1;
                if (ground == 0) begin
                    next_state = STATE_FALLING;
                end else if (dig == 1) begin
                    next_state = STATE_DIGGING;
                end else if (bump_left == 1) begin
                    next_state = STATE_WALK_LEFT;
                end else begin
                    next_state = STATE_WALK_RIGHT;
                end
            end

            STATE_FALLING: begin
                aaah = 1;
                if (ground == 1) begin
                    if (current_state == STATE_DIGGING) begin
                        next_state = STATE_WALK_LEFT; // resume walking the same way while digging
                    end else if (current_state == STATE_WALK_LEFT) begin
                        next_state = STATE_WALK_LEFT;
                    end else begin
                        next_state = STATE_WALK_RIGHT;
                    end
                end else begin
                    next_state = STATE_FALLING;
                end
            end

            STATE_DIGGING: begin
                digging = 1;
                if (ground == 0) begin
                    next_state = STATE_FALLING;
                end else begin
                    next_state = STATE_DIGGING;
                end
            end

            default: begin
                next_state = STATE_WALK_LEFT; // Default state in case of error
            end
        endcase
    end

endmodule