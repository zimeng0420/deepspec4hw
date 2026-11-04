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

    typedef enum logic [2:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALLING,
        DIGGING,
        SPLATTER
    } state_t;

    state_t current_state, next_state;
    reg [4:0] fall_counter;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == FALLING) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    always_ff @(current_state, ground, bump_left, bump_right, dig) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        next_state = current_state;

        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                end
                walk_left = 1;
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                end
                walk_right = 1;
            end

            FALLING: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLATTER;
                    end else begin
                        if (walk_left) next_state = WALK_LEFT;
                        else if (walk_right) next_state = WALK_RIGHT;
                    end
                end
                aaah = 1;
            end

            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else begin
                    digging = 1;
                end
            end

            SPLATTER: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end
endmodule