module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	output walk_left,
	output walk_right
);

    // Define the states using local parameters
    localparam LEFT = 1'b0,
               RIGHT = 1'b1;
               
    // Register for current state
    reg current_state, next_state;

    // State transition on positive edge of clock or asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= LEFT; // Asynchronous reset to walk left
        else
            current_state <= next_state;
    end

    // Next state logic based on current state and inputs
    always @(*) begin
        case (current_state)
            LEFT: begin
                if (bump_left)
                    next_state = RIGHT;
                else
                    next_state = LEFT;
            end
            RIGHT: begin
                if (bump_right)
                    next_state = LEFT;
                else
                    next_state = RIGHT;
            end
            default: next_state = LEFT; // default case for safety
        endcase
    end

    // Output logic based on current state
    assign walk_left = (current_state == LEFT);
    assign walk_right = (current_state == RIGHT);

endmodule