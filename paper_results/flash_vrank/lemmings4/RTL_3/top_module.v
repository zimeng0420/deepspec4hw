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

    reg [1:0] current_state, next_state;
    reg walking_direction; // 0 for left, 1 for right
    reg [5:0] fall_counter;
    reg r_walk_left, r_walk_right, r_aaah, r_digging;

    // State transition logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                    fall_counter = 6'd0;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_left) begin
                    walking_direction = 1;
                end else if (bump_right) begin
                    walking_direction = 0;
                end
            end
            FALL: begin
                if (ground) begin
                    if (fall_counter > 6'd20) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = WALK;
                    end
                end else begin
                    fall_counter = fall_counter + 1;
                end
            end
            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                    fall_counter = 6'd0;
                end
            end
            SPLAT: begin
                // Stay in SPLAT state
            end
        endcase
    end

    // State register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK;
            walking_direction <= 0; // Walk left
            fall_counter <= 6'd0;
        end else begin
            current_state <= next_state;
        end
    end

    //Output Logic
    always @(*) begin
        r_walk_left = 0;
        r_walk_right = 0;
        r_aaah = 0;
        r_digging = 0;

        case (current_state)
            WALK: begin
                if (walking_direction == 0) begin
                    r_walk_left = 1;
                end else begin
                    r_walk_right = 1;
                end
            end
            FALL: begin
                r_aaah = 1;
                if (walking_direction == 0) begin
                    r_walk_left = 1;
                end else begin
                    r_walk_right = 1;
                end
            end
            DIG: begin
                r_digging = 1;
                if (walking_direction == 0) begin
                    r_walk_left = 1;
                end else begin
                    r_walk_right = 1;
                end
            end
            SPLAT: begin
                // All outputs remain at 0
            end
        endcase
    end

    assign walk_left = r_walk_left;
    assign walk_right = r_walk_right;
    assign aaah = r_aaah;
    assign digging = r_digging;


endmodule