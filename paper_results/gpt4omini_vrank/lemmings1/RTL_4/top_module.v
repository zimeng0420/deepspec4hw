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
        LEFT = 2'b00,
        RIGHT = 2'b01
    } state_t;

    state_t current_state, next_state;

    // Asynchronous reset
    always @ (posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @ (*) begin
        case (current_state)
            LEFT: begin
                if (bump_right) next_state = RIGHT;
                else next_state = LEFT;  
            end
            RIGHT: begin
                if (bump_left) next_state = LEFT;
                else next_state = RIGHT;  
            end
            default: next_state = LEFT;  // Default state
        endcase
    end

    // Output logic
    always @ (*) begin
        walk_left = (current_state == LEFT);
        walk_right = (current_state == RIGHT);
    end

endmodule