module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State Definition
    localparam WALKING_LEFT = 2'b00;
    localparam WALKING_RIGHT = 2'b01;
    localparam FALLING = 2'b10;
    localparam DIGGING = 2'b11;

    reg [1:0] state, next_state;

    // State Transition Logic
    always @(*) begin
        next_state = state;
        aaah = 0;
        digging = 0;

        case (state)
            WALKING_LEFT, WALKING_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig && ground) begin
                    next_state = DIGGING;
                    digging = 1;
                end else if (bump_left && !bump_right) begin
                    next_state = WALKING_RIGHT;
                end else if (bump_right && !bump_left) begin
                    next_state = WALKING_LEFT;
                end else if (bump_left && bump_right) begin
                    if (state == WALKING_LEFT)
                        next_state = WALKING_RIGHT;
                    else
                        next_state = WALKING_LEFT;
                end
            end
            FALLING: begin
                aaah = 1;
                if (ground) begin
                    if (walk_left)
                        next_state = WALKING_LEFT;
                    else
                        next_state = WALKING_RIGHT;
                end
            end
            DIGGING: begin
                digging = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end
            end
            default: next_state = WALKING_LEFT;
        endcase
    end

    // State Register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALKING_LEFT;
        else
            state <= next_state;
    end

    // Output Logic
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        case (state)
            WALKING_LEFT: walk_left = 1;
            WALKING_RIGHT: walk_right = 1;
            default: ;
        endcase
    end

endmodule