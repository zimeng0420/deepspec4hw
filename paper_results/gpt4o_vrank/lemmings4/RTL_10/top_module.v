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

    typedef enum reg [2:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALL_LEFT,
        FALL_RIGHT,
        DIG_LEFT,
        DIG_RIGHT,
        SPLAT
    } state_t;

    state_t state, next_state;
    reg [4:0] fall_counter;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            if (aaah)
                fall_counter <= fall_counter + 1;
            else
                fall_counter <= 0;
        end
    end

    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        next_state = state;

        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    aaah = 1;
                    next_state = FALL_LEFT;
                end else if (dig) begin
                    digging = 1;
                    next_state = DIG_LEFT;
                end else if (bump_left) begin
                    walk_right = 1;
                    next_state = WALK_RIGHT;
                end else begin
                    walk_left = 1;
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    aaah = 1;
                    next_state = FALL_RIGHT;
                end else if (dig) begin
                    digging = 1;
                    next_state = DIG_RIGHT;
                end else if (bump_right) begin
                    walk_left = 1;
                    next_state = WALK_LEFT;
                end else begin
                    walk_right = 1;
                    next_state = WALK_RIGHT;
                end
            end

            FALL_LEFT: begin
                aaah = 1;
                if (ground) begin
                    if (fall_counter < 21) begin
                        walk_left = 1;
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = SPLAT;
                    end
                end
            end

            FALL_RIGHT: begin
                aaah = 1;
                if (ground) begin
                    if (fall_counter < 21) begin
                        walk_right = 1;
                        next_state = WALK_RIGHT;
                    end else begin
                        next_state = SPLAT;
                    end
                end
            end

            DIG_LEFT: begin
                digging = 1;
                if (!ground) begin
                    aaah = 1;
                    next_state = FALL_LEFT;
                end
            end

            DIG_RIGHT: begin
                digging = 1;
                if (!ground) begin
                    aaah = 1;
                    next_state = FALL_RIGHT;
                end
            end

            SPLAT: begin
                // Remain in SPLAT state, all outputs are zeros.
                next_state = SPLAT;
            end
        endcase
    end
endmodule