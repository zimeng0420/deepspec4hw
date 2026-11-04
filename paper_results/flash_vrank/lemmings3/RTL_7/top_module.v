module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Define states
    localparam WALK_LEFT = 3'b001;
    localparam WALK_RIGHT = 3'b010;
    localparam FALLING = 3'b011;
    localparam DIGGING = 3'b100;

    // State register
    reg [2:0] current_state;
    reg [2:0] next_state;

    // Output registers
    reg r_walk_left;
    reg r_walk_right;
    reg r_aaah;
    reg r_digging;

    // State transition logic
    always @(*) begin
        next_state = current_state; // Default: stay in the same state

        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (r_walk_left) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end
            end
            DIGGING: begin
                if (!ground) begin
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
        r_walk_left = 0;
        r_walk_right = 0;
        r_aaah = 0;
        r_digging = 0;

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
            DIGGING: begin
                r_digging = 1;
            end
            default: r_walk_left = 1;
        endcase
    end

    // Assign outputs
    assign walk_left = r_walk_left;
    assign walk_right = r_walk_right;
    assign aaah = r_aaah;
    assign digging = r_digging;

endmodule