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

    // State Definitions
    parameter IDLE       = 3'b000;
    parameter WALK_LEFT  = 3'b001;
    parameter WALK_RIGHT = 3'b010;
    parameter FALLING    = 3'b011;
    parameter DIGGING    = 3'b100;

    // Internal Signals
    reg [2:0] current_state, next_state;
    reg digging_internal;
    reg aaah_internal;
    reg walk_left_internal;
    reg walk_right_internal;

    // State Transition Logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= WALK_LEFT;
        else
            current_state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        next_state = current_state;
        digging_internal = 0;
        aaah_internal = 0;
        walk_left_internal = 0;
        walk_right_internal = 0;

        case (current_state)
            IDLE: begin
                next_state = WALK_LEFT; // Initial state
            end
            WALK_LEFT: begin
                walk_left_internal = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah_internal = 1;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (dig && ground) begin
                    next_state = DIGGING;
                    digging_internal = 1;
                end
            end
            WALK_RIGHT: begin
                walk_right_internal = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah_internal = 1;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else if (dig && ground) begin
                    next_state = DIGGING;
                    digging_internal = 1;
                end
            end
            FALLING: begin
                aaah_internal = 1;
                if (ground) begin
                    if (walk_left_internal)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end
            end
            DIGGING: begin
                digging_internal = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah_internal = 1;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Output Assignments
    assign walk_left = walk_left_internal;
    assign walk_right = walk_right_internal;
    assign aaah = aaah_internal;
    assign digging = digging_internal;

endmodule