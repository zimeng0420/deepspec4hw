module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State encoding
    typedef enum reg [1:0] {
        LEFT = 2'b00,
        RIGHT = 2'b01
    } state_t;

    // State variable
    state_t current_state, next_state;

    // Sequential logic for state transition
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= LEFT;
        else
            current_state <= next_state;
    end

    // Combinatorial logic for next state
    always @(*) begin
        case (current_state)
            LEFT: begin
                if (bump_right)
                    next_state = RIGHT;
                else
                    next_state = LEFT;
            end
            RIGHT: begin
                if (bump_left)
                    next_state = LEFT;
                else
                    next_state = RIGHT;
            end
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            LEFT: begin
                walk_left = 1;
                walk_right = 0;
            end
            RIGHT: begin
                walk_left = 0;
                walk_right = 1;
            end
            default: begin
                walk_left = 0;
                walk_right = 0;
            end
        endcase
    end

endmodule