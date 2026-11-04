module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg fall,
    output reg splatter
);

    // State Definitions
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    parameter DIGGING = 2'b11;

    // Internal Signals
    reg [1:0] state;
    reg [5:0] fall_counter; // Counter to track falling duration

    // State Transition Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walk_left <= 1;
            walk_right <= 0;
            fall <= 0;
            splatter <= 0;
            fall_counter <= 0;
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (splatter) begin
                        walk_left <= 0;
                        walk_right <= 0;
                        fall <= 0;
                    end else if (!ground) begin
                        state <= FALLING;
                        fall <= 1;
                        walk_left <= 0;
                        walk_right <= 0;
                        fall_counter <= 0;
                    end else if (bump_right) begin
                        state <= WALK_RIGHT;
                        walk_left <= 0;
                        walk_right <= 1;
                    end else if (dig) begin
                        state <= DIGGING;
                        walk_left <= 0;
                        walk_right <= 0;
                    end else begin
                        walk_left <= 1;
                    end
                end
                WALK_RIGHT: begin
                    if (splatter) begin
                        walk_left <= 0;
                        walk_right <= 0;
                        fall <= 0;
                    end else if (!ground) begin
                        state <= FALLING;
                        fall <= 1;
                        walk_left <= 0;
                        walk_right <= 0;
                        fall_counter <= 0;
                    end else if (bump_left) begin
                        state <= WALK_LEFT;
                        walk_left <= 1;
                        walk_right <= 0;
                    end else if (dig) begin
                        state <= DIGGING;
                        walk_left <= 0;
                        walk_right <= 0;
                    end else begin
                        walk_right <= 1;
                    end
                end
                FALLING: begin
                    walk_left <= 0;
                    walk_right <= 0;
                    fall <= 1;
                    if (!ground) begin
                        fall_counter <= fall_counter + 1;
                    end
                    if (ground) begin
                        fall <= 0;
                        if (fall_counter > 20) begin
                            splatter <= 1;
                        end else if (state == FALLING) {
                            // Keep walking in the original direction.
                            if (walk_left) {
                                state <= WALK_LEFT;
                                walk_left <= 1;
                            } else {
                                state <= WALK_RIGHT;
                                walk_right <= 1;
                            }
                        }

                        fall_counter <= 0;
                    end
                end
                DIGGING: begin
                    if (splatter) begin
                        walk_left <= 0;
                        walk_right <= 0;
                        fall <= 0;
                    end else if (!ground) begin
                        state <= FALLING;
                        fall <= 1;
                        walk_left <= 0;
                        walk_right <= 0;
                        fall_counter <= 0;
                    end else {
                        // Digging continues, stay in DIGGING state
                         walk_left <= 0;
                         walk_right <= 0;

                    }
                end
            endcase
        end
    end
endmodule