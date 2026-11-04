module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // Define states
    parameter IDLE = 2'b00;
    parameter WALKING = 2'b01;
    parameter FALLING = 2'b10;
    parameter DIGGING = 2'b11;

    // Define state variables
    reg [1:0] current_state;
    reg [1:0] next_state;
    reg falling_timer_enable;
    reg [5:0] falling_timer;
    reg walk_left_internal; // Internal signal to track walking direction

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= IDLE;
            walk_left_internal <= 1'b1; // Default to walking left on reset
            falling_timer <= 6'b0;
            falling_timer_enable <= 1'b0;
        end else begin
            current_state <= next_state;
            if (falling_timer_enable) begin
                falling_timer <= falling_timer + 1'b1;
            end else begin
                falling_timer <= 6'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        falling_timer_enable = 1'b0;

        case (current_state)
            IDLE: begin
                if (ground == 1'b1) begin
                    if (dig == 1'b1) begin
                        next_state = DIGGING;
                    end else begin
                        next_state = WALKING;
                    end
                end else begin
                    next_state = FALLING;
                    falling_timer_enable = 1'b1;
                end
            end
            WALKING: begin
                if (ground == 1'b0) begin
                    next_state = FALLING;
                    falling_timer_enable = 1'b1;
                end else if (dig == 1'b1) begin
                    next_state = DIGGING;
                end else if (bump_left == 1'b1) begin
                    walk_left_internal = 1'b0;
                end else if (bump_right == 1'b1) begin
                    walk_left_internal = 1'b1;
                end
            end
            FALLING: begin
                falling_timer_enable = 1'b1;
                if (ground == 1'b1) begin
                    if (falling_timer > 6'd20) begin
                        next_state = IDLE; // Splatter
                    end else begin
                        next_state = WALKING;
                    end
                    falling_timer_enable = 1'b0;
                end
            end
            DIGGING: begin
                if (ground == 1'b0) begin
                    next_state = FALLING;
                    falling_timer_enable = 1'b1;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case (current_state)
            IDLE: begin
                walk_left = walk_left_internal;
                walk_right = ~walk_left_internal;
            end
            WALKING: begin
                walk_left = walk_left_internal;
                walk_right = ~walk_left_internal;
            end
            FALLING: begin
                aaah = 1'b1;
            end
            DIGGING: begin
                digging = 1'b1;
                walk_left = walk_left_internal;
                walk_right = ~walk_left_internal;
            end
        endcase
    end

endmodule