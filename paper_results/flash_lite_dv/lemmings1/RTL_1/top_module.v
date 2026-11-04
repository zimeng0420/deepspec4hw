module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // Define states
    parameter WALKING_LEFT = 0;
    parameter WALKING_RIGHT = 1;

    // Define a state register
    reg [0:0] state;

    // Combinational logic for next state
    always @(*) begin
        case (state)
            WALKING_LEFT: begin
                if (bump_right)
                    state = WALKING_RIGHT;
            end
            WALKING_RIGHT: begin
                if (bump_left)
                    state = WALKING_LEFT;
            end
        endcase
    end

    // Sequential logic for state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALKING_LEFT;
        else
            state <= state; // Keep the current state
    end


    // Combinational logic for output
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
            default: begin //Should never happen, but good practice
                walk_left = 1;
                walk_right = 0;
            end
        endcase
    end

endmodule