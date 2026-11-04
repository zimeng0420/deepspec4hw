module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State Encoding
    typedef enum logic [1:0] {
        S_LEFT = 2'b00,
        S_RIGHT = 2'b01
    } state_t;

    state_t current_state, next_state;

    // Output logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            S_LEFT: begin
                if (bump_right) begin
                    next_state = S_LEFT; // Remain in left state until right bump
                } else if (bump_left) begin
                    next_state = S_RIGHT; // Switch to right if bumped left
                } else begin
                    next_state = S_LEFT; // Remain in left state
                end
                walk_left = 1;
                walk_right = 0;
            end
            S_RIGHT: begin
                if (bump_left) begin
                    next_state = S_RIGHT; // Remain in right state until left bump
                } else if (bump_right) begin
                    next_state = S_LEFT; // Switch to left if bumped right
                } else begin
                    next_state = S_RIGHT; // Remain in right state
                end
                walk_left = 0;
                walk_right = 1;
            end
            default: begin
                next_state = S_LEFT;
                walk_left = 1;
                walk_right = 0;
            end
        endcase
    end
endmodule