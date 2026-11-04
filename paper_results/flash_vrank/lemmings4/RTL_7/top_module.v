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

    // Define states
    localparam WALK = 2'b00;
    localparam FALL = 2'b01;
    localparam DIG = 2'b10;
    localparam SPLAT = 2'b11;

    // State register
    reg [1:0] current_state, next_state;

    // Walking direction register (1 = left, 0 = right)
    reg walking_direction, next_walking_direction;

    // Falling counter
    reg [5:0] fall_counter, next_fall_counter;

    // Output registers
    reg r_walk_left, r_walk_right, r_aaah, r_digging;

    // State transition logic
    always @(*) begin
        next_state = current_state;
        next_walking_direction = walking_direction;
        next_fall_counter = fall_counter;
        r_walk_left = 0;
        r_walk_right = 0;
        r_aaah = 0;
        r_digging = 0;

        case (current_state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                    next_fall_counter = 0;
                    r_aaah = 1;
                end else if (dig) begin
                    next_state = DIG;
                    r_digging = 1;
                    next_walking_direction = walking_direction;
                end else if (bump_left) begin
                    next_walking_direction = 0;  // Walk right
                end else if (bump_right) begin
                    next_walking_direction = 1;  // Walk left
                end else begin
                    next_walking_direction = walking_direction;
                end

                if (next_walking_direction) begin
                    r_walk_left = 1;
                end else begin
                    r_walk_right = 1;
                end
            end
            FALL: begin
                r_aaah = 1;
                next_fall_counter = fall_counter + 1;

                if (ground) begin
                    if (fall_counter >= 20) begin
                        next_state = SPLAT;
                        r_walk_left = 0;
                        r_walk_right = 0;
                        r_aaah = 0;
                        r_digging = 0;

                    } else begin
                        next_state = WALK;
                        next_walking_direction = walking_direction;
                        if (walking_direction) begin
                            r_walk_left = 1;
                        end else begin
                            r_walk_right = 1;
                        end

                    end
                end else begin
                    next_walking_direction = walking_direction;
                end


            end
            DIG: begin
                r_digging = 1;
                next_walking_direction = walking_direction;
                if (!ground) begin
                    next_state = FALL;
                    next_fall_counter = 0;
                    r_aaah = 1;
                    r_digging = 0;
                end else begin
                    next_walking_direction = walking_direction;
                    r_digging = 1;
                end
            end
            SPLAT: begin
                r_walk_left = 0;
                r_walk_right = 0;
                r_aaah = 0;
                r_digging = 0;
                next_state = SPLAT;
            end
            default: begin
                next_state = WALK;
                next_walking_direction = 1;
                r_walk_left = 1;
            end
        endcase
    end

    // State update logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALK;
            walking_direction <= 1;  // Start walking left
            fall_counter <= 0;
        end else begin
            current_state <= next_state;
            walking_direction <= next_walking_direction;
            fall_counter <= next_fall_counter;
        end
    end

    // Output assignments
    assign walk_left = r_walk_left;
    assign walk_right = r_walk_right;
    assign aaah = r_aaah;
    assign digging = r_digging;

endmodule