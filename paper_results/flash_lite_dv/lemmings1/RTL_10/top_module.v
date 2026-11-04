module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // Define states using parameters for readability and maintainability
    parameter WALKING_LEFT  = 2'b00;
    parameter WALKING_RIGHT = 2'b01;
    
    // Define state register
    reg [1:0] current_state;
    reg [1:0] next_state;

    // State transition logic (synchronous)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALKING_LEFT; // Reset to WALKING_LEFT
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (current_state)
            WALKING_LEFT: begin
                if (bump_right) begin
                    next_state = WALKING_RIGHT;
                end else begin
                    next_state = WALKING_LEFT;
                end
            end
            WALKING_RIGHT: begin
                if (bump_left) begin
                    next_state = WALKING_LEFT;
                end else begin
                    next_state = WALKING_RIGHT;
                end
            end
            default: begin
                next_state = WALKING_LEFT;  // Default to WALKING_LEFT (or handle as error)
            end
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        case (current_state)
            WALKING_LEFT: begin
                walk_left  = 1'b1;
                walk_right = 1'b0;
            end
            WALKING_RIGHT: begin
                walk_left  = 1'b0;
                walk_right = 1'b1;
            end
            default: begin
                walk_left  = 1'b1; // Default to walk left
                walk_right = 1'b0;
            end
        endcase
    end
endmodule