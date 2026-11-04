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
    parameter WALKING_LEFT = 2'b01;
    parameter WALKING_RIGHT = 2'b10;
    parameter FALLING = 2'b11;
    parameter DIGGING = 2'b10;

    // Define state variable
    reg [1:0] current_state, next_state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALKING_LEFT; // Reset to walking left
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state and outputs
    always @(*) begin
        // Default values
        next_state = current_state;
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (current_state)
            IDLE: begin
                walk_left = 1;
                if (!ground) begin
                   next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end else if (bump_right) begin
                    next_state = WALKING_LEFT;
                end else if (bump_left) begin
                    next_state = WALKING_RIGHT;
                end
            end

            WALKING_LEFT: begin
                walk_left = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end else if (bump_right) begin
                    next_state = WALKING_RIGHT;
                end
            end

            WALKING_RIGHT: begin
                walk_right = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end else if (bump_left) begin
                    next_state = WALKING_LEFT;
                end
            end
            
            FALLING: begin
                aaah = 1;
                if (ground) begin
                    if(walk_left)
                        next_state = WALKING_LEFT;
                    else if (walk_right)
                        next_state = WALKING_RIGHT;
                    else
                        next_state = WALKING_LEFT;
                 end
            end
            
            DIGGING: begin
                digging = 1;
                if (!ground)
                begin
                  next_state = FALLING;
                  aaah = 1;
                end
                else if (bump_left)
                begin
                  next_state = WALKING_RIGHT;
                end
                else if (bump_right)
                begin
                  next_state = WALKING_LEFT;
                end
            end
            
            default: begin
               walk_left = 1; // Default to walking left
                next_state = WALKING_LEFT;
            end
        endcase
    end
endmodule