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

    typedef enum reg [1:0] {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING, SPLATTER} state_t;
    state_t state, next_state;
    reg [4:0] fall_count; // 5 bits to count up to 20

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 0;
        end else begin
            state <= next_state;
            if (state == FALLING) begin
                fall_count <= fall_count + 1;
            end else begin
                fall_count <= 0;
            end
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
                if (bump_right) begin
                    next_state = WALK_RIGHT;
                end else if (ground == 0) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end else begin
                    walk_left = 1;
                end
            end

            WALK_RIGHT: begin
                if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (ground == 0) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end else begin
                    walk_right = 1;
                end
            end

            FALLING: begin
                aaah = 1;
                if (ground && fall_count <= 20) begin
                    if (walk_left) next_state = WALK_LEFT;
                    else if (walk_right) next_state = WALK_RIGHT;
                end else if (ground && fall_count > 20) begin
                    next_state = SPLATTER;
                end
            end

            DIGGING: begin
                if (ground == 0) begin
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