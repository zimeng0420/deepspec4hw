module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // Define states
    parameter WALK_LEFT  = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALLING    = 2'b10;

    // State register
    reg [1:0] current_state, next_state;

    // Combinational logic for next state
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (bump_right)
                    next_state = WALK_LEFT; // stay left if bumped on the right, will change in next cycle
                else if (ground == 0)
                    next_state = FALLING;
                else
                    next_state = (bump_left) ? WALK_RIGHT : WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (bump_left)
                    next_state = WALK_RIGHT; // stay right if bumped on the left, will change in next cycle
                else if (ground == 0)
                    next_state = FALLING;
                else
                    next_state = (bump_right) ? WALK_LEFT : WALK_RIGHT;
            end
            FALLING: begin
                next_state = (ground) ? current_state : FALLING; // Stay falling until ground reappears
            end
            default:
                next_state = WALK_LEFT; // Default state
        endcase
    end

    // Sequential logic for state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= WALK_LEFT;
        else
            current_state <= next_state;
    end

    // Combinational logic for outputs (Moore machine)
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                walk_left  = 1;
                walk_right = 0;
                aaah       = 0;
            end
            WALK_RIGHT: begin
                walk_left  = 0;
                walk_right = 1;
                aaah       = 0;
            end
            FALLING: begin
                walk_left  = 0;
                walk_right = 0;
                aaah       = 1;
            end
            default: begin
                walk_left  = 1;
                walk_right = 0;
                aaah       = 0;
            end
        endcase
    end

endmodule