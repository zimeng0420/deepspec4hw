module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Define states
    parameter WALKING_LEFT  = 2'b00;
    parameter WALKING_RIGHT = 2'b01;

    // Internal state register
    reg [1:0] current_state;

    // Next state logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALKING_LEFT;
        end else begin
            case (current_state)
                WALKING_LEFT:  begin
                    if (bump_right)
                        current_state <= WALKING_RIGHT;
                    else
                        current_state <= WALKING_LEFT;
                end
                WALKING_RIGHT: begin
                    if (bump_left)
                        current_state <= WALKING_LEFT;
                    else
                        current_state <= WALKING_RIGHT;
                end
                default: current_state <= WALKING_LEFT; // Default to WALKING_LEFT
            endcase
        end
    end

    // Output logic (Moore machine)
    always @(*) begin
        case (current_state)
            WALKING_LEFT:  begin
                walk_left  = 1'b1;
                walk_right = 1'b0;
            end
            WALKING_RIGHT: begin
                walk_left  = 1'b0;
                walk_right = 1'b1;
            end
            default: begin
                walk_left  = 1'b1;  // Default to WALKING_LEFT
                walk_right = 1'b0;
            end
        endcase
    end
endmodule