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

    // State Definitions
    parameter IDLE = 2'b00;          // Not falling, not digging, walking
    parameter FALLING = 2'b01;       // Falling
    parameter DIGGING = 2'b10;       // Digging

    reg [1:0] state, next_state;

    // Default values for outputs
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        next_state = state; // Default: Stay in the current state

        case (state)
            IDLE: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig && ground) begin
                    next_state = DIGGING;
                    digging = 1;
                end else if (bump_left) begin
                    walk_right = 1;
                end else if (bump_right) begin
                    walk_left = 1;
                end else if (walk_left) begin
                    walk_left = 1;
                end else if (walk_right) begin
                    walk_right = 1;
                end
            end

            FALLING: begin
                aaah = 1; // Always aaah when falling
                if (ground) begin
                    next_state = IDLE;
                end
            end

            DIGGING: begin
                digging = 1; // Always digging while in DIGGING state
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (walk_left) begin
                    walk_left = 1;
                end else if (walk_right) begin
                    walk_right = 1;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // State Register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE; // Reset to walk left
            walk_left <= 1;
            walk_right <= 0;
        end else begin
            state <= next_state;
        end
    end

endmodule