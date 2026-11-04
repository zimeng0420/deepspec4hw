module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State encoding
    typedef enum logic [1:0] {
        STATE_LEFT = 2'b00,
        STATE_RIGHT = 2'b01
    } state_t;

    state_t current_state, next_state;

    // State register
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            STATE_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                if (bump_right) begin
                    next_state = STATE_RIGHT;
                end else begin
                    next_state = STATE_LEFT;
                end
            end
            STATE_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                if (bump_left) begin
                    next_state = STATE_LEFT;
                end else begin
                    next_state = STATE_RIGHT;
                end
            end
            default: begin
                walk_left = 0;
                walk_right = 0;
                next_state = STATE_LEFT; // default state
            end
        endcase
    end

endmodule