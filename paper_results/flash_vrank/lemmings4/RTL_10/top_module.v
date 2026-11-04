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
    localparam SPLATTER = 2'b11;


    reg [1:0] current_state, next_state;
    reg [4:0] fall_counter;
    reg walking_direction; // 0: left, 1: right
    reg is_splattered;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            walking_direction <= 0;
            fall_counter <= 0;
            is_splattered <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == FALL)
                fall_counter <= fall_counter + 1;
            else
                fall_counter <= 0;
        end
    end

    always @(*) begin
        next_state = current_state; // Default: stay in the same state
        case (current_state)
            WALK_LEFT: begin
                if (is_splattered)
                  next_state = WALK_LEFT;
                else if (!ground) begin
                    next_state = FALL;
                    walking_direction <= 0;
                end else if (dig) begin
                    next_state = DIG;
                    walking_direction <= 0;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_RIGHT;
                    walking_direction <= 1;
                end
            end
            WALK_RIGHT: begin
                if (is_splattered)
                  next_state = WALK_RIGHT;
                else if (!ground) begin
                    next_state = FALL;
                    walking_direction <= 1;
                end else if (dig) begin
                    next_state = DIG;
                    walking_direction <= 1;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                    walking_direction <= 0;
                end
            end
            FALL: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLATTER;
                    end else begin
                        if (walking_direction == 0)
                            next_state = WALK_LEFT;
                        else
                            next_state = WALK_RIGHT;
                    end
                }
            end
            DIG: begin
                if (is_splattered)
                  next_state = DIG;
                else if (!ground) begin
                    next_state = FALL;
                    walking_direction <= walking_direction;
                end
            end
            SPLATTER: begin
                next_state = SPLATTER;
                is_splattered = 1;
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic
    assign walk_left = (current_state == WALK_LEFT) && !is_splattered;
    assign walk_right = (current_state == WALK_RIGHT) && !is_splattered;
    assign aaah = (current_state == FALL) && !is_splattered;
    assign digging = (current_state == DIG) && !is_splattered;

endmodule