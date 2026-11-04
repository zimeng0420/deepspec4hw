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

    // State definition
    localparam WALK_LEFT_STATE  = 2'b00;
    localparam WALK_RIGHT_STATE = 2'b01;
    localparam FALLING_STATE    = 2'b10;
    localparam DIGGING_STATE    = 2'b11;

    // State register
    reg [1:0] current_state;
    reg [1:0] next_state;

    // Falling counter
    reg [5:0] fall_counter;

    // Output registers
    reg walk_left_r;
    reg walk_right_r;
    reg aaah_r;
    reg digging_r;
    reg splattered;

    // Assign outputs
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
                if (!ground) begin
                    next_state = FALLING_STATE;
                    aaah_r = 1'b1;
                    walk_left_r = 1'b1;
                end else if (dig) begin
                    next_state = DIGGING_STATE;
                    digging_r = 1'b1;
                    walk_left_r = 1'b1;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT_STATE;
                    walk_right_r = 1'b1;
                end else begin
                    walk_left_r = 1'b1;
                end
            end

            WALK_RIGHT_STATE: begin
                if (!ground) begin
                    next_state = FALLING_STATE;
                    aaah_r = 1'b1;
                    walk_right_r = 1'b1;
                end else if (dig) begin
                    next_state = DIGGING_STATE;
                    digging_r = 1'b1;
                    walk_right_r = 1'b1;
                end else if (bump_left) begin
                    next_state = WALK_LEFT_STATE;
                    walk_left_r = 1'b1;
                end else begin
                    walk_right_r = 1'b1;
                end
            end

            FALLING_STATE: begin
                aaah_r = 1'b1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        splattered = 1'b1;
                        walk_left_r = 1'b0;
                        walk_right_r = 1'b0;
                        aaah_r = 1'b0;
                        digging_r = 1'b0;
                    end else begin
                        if (walk_left_r) begin
                            next_state = WALK_LEFT_STATE;
                            walk_left_r = 1'b1;
                        end else begin
                            next_state = WALK_RIGHT_STATE;
                            walk_right_r = 1'b1;
                        end
                    end
                end else {
                    if (walk_left_r) walk_left_r = 1'b1;
                    else walk_right_r = 1'b1;
                }
            end

            DIGGING_STATE: begin
                digging_r = 1'b1;
                if (!ground) begin
                    next_state = FALLING_STATE;
                    aaah_r = 1'b1;
                    if (walk_left_r) walk_left_r = 1'b1;
                    else walk_right_r = 1'b1;
                } else {
                    if (walk_left_r) walk_left_r = 1'b1;
                    else walk_right_r = 1'b1;
                }
            end

            default: begin
                next_state = WALK_LEFT_STATE;
                walk_left_r = 1'b1;
            end
        endcase

        if (splattered) begin
            walk_left_r = 1'b0;
            walk_right_r = 1'b0;
            aaah_r = 1'b0;
            digging_r = 1'b0;
        end
    end

    // State update and falling counter
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT_STATE;
            walk_left_r <= 1'b1;
            walk_right_r <= 1'b0;
            aaah_r <= 1'b0;
            digging_r <= 1'b0;
            fall_counter <= 6'b0;
            splattered <= 1'b0;
        } else begin
            current_state <= next_state;
            walk_left_r <= (splattered) ? 1'b0 : ((next_state == WALK_LEFT_STATE || next_state == FALLING_STATE || next_state == DIGGING_STATE) && (walk_left_r || next_state == WALK_LEFT_STATE)) ? 1'b1 : 1'b0;
            walk_right_r <= (splattered) ? 1'b0 : ((next_state == WALK_RIGHT_STATE || next_state == FALLING_STATE || next_state == DIGGING_STATE) && (walk_right_r || next_state == WALK_RIGHT_STATE)) ? 1'b1 : 1'b0;
            aaah_r <= (splattered) ? 1'b0 : (next_state == FALLING_STATE) ? 1'b1 : 1'b0;
            digging_r <= (splattered) ? 1'b0 : (next_state == DIGGING_STATE) ? 1'b1 : 1'b0;

            if (!ground) begin
                fall_counter <= fall_counter + 1'b1;
            } else begin
                fall_counter <= 6'b0;
            end
        end
    end

endmodule