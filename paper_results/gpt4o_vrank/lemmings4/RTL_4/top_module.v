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
        LEFT = 3'h0,
        RIGHT = 3'h1,
        FALL_LEFT = 3'h2,
        FALL_RIGHT = 3'h3,
        DIG_LEFT = 3'h4,
        DIG_RIGHT = 3'h5,
        SPLATTER = 3'h6
    } state_t;

    state_t state, next_state;
    reg [4:0] fall_counter; // 5 bits for counting up to 31

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            if (aaah) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    always @(*) begin
        next_state = state; // Default to no state change
        aaah = 0;
        digging = 0;
        walk_left = 0;
        walk_right = 0;

        case (state)
            LEFT: begin
                if (~ground) begin
                    next_state = FALL_LEFT;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIG_LEFT;
                    digging = 1;
                end else begin
                    walk_left = 1;
                    if (bump_left) next_state = RIGHT;
                end
            end
            RIGHT: begin
                if (~ground) begin
                    next_state = FALL_RIGHT;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIG_RIGHT;
                    digging = 1;
                end else begin
                    walk_right = 1;
                    if (bump_right) next_state = LEFT;
                end
            end
            FALL_LEFT: begin
                aaah = 1;
                if (ground) begin
                    if (fall_counter > 20) next_state = SPLATTER;
                    else next_state = LEFT;
                end
            end
            FALL_RIGHT: begin
                aaah = 1;
                if (ground) begin
                    if (fall_counter > 20) next_state = SPLATTER;
                    else next_state = RIGHT;
                end
            end
            DIG_LEFT: begin
                digging = 1;
                if (~ground) begin
                    next_state = FALL_LEFT;
                    aaah = 1;
                end
            end
            DIG_RIGHT: begin
                digging = 1;
                if (~ground) begin
                    next_state = FALL_RIGHT;
                    aaah = 1;
                end
            end
            SPLATTER: begin
                // Remain in SPLATTER state with all outputs 0
            end
        endcase
    end

endmodule