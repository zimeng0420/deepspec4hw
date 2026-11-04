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

    typedef enum logic [1:0] {
        STATE_WALK_LEFT,
        STATE_WALK_RIGHT,
        STATE_FALL,
        STATE_DIG
    } state_t;

    state_t current_state, next_state;
    reg [4:0] fall_counter;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_WALK_LEFT;
            fall_counter <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == STATE_FALL) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    always_comb begin
        next_state = current_state;
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (current_state)
            STATE_WALK_LEFT: begin
                if (!ground) begin
                    next_state = STATE_FALL;
                    aaah = 1;
                end else if (dig && ground) begin
                    next_state = STATE_DIG;
                    digging = 1;
                end else if (bump_right) begin
                    next_state = STATE_WALK_RIGHT;
                end else begin
                    walk_left = 1;
                end
            end
            STATE_WALK_RIGHT: begin
                if (!ground) begin
                    next_state = STATE_FALL;
                    aaah = 1;
                end else if (dig && ground) begin
                    next_state = STATE_DIG;
                    digging = 1;
                end else if (bump_left) begin
                    next_state = STATE_WALK_LEFT;
                end else begin
                    walk_right = 1;
                end
            end
            STATE_FALL: begin
                aaah = 1;
                if (fall_counter >= 20 && ground) begin
                    walk_left = 0;
                    walk_right = 0;
                    digging = 0;
                    aaah = 0; // Splatter
                end else if (ground) begin
                    if (walk_left) next_state = STATE_WALK_LEFT;
                    else if (walk_right) next_state = STATE_WALK_RIGHT;
                end
            end
            STATE_DIG: begin
                digging = 1;
                if (!ground) begin
                    next_state = STATE_FALL;
                    aaah = 1;
                end
            end
        endcase
    end

endmodule