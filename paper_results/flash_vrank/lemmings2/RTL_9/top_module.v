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

    // Define the states
    localparam WALK_LEFT = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING = 2'b10;

    // State register
    reg [1:0] current_state, next_state;

    // Output registers
    reg walk_left_r, walk_right_r, aaah_r;

    // State transition logic
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                   if(walk_left_r)
                      next_state = WALK_LEFT;
                   else
                      next_state = WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // State update logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic
    always @(*) begin
        walk_left_r = 0;
        walk_right_r = 0;
        aaah_r = 0;

        case (current_state)
            WALK_LEFT: begin
                walk_left_r = 1;
            end
            WALK_RIGHT: begin
                walk_right_r = 1;
            end
            FALLING: begin
                aaah_r = 1;
            end
            default: walk_left_r = 1;
        endcase
    end

    // Assign outputs
    assign walk_left = walk_left_r;
    assign walk_right = walk_right_r;
    assign aaah = aaah_r;

endmodule