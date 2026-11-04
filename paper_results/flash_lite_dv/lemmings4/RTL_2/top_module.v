module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg fall,
    output reg dig_out,
    output reg aaah
);

    parameter IDLE = 0, WALK_LEFT = 1, WALK_RIGHT = 2, FALLING = 3, DIGGING = 4, SPLATTER = 5;
    reg [2:0] state, next_state;
    reg [5:0] fall_counter;
    reg prev_ground;
    reg [2:0] prev_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE; // Start in an idle state to ensure walk_left is initially 0
            fall_counter <= 6'd0;
            prev_ground <= 1'b1; // Initialize to 1 to handle the initial case where ground is 0
            prev_state <= IDLE;
        end else begin
            state <= next_state;
            prev_ground <= ground;
            prev_state <= state;
        end
    end

    always @(*) begin
        // Default outputs
        walk_left = 0;
        walk_right = 0;
        fall = 0;
        dig_out = 0;
        aaah = 0;
        next_state = state;


        case (state)
            IDLE: begin
                if (ground) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = FALLING;
                end
            end

            WALK_LEFT: begin
                walk_left = 1;
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                end
            end

            WALK_RIGHT: begin
                walk_right = 1;
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                end
            end

            FALLING: begin
                fall = 1;
                aaah = 1;
                fall_counter = fall_counter + 1;

                if(ground && fall_counter > 20) begin
                    next_state = SPLATTER;
                end else if (ground) begin
                    if (prev_state == WALK_LEFT) begin
                         next_state = WALK_LEFT;
                    end
                     else if (prev_state == WALK_RIGHT) begin
                         next_state = WALK_RIGHT;
                     end
                    else begin
                        next_state = IDLE; // Should not happen but handle just in case
                    end
                    fall_counter = 0; // Reset counter on ground
                end
            end

            DIGGING: begin
                dig_out = 1;
                if (!ground) begin
                    next_state = FALLING;
                end
            end

            SPLATTER: begin
                // All outputs are already zero as default.
            end

            default: next_state = IDLE;
        endcase
    end
end