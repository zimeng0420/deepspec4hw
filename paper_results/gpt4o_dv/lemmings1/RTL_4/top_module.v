module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Define state encoding
    typedef enum logic [1:0] {
        STATE_LEFT = 2'b00,
        STATE_RIGHT = 2'b01
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_LEFT; // Asynchronous reset to walk left
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state
    always @(*) begin
        case (current_state)
            STATE_LEFT: begin
                if (bump_left || (bump_left && bump_right)) begin
                    next_state = STATE_RIGHT;
                end else begin
                    next_state = STATE_LEFT;
                end
            end
            STATE_RIGHT: begin
                if (bump_right || (bump_left && bump_right)) begin
                    next_state = STATE_LEFT;
                end else begin
                    next_state = STATE_RIGHT;
                end
            end
            default: next_state = STATE_LEFT;
        endcase
    end

    // Output logic based on current state
    assign walk_left = (current_state == STATE_LEFT);
    assign walk_right = (current_state == STATE_RIGHT);

endmodule