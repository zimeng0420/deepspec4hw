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
    localparam SPLATTER = 2'b11; // Reuse DIG state after splatter

    reg [1:0] current_state, next_state;
    reg [4:0] fall_counter;
    reg walking_direction; // 0 for left, 1 for right
    reg splatter;

    assign walk_left = (current_state == WALK_LEFT && !splatter);
    assign walk_right = (current_state == WALK_RIGHT && !splatter);
    assign aaah = (current_state == FALL && !splatter);
    assign digging = (current_state == DIG && !splatter);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            walking_direction <= 0;
            fall_counter <= 0;
            splatter <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == FALL) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end

            if (current_state == SPLATTER) begin
                fall_counter <= 0;
                splatter <= 1;
                walking_direction <= walking_direction; // keep direction after splatter
            end
        end
    end

    always @(*) begin
        next_state = current_state; // Default: stay in the same state

        if (splatter) begin
          next_state = SPLATTER;
        end else if (current_state == FALL) begin
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTER;
                    splatter = 1;
                } else begin
                    if (walking_direction == 0) begin
                        next_state = WALK_LEFT;
                    } else begin
                        next_state = WALK_RIGHT;
                    end
                end
            end else begin
              next_state = FALL;
            end
        } else if (current_state == DIG) begin
            if (!ground) begin
                next_state = FALL;
                fall_counter = 0;
            } else {
                next_state = DIG;
            }
        } else if (ground && dig) begin
            next_state = DIG;
            fall_counter = 0;
        } else if (!ground) begin
            next_state = FALL;
            fall_counter = 0;
        } else if (current_state == WALK_LEFT && (bump_left || bump_right)) begin
            next_state = WALK_RIGHT;
            walking_direction = 1;
        } else if (current_state == WALK_RIGHT && (bump_left || bump_right)) begin
            next_state = WALK_LEFT;
            walking_direction = 0;
        } else if (current_state == WALK_LEFT) begin
            next_state = WALK_LEFT;
            walking_direction = 0;
        } else if (current_state == WALK_RIGHT) begin
            next_state = WALK_RIGHT;
            walking_direction = 1;
        end
    end
endmodule