module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // Define states using a parameter
    parameter WALK_LEFT  = 2'b01;
    parameter WALK_RIGHT = 2'b10;

    // Define the state register
    reg [1:0] current_state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            default:
                next_state = WALK_LEFT;
        endcase
    end

    // State register update (synchronous)
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= WALK_LEFT;
        else
            current_state <= next_state;
    end

    // Output logic (combinational - Moore machine)
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                walk_left  = 1;
                walk_right = 0;
            end
            WALK_RIGHT: begin
                walk_left  = 0;
                walk_right = 1;
            end
            default: begin
                walk_left  = 1;
                walk_right = 0;
            end
        endcase
    end

endmodule