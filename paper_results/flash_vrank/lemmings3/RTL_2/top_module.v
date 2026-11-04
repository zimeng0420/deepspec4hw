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
    localparam WALK_LEFT = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING = 2'b10;
    localparam DIGGING = 2'b11;

    reg [1:0] current_state;
    reg [1:0] next_state;

    reg walking_direction; // 0 for left, 1 for right
    reg aaah_r;
    reg digging_r;

    // State Transition Logic
    always @(*) begin
        next_state = current_state;
        walking_direction = (current_state == WALK_LEFT) ? 0 : ((current_state == WALK_RIGHT) ? 1 : walking_direction); // Retain direction during falling and digging
        aaah_r = 0;
        digging_r = 0;

        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah_r = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging_r = 1;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_RIGHT;
                    walking_direction = 1;
                end else begin
                  walking_direction = 0;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah_r = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging_r = 1;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                    walking_direction = 0;
                end else begin
                  walking_direction = 1;
                end
            end
            FALLING: begin
                if (ground) begin
                  if (walking_direction == 0)
                    next_state = WALK_LEFT;
                  else
                    next_state = WALK_RIGHT;
                end else begin
                    aaah_r = 1;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah_r = 1;
                    digging_r = 0;
                end else begin
                    digging_r = 1;
                end
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // State Update Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            walking_direction <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Output Logic
    assign walk_left = (current_state == WALK_LEFT);
    assign walk_right = (current_state == WALK_RIGHT);
    assign aaah = aaah_r;
    assign digging = digging_r;

endmodule