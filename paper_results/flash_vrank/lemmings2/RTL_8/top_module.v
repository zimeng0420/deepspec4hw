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
    localparam WALK_LEFT = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING = 2'b10;

    // State register
    reg [1:0] current_state, next_state;

    // Output registers
    reg r_walk_left, r_walk_right, r_aaah;

    // State transition logic
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) {
                    next_state = WALK_RIGHT;
                } else {
                    next_state = WALK_LEFT;
                }
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                } else {
                    next_state = WALK_RIGHT;
                }
            end
            FALLING: begin
                if (ground) begin
                    if (r_walk_left) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                } else begin
                    next_state = FALLING;
                end
            end
            default: next_state = WALK_LEFT;  // Default to WALK_LEFT if state is invalid
        endcase
    end

    // State update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            r_walk_left <= 1'b1;
            r_walk_right <= 1'b0;
        end else begin
            current_state <= next_state;
            r_walk_left <= (current_state == WALK_LEFT) || (next_state == WALK_LEFT);
            r_walk_right <= (current_state == WALK_RIGHT) || (next_state == WALK_RIGHT);
        end
    end

    // Output logic
    always @(*) begin
        r_aaah = (current_state == FALLING);
    end

    assign walk_left = r_walk_left;
    assign walk_right = r_walk_right;
    assign aaah = r_aaah;

endmodule