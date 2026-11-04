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

    // Direction register
    reg walking_left, next_walking_left;

    // Fall counter
    reg [5:0] fall_counter, next_fall_counter;

    // Output registers
    reg current_walk_left, next_walk_left;
    reg current_walk_right, next_walk_right;
    reg current_aaah, next_aaah;
    reg current_digging, next_digging;

    // State transition logic
    always @(*) begin
        next_state = current_state;
        next_walking_left = walking_left;
        next_fall_counter = fall_counter;
        next_walk_left = current_walk_left;
        next_walk_right = current_walk_right;
        next_aaah = current_aaah;
        next_digging = current_digging;

        case (current_state)
            WALK: begin
                next_walk_left = walking_left;
                next_walk_right = !walking_left;
                next_aaah = 0;
                next_digging = 0;
                if (!ground) begin
                    next_state = FALL;
                    next_fall_counter = 0;
                    next_walk_left = 0;
                    next_walk_right = 0;
                    next_aaah = 1;
                    next_digging = 0;
                end else if (dig) begin
                    next_state = DIG;
                    next_digging = 1;
                    next_walk_left = 0;
                    next_walk_right = 0;
                end else if (bump_left) begin
                    next_walking_left = 0;
                end else if (bump_right) begin
                    next_walking_left = 1;
                end
            end
            FALL: begin
                next_walk_left = 0;
                next_walk_right = 0;
                next_aaah = 1;
                next_digging = 0;
                if (ground) begin
                    if (fall_counter >= 20) begin
                        next_state = SPLAT;
                        next_walk_left = 0;
                        next_walk_right = 0;
                        next_aaah = 0;
                        next_digging = 0;
                    end else begin
                        next_state = WALK;
                        next_walk_left = walking_left;
                        next_walk_right = !walking_left;
                        next_aaah = 0;
                        next_digging = 0;
                    end
                end else begin
                    next_fall_counter = fall_counter + 1;
                end
            end
            DIG: begin
                next_walk_left = 0;
                next_walk_right = 0;
                next_aaah = 0;
                next_digging = 1;
                if (!ground) begin
                    next_state = FALL;
                    next_fall_counter = 0;
                    next_aaah = 1;
                    next_digging = 0;
                end
            end
            SPLAT: begin
                next_walk_left = 0;
                next_walk_right = 0;
                next_aaah = 0;
                next_digging = 0;
            end
            default: begin
                next_state = WALK;
                next_walking_left = 1;
                next_fall_counter = 0;
                next_walk_left = 1;
                next_walk_right = 0;
                next_aaah = 0;
                next_digging = 0;
            end
        endcase
    end

    // State update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK;
            walking_left <= 1;
            fall_counter <= 0;
            current_walk_left <= 1;
            current_walk_right <= 0;
            current_aaah <= 0;
            current_digging <= 0;
        end else begin
            current_state <= next_state;
            walking_left <= next_walking_left;
            fall_counter <= next_fall_counter;
            current_walk_left <= next_walk_left;
            current_walk_right <= next_walk_right;
            current_aaah <= next_aaah;
            current_digging <= next_digging;
        end
    end

    // Output assignments
    assign walk_left = current_walk_left;
    assign walk_right = current_walk_right;
    assign aaah = current_aaah;
    assign digging = current_digging;

endmodule