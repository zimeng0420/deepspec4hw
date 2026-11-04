module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    typedef enum logic [2:0] {
        STATE_A = 3'b000,
        STATE_B = 3'b001,
        STATE_C = 3'b010,
        STATE_D = 3'b011,
        STATE_E = 3'b100,
        STATE_F = 3'b101
    } state_t;

    state_t current_state, next_state;

    // State flip-flops (sequential logic)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_A;  // Reset to state A
        end else begin
            current_state <= next_state;  // Transition to next state
        end
    end

    // Next-state logic (combinational logic)
    always @(*) begin
        case (current_state)
            STATE_A: next_state = (w) ? STATE_B : STATE_A;
            STATE_B: next_state = (w) ? STATE_C : STATE_D;
            STATE_C: next_state = (w) ? STATE_E : STATE_D;
            STATE_D: next_state = (w) ? STATE_F : STATE_A;
            STATE_E: next_state = (w) ? STATE_E : STATE_D;
            STATE_F: next_state = (w) ? STATE_C : STATE_D;
            default: next_state = STATE_A;  // Default to state A
        endcase
    end

    // Output logic
    always @(*) begin
        z = (current_state == STATE_E) || (current_state == STATE_F);
    end

endmodule