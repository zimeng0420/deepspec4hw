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
    localparam WALK_LEFT  = 3'b001;
    localparam WALK_RIGHT = 3'b010;
    localparam FALLING    = 3'b011;
    localparam DIGGING    = 3'b100;
    localparam SPLAT      = 3'b101;

    // Internal signals
    reg [2:0] current_state;
    reg [2:0] next_state;
    reg [4:0] fall_counter;
    reg       previous_direction; // 1 for right, 0 for left
    localparam LEFT = 1'b0;
    localparam RIGHT = 1'b1;

    // Output signals
    assign walk_left  = (current_state == WALK_LEFT)  && (current_state != SPLAT);
    assign walk_right = (current_state == WALK_RIGHT) && (current_state != SPLAT);
    assign aaah       = (current_state == FALLING)    && (current_state != SPLAT);
    assign digging    = (current_state == DIGGING)    && (current_state != SPLAT);

    // Next state logic
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_right || bump_left) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground && (fall_counter >= 20)) begin
                    next_state = SPLAT;
                end else if (ground) begin
                    next_state = (previous_direction == LEFT) ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING;
                end
            end
            SPLAT: begin
                next_state = SPLAT;
            end
            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            fall_counter <= 0;
            previous_direction <= LEFT;
        end else begin
            current_state <= next_state;
            if (!ground && (current_state == WALK_LEFT || current_state == WALK_RIGHT || current_state == DIGGING)) begin
                fall_counter <= fall_counter + 1;
                previous_direction <= (current_state == WALK_LEFT) ? LEFT : RIGHT;
            end else if (ground) begin
                fall_counter <= 0;
            end
        end
    end

endmodule