module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // Define states using parameters
    parameter WALKING_LEFT = 0;
    parameter WALKING_RIGHT = 1;

    // State register
    reg state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING_LEFT;
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
            default: begin // should never happen, but good practice
                walk_left = 1;
                walk_right = 0;
            end
        endcase
    end
endmodule