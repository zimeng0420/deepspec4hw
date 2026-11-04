module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // Define states
    parameter WALKING_LEFT = 2'b00;
    parameter WALKING_RIGHT = 2'b01;

    // Define state register (using 2 bits to represent 2 states)
    reg [1:0] state;

    // State transition logic (Next state logic)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING_LEFT; // Reset to walking left
        end else begin
            case (state)
                WALKING_LEFT: begin
                    if (bump_right) begin
                        state <= WALKING_RIGHT;
                    end
                end
                WALKING_RIGHT: begin
                    if (bump_left) begin
                        state <= WALKING_LEFT;
                    end
                end
            endcase
        end
    end

    // Output logic (Moore machine)
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
            default: begin
                walk_left = 1; //default to walking left
                walk_right = 0;
            end
        endcase
    end

endmodule