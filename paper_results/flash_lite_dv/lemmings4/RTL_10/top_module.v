module top_module(
    input clk,
    input areset,
    input ground,
    input bump_left,
    input bump_right,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg falling,
    output reg dig_active,
    output reg splatter
);

    // States
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    parameter DIGGING = 2'b11;

    reg [1:0] state, next_state;
    reg [6:0] fall_counter; // Counts how long the lemmin is falling
    reg [1:0] initial_direction; // Store initial direction before falling/digging

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 7'b0;
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            falling <= 1'b0;
            dig_active <= 1'b0;
            splatter <= 1'b0;
            initial_direction <= 2'b00;
        end else begin
            state <= next_state;
        end
    end


    // Output Logic
    always @(state or ground or bump_left or bump_right or dig or fall_counter) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        falling = 1'b0;
        dig_active = 1'b0;
        next_state = state;

        if (splatter) begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            falling = 1'b0;
            dig_active = 1'b0;
            next_state = state; //stay at current state;
        end
        else begin
            case (state)
                WALK_LEFT: begin
                    walk_left = 1'b1;
                    if (!ground) begin
                        next_state = FALLING;
                        falling = 1'b1;
                        fall_counter = 7'b0;
                        initial_direction = WALK_LEFT;
                    end else if (dig && ground) begin
                        next_state = DIGGING;
                        dig_active = 1'b1;
                    end else if (bump_right) begin
                        next_state = WALK_RIGHT;
                    end
                end

                WALK_RIGHT: begin
                    walk_right = 1'b1;
                    if (!ground) begin
                        next_state = FALLING;
                        falling = 1'b1;
                        fall_counter = 7'b0;
                        initial_direction = WALK_RIGHT;
                    end else if (dig && ground) begin
                        next_state = DIGGING;
                        dig_active = 1'b1;
                    end else if (bump_left) begin
                        next_state = WALK_LEFT;
                    end
                end

                FALLING: begin
                    falling = 1'b1;
                    fall_counter = fall_counter + 1'b1;
                    if (ground) begin
                        if (fall_counter > 20) begin
                            splatter = 1'b1;
                        end else begin
                            if (initial_direction == WALK_LEFT)
                                next_state = WALK_LEFT;
                            else
                                next_state = WALK_RIGHT;

                        end

                    end
                end

                DIGGING: begin
                    dig_active = 1'b1;
                    if (!ground) begin
                        next_state = FALLING;
                        falling = 1'b1;
                        fall_counter = 7'b0;
                        initial_direction = (walk_left) ? WALK_LEFT : WALK_RIGHT;

                    end
                end

                default: begin
                    next_state = WALK_LEFT; // Default state
                end

            endcase
        end
    end

endmodule