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
    reg [1:0] current_state;
    reg [1:0] next_state;

    // Walking direction register (store direction before falling)
    reg walk_direction; // 0 for left, 1 for right

    // Output registers
    reg r_walk_left;
    reg r_walk_right;
    reg r_aaah;

    // State update logic (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            walk_direction <= 0;
        end else begin
            current_state <= next_state;
            if (current_state != FALLING) begin
                walk_direction <= (current_state == WALK_RIGHT);
            end
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = current_state; // Default: stay in the same state
        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (walk_direction == 0) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end
            end
            default: next_state = WALK_LEFT; // Should never happen, but handle it anyway
        endcase
    end

    // Output logic (Moore machine)
    always @(*) begin
        r_walk_left = 0;
        r_walk_right = 0;
        r_aaah = 0;
        case (current_state)
            WALK_LEFT: begin
                r_walk_left = 1;
            end
            WALK_RIGHT: begin
                r_walk_right = 1;
            end
            FALLING: begin
                r_aaah = 1;
            end
            default: begin
                r_walk_left = 1;
            end
        endcase
    end

    assign walk_left = r_walk_left;
    assign walk_right = r_walk_right;
    assign aaah = r_aaah;

endmodule