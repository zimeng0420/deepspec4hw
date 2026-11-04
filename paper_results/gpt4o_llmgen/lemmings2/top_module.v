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

    // State encoding
    typedef enum logic [1:0] {
        STATE_WALK_LEFT  = 2'b00,
        STATE_WALK_RIGHT = 2'b01,
        STATE_FALL_LEFT  = 2'b10,
        STATE_FALL_RIGHT = 2'b11
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            STATE_WALK_LEFT: begin
                if (ground == 0) begin
                    next_state = STATE_FALL_LEFT;
                end else if (bump_left == 1 || (bump_left == 1 && bump_right == 1)) begin
                    next_state = STATE_WALK_RIGHT;
                end else begin
                    next_state = STATE_WALK_LEFT;
                end
            end
            STATE_WALK_RIGHT: begin
                if (ground == 0) begin
                    next_state = STATE_FALL_RIGHT;
                end else if (bump_right == 1 || (bump_left == 1 && bump_right == 1)) begin
                    next_state = STATE_WALK_LEFT;
                end else begin
                    next_state = STATE_WALK_RIGHT;
                end
            end
            STATE_FALL_LEFT: begin
                if (ground == 1) begin
                    next_state = STATE_WALK_LEFT;
                end else begin
                    next_state = STATE_FALL_LEFT;
                end
            end
            STATE_FALL_RIGHT: begin
                if (ground == 1) begin
                    next_state = STATE_WALK_RIGHT;
                end else begin
                    next_state = STATE_FALL_RIGHT;
                end
            end
            default: next_state = STATE_WALK_LEFT;
        endcase
    end

    // State update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign walk_left = (state == STATE_WALK_LEFT);
    assign walk_right = (state == STATE_WALK_RIGHT);
    assign aaah = (state == STATE_FALL_LEFT || state == STATE_FALL_RIGHT);

endmodule
