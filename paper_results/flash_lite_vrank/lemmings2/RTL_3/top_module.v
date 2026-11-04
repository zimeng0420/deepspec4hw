module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	output walk_left,
	output walk_right,
	output aaah
);

    // Define states
    parameter WALKING_LEFT = 2'b00;
    parameter WALKING_RIGHT = 2'b01;
    parameter FALLING_LEFT = 2'b10;
    parameter FALLING_RIGHT = 2'b11;

    // Internal state register
    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        next_state = state;
        case (state)
            WALKING_LEFT: begin
                aaah = 0;
                if (!ground) begin
                    next_state = FALLING_LEFT;
                end else if (bump_right) begin
                    next_state = WALKING_LEFT; // Keep current direction, will change on next clock cycle
                end
                else if (bump_left) begin
                    next_state = WALKING_RIGHT;
                end
            end
            WALKING_RIGHT: begin
                aaah = 0;
                if (!ground) begin
                    next_state = FALLING_RIGHT;
                end else if (bump_left) begin
                    next_state = WALKING_RIGHT;  // Keep current direction, will change on next clock cycle
                end
                else if (bump_right) begin
                    next_state = WALKING_LEFT;
                end
            end
            FALLING_LEFT: begin
                aaah = 1;
                if (ground) begin
                    next_state = WALKING_LEFT;
                end
            end
            FALLING_RIGHT: begin
                aaah = 1;
                if (ground) begin
                    next_state = WALKING_RIGHT;
                end
            end
            default: begin
                next_state = WALKING_LEFT;
                aaah = 0;
            end
        endcase
    end

    // State register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    always @(*) begin
        case (state)
            WALKING_LEFT: begin
                walk_left = 1;
                walk_right = 0;
            end
            WALKING_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
            end
            FALLING_LEFT: begin
                walk_left = 1;
                walk_right = 0;
            end
            FALLING_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
            end
            default: begin
                walk_left = 1;
                walk_right = 0;
            end
        endcase
    end

endmodule