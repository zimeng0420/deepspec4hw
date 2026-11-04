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
    localparam WALK_LEFT = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL = 2'b10;
    localparam DIG = 2'b11;

    reg [1:0] current_state, next_state;
    reg current_direction, next_direction; // 1 for left, 0 for right

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            current_direction <= 1; // Start walking left
        end else begin
            current_state <= next_state;
            current_direction <= next_direction;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        next_direction = current_direction;

        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_RIGHT;
                    next_direction = 0;
                end else begin
                    next_state = WALK_LEFT;
                    next_direction = 1;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                    next_direction = 1;
                end else begin
                    next_state = WALK_RIGHT;
                    next_direction = 0;
                end
            end
            FALL: begin
                if (ground) begin
                    if (current_direction) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    next_state = FALL;
                end
            end
            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                    
                end else begin
                    next_state = DIG;
                end
            end
            default: begin
                next_state = WALK_LEFT;
                next_direction = 1;
            end
        endcase
    end

    // Output logic
    assign walk_left = (current_state == WALK_LEFT);
    assign walk_right = (current_state == WALK_RIGHT);
    assign aaah = (current_state == FALL);
    assign digging = (current_state == DIG);

endmodule