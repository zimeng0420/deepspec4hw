module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    parameter IDLE = 0, WALK_LEFT = 1, WALK_RIGHT = 2, FALLING = 3, DIGGING = 4, SPLATTER = 5;
    reg [2:0] state, next_state;
    reg [5:0] fall_counter;
    reg prev_ground;
    reg walk_left_reg, walk_right_reg, aaah_reg, digging_reg;


    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            fall_counter <= 0;
            walk_left_reg <= 1;
            walk_right_reg <= 0;
            aaah_reg <= 0;
            digging_reg <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        walk_left_reg = walk_left;
        walk_right_reg = walk_right;
        aaah_reg = 0;
        digging_reg = 0;

        case (state)
            IDLE: begin
                walk_left_reg = 1;
                walk_right_reg = 0;
                if (!ground) begin
                    next_state = FALLING;
                    aaah_reg = 1;
                    fall_counter = 1;
                end
            end
            WALK_LEFT: begin
                walk_left_reg = 1;
                walk_right_reg = 0;
                if (!ground) begin
                    next_state = FALLING;
                    aaah_reg = 1;
                    fall_counter = 1;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                end else if (dig && ground) begin
                  next_state = DIGGING;
                  digging_reg = 1;
                end
            end
            WALK_RIGHT: begin
                walk_left_reg = 0;
                walk_right_reg = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah_reg = 1;
                    fall_counter = 1;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (dig && ground) begin
                  next_state = DIGGING;
                  digging_reg = 1;
                end
            end
            FALLING: begin
                walk_left_reg = 0;
                walk_right_reg = 0;
                aaah_reg = 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLATTER;
                    end else begin
                        if(walk_left_reg)
                            next_state = WALK_LEFT;
                        else
                            next_state = WALK_RIGHT;
                    end
                    fall_counter = 0;
                end else begin
                    fall_counter = fall_counter + 1;
                end
            end
            DIGGING: begin
                digging_reg = 1;
                walk_left_reg = 0;
                walk_right_reg = 0;
                if (!ground) begin
                    next_state = FALLING;
                    aaah_reg = 1;
                    fall_counter = 1;
                end
            end
            SPLATTER: begin
                walk_left_reg = 0;
                walk_right_reg = 0;
                aaah_reg = 0;
                digging_reg = 0;
            end
            default: begin
                next_state = IDLE;
                walk_left_reg = 1;
                walk_right_reg = 0;
            end
        endcase
    end

    assign walk_left = walk_left_reg;
    assign walk_right = walk_right_reg;
    assign aaah = aaah_reg;
    assign digging = digging_reg;

endmodule