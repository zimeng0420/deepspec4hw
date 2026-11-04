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

    reg [1:0] state, next_state;
    reg [4:0] fall_counter; // 5 bits to count up to 20

    parameter WALK_LEFT = 2'b00,
              WALK_RIGHT = 2'b01,
              FALLING = 2'b10,
              DIGGING = 2'b11,
              SPLATTERED = 2'b100;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
            fall_counter <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (state)
            WALK_LEFT: begin
                walk_left = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    digging = 1;
                    next_state = DIGGING;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                end
            end

            WALK_RIGHT: begin
                walk_right = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    digging = 1;
                    next_state = DIGGING;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                end
            end

            FALLING: begin
                aaah = 1;
                fall_counter = fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLATTERED;
                    end else if (walk_left) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                    fall_counter = 0;
                end
            end

            DIGGING: begin
                digging = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (bump_left || bump_right) begin
                    // remain in DIGGING
                end
            end

            SPLATTERED: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end

endmodule