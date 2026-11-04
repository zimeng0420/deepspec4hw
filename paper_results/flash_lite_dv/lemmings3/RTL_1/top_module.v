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
    parameter IDLE = 2'b00;  // Initial state, waiting
    parameter WALKING_LEFT = 2'b01;
    parameter WALKING_RIGHT = 2'b10;
    parameter FALLING = 2'b11;

    // Define state register
    reg [1:0] current_state, next_state;

    // Default values
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALKING_LEFT; // Reset to walking left
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state and outputs
    always @(*) begin
        // Default next state and outputs
        next_state = current_state;
        aaah = 0;
        digging = 0;
        walk_left = (current_state == WALKING_LEFT || (current_state == FALLING && walk_left == 1)) ;
        walk_right = (current_state == WALKING_RIGHT || (current_state == FALLING && walk_right == 1));

        case (current_state)
            IDLE: begin
                if (ground == 1 && dig == 1) begin
                    digging = 1;
                end else if (bump_right) begin
                    next_state = WALKING_LEFT;
                end else if (bump_left) begin
                    next_state = WALKING_RIGHT;
                end
            end
            WALKING_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig == 1) begin
                    digging = 1;
                end else if (bump_right) begin
                    next_state = WALKING_LEFT;
                end else if (bump_left) begin
                    next_state = WALKING_RIGHT;
                end
            end

            WALKING_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig == 1) begin
                    digging = 1;
                end else if (bump_right) begin
                    next_state = WALKING_LEFT;
                end else if (bump_left) begin
                    next_state = WALKING_RIGHT;
                end
            end

            FALLING: begin
                aaah = 1;
                if (ground) begin
                    if(walk_left)
                        next_state = WALKING_LEFT;
                    else
                        next_state = WALKING_RIGHT;
                end
            end

            default: begin
                next_state = IDLE;
                walk_left = 1;
                walk_right = 0;
            end
        endcase

        if (digging == 1 && !ground)
            digging = 0;
    end

endmodule