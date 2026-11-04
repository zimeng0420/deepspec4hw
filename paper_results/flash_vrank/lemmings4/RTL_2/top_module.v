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
    localparam WALK = 2'b00;
    localparam FALL = 2'b01;
    localparam DIG = 2'b10;
    localparam SPLAT = 2'b11;

    // State register
    reg [1:0] current_state, next_state;

    // Direction register
    reg walk_dir, next_walk_dir; // 1 for right, 0 for left

    // Fall counter
    reg [5:0] fall_count, next_fall_count;

    // Output registers
    reg r_walk_left, r_walk_right, r_aaah, r_digging;

    // State transition logic
    always @(*) begin
        next_state = current_state;
        next_walk_dir = walk_dir;
        next_fall_count = fall_count;
        r_walk_left = 0;
        r_walk_right = 0;
        r_aaah = 0;
        r_digging = 0;

        case (current_state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                    r_aaah = 1;
					next_fall_count = 6'b000001;
                    next_walk_dir = walk_dir;
                end else if (dig) begin
                    next_state = DIG;
                    r_digging = 1;
                    next_walk_dir = walk_dir;
                end else if (bump_left) begin
                    next_walk_dir = 1; // Walk right
                end else if (bump_right) begin
                    next_walk_dir = 0; // Walk left
                end else begin
                    next_walk_dir = walk_dir;
                end

                if (next_walk_dir)
                    r_walk_right = 1;
                else
                    r_walk_left = 1;
            end

            FALL: begin
                r_aaah = 1;
                if (ground) begin
                    if (fall_count > 20) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = WALK;
                        next_walk_dir = walk_dir;
                    end
					next_fall_count = 6'b000000;
                } else begin
                    next_state = FALL;
					next_fall_count = fall_count + 1;
                    next_walk_dir = walk_dir;
                end
            end

            DIG: begin
                r_digging = 1;
                if (!ground) begin
                    next_state = FALL;
                    r_aaah = 1;
                    next_walk_dir = walk_dir;
					next_fall_count = 6'b000001;
                end else begin
                    next_state = DIG;
                    next_walk_dir = walk_dir;
                end
            end

            SPLAT: begin
                // Remain in SPLAT state, all outputs are 0
                next_state = SPLAT;
                next_walk_dir = walk_dir;
				next_fall_count = 6'b000000;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK;
            walk_dir <= 0; // Walk left
            fall_count <= 6'b000000;
        end else begin
            current_state <= next_state;
            walk_dir <= next_walk_dir;
            fall_count <= next_fall_count;
        end
    end

    // Output assignments
    assign walk_left = r_walk_left;
    assign walk_right = r_walk_right;
    assign aaah = r_aaah;
    assign digging = r_digging;

endmodule