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

    // State definitions
    localparam WALK_LEFT_STATE = 2'b00;
    localparam WALK_RIGHT_STATE = 2'b01;
    localparam FALL_STATE = 2'b10;
    localparam DIG_STATE = 2'b11;
    localparam SPLAT_STATE = 2'b11; //Using same state because outputs are all zero

    reg [1:0] current_state;
    reg [1:0] next_state;
    reg walk_left_r;
    reg walk_right_r;
    reg aaah_r;
    reg digging_r;

    reg [5:0] fall_counter;

    assign walk_left = walk_left_r;
    assign walk_right = walk_right_r;
    assign aaah = aaah_r;
    assign digging = digging_r;


    // State transition logic
    always @(*) begin
        next_state = current_state; // Default: stay in the same state
        walk_left_r = 1'b0;
        walk_right_r = 1'b0;
        aaah_r = 1'b0;
        digging_r = 1'b0;

        case (current_state)
            WALK_LEFT_STATE: begin
                walk_left_r = 1'b1;
                if (~ground) begin
                    next_state = FALL_STATE;
                    aaah_r = 1'b1;
                end else if (dig) begin
                    next_state = DIG_STATE;
                    digging_r = 1'b1;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT_STATE;
                    walk_left_r = 0;
                    walk_right_r = 1;
                end else if (bump_right) begin
                   next_state = WALK_RIGHT_STATE;
                   walk_left_r = 0;
                   walk_right_r = 1;
                end
            end
            WALK_RIGHT_STATE: begin
                walk_right_r = 1'b1;
                if (~ground) begin
                    next_state = FALL_STATE;
                    aaah_r = 1'b1;
                end else if (dig) begin
                    next_state = DIG_STATE;
                    digging_r = 1'b1;
                end else if (bump_right) begin
                    next_state = WALK_LEFT_STATE;
                    walk_right_r = 0;
                    walk_left_r = 1;
                end else if (bump_left) begin
                   next_state = WALK_LEFT_STATE;
                   walk_right_r = 0;
                   walk_left_r = 1;
                end
            end
            FALL_STATE: begin
                aaah_r = 1'b1;
                if (ground) begin
                    if (fall_counter >= 21) begin
                        next_state = SPLAT_STATE;
                    end else begin
                        if (walk_left_r)
                            next_state = WALK_LEFT_STATE;
                        else
                            next_state = WALK_RIGHT_STATE;
                    end
                end
            end
            DIG_STATE: begin
                digging_r = 1'b1;
                if (~ground) begin
                    next_state = FALL_STATE;
                    aaah_r = 1'b1;
                    digging_r = 0;
                end
            end
            SPLAT_STATE: begin
                walk_left_r = 0;
                walk_right_r = 0;
                aaah_r = 0;
                digging_r = 0;
                next_state = SPLAT_STATE;
            end
        endcase
    end

    // State update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT_STATE;
            walk_left_r <= 1'b1;
            walk_right_r <= 1'b0;
            aaah_r <= 1'b0;
            digging_r <= 1'b0;
            fall_counter <= 6'b0;
        } else begin
            current_state <= next_state;
            if(current_state == FALL_STATE && ~ground) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 6'b0;
            end
             walk_left_r <= (next_state == WALK_LEFT_STATE)? 1'b1 : ((next_state == WALK_RIGHT_STATE) ? 1'b0 : ((next_state == SPLAT_STATE) ? 1'b0 : walk_left_r));
             walk_right_r <= (next_state == WALK_RIGHT_STATE)? 1'b1 : ((next_state == WALK_LEFT_STATE) ? 1'b0 : ((next_state == SPLAT_STATE) ? 1'b0 : walk_right_r));

            aaah_r <= (next_state == FALL_STATE) ? 1'b1: 1'b0;
            digging_r <= (next_state == DIG_STATE) ? 1'b1: 1'b0;
        end
    end

endmodule