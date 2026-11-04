module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum logic {
        STATE_BEFORE_FIRST_ONE,  // Before the first '1' has been detected
        STATE_AFTER_FIRST_ONE    // After the first '1' has been detected
    } state_t;

    state_t current_state, next_state;

    // Combinational logic to determine the next state
    always @(*) begin
        case (current_state)
            STATE_BEFORE_FIRST_ONE: begin
                if (x == 1'b1)
                    next_state = STATE_AFTER_FIRST_ONE;
                else
                    next_state = STATE_BEFORE_FIRST_ONE;
            end
            STATE_AFTER_FIRST_ONE: begin
                next_state = STATE_AFTER_FIRST_ONE; // Remain in this state
            end
            default: next_state = STATE_BEFORE_FIRST_ONE; // Default state
        endcase
    end

    // Sequential logic for state transition and output logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_BEFORE_FIRST_ONE;
            z <= 1'b0;
        end else begin
            current_state <= next_state;
            case (current_state)
                STATE_BEFORE_FIRST_ONE: z <= x;     // Output as is before first '1'
                STATE_AFTER_FIRST_ONE: z <= ~x;     // Complement the output after first '1'
            endcase
        end
    end

endmodule