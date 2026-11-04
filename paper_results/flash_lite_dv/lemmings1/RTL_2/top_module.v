module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // Define states using parameters for readability
    parameter WALKING_LEFT  = 2'b00;
    parameter WALKING_RIGHT = 2'b01;

    // State register
    reg [1:0] state;

    // Next state logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALKING_LEFT;
        else begin
            case (state)
                WALKING_LEFT:  begin
                    if (bump_right)
                        state <= WALKING_RIGHT;
                    else
                        state <= WALKING_LEFT;  // Stay in WALKING_LEFT
                end
                WALKING_RIGHT: begin
                    if (bump_left)
                        state <= WALKING_LEFT;
                    else
                        state <= WALKING_RIGHT; // Stay in WALKING_RIGHT
                end
                default:
                    state <= WALKING_LEFT; // Default to WALKING_LEFT (safety)
            endcase
        end
    end

    // Output logic (Moore machine)
    always @(*) begin
        case (state)
            WALKING_LEFT:  begin
                walk_left  = 1'b1;
                walk_right = 1'b0;
            end
            WALKING_RIGHT: begin
                walk_left  = 1'b0;
                walk_right = 1'b1;
            end
            default: begin
                walk_left  = 1'b1; // Default to WALKING_LEFT (safety)
                walk_right = 1'b0;
            end
        endcase
    end

endmodule