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

    assign walk_left = (current_state == WALK) && (walking_direction == 0);
    assign walk_right = (current_state == WALK) && (walking_direction == 1);
    assign aaah = (current_state == FALL);
    assign digging = (current_state == DIG);

    // State transition logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                    fall_counter = 6'b000000; // Reset fall counter
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
                    if (fall_counter >= 6'd20) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = WALK;
                    end
                end else begin
                    next_state = FALL;
                end
            end
            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                    fall_counter = 6'b000000;
                end
            end
            SPLAT: begin
                next_state = SPLAT; //Stays in SPLAT forever
            end
            default: next_state = WALK;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK;
            walking_direction <= 0; // Start walking left
            fall_counter <= 6'b000000;
        end else begin
            current_state <= next_state;
            if (current_state == WALK && !ground) walking_direction <= walking_direction; //Keep walking direction from before the fall
            if (current_state == FALL && !ground) begin
              fall_counter <= fall_counter + 1;
            end
        end
    end

endmodule