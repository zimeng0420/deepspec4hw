module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [2:0] {
        S_A = 3'b000,
        S_B = 3'b001,
        S_C = 3'b010,
        S_D = 3'b011,
        S_E = 3'b100,
        S_F = 3'b101
    } state_t;

    state_t current_state, next_state;

    // State flip-flops
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S_A;
        end else begin
            current_state <= next_state;
        end
    end

    // State transition table (Next-state logic)
    always @(*) begin
        case (current_state)
            S_A: next_state = (w) ? S_B : S_A;
            S_B: next_state = (w) ? S_C : S_D;
            S_C: next_state = (w) ? S_E : S_D;
            S_D: next_state = (w) ? S_F : S_A;
            S_E: next_state = (w) ? S_E : S_D;
            S_F: next_state = (w) ? S_C : S_D;
            default: next_state = S_A; // Default case to avoid latches.
        endcase
    end

    // Output logic
    always @(*) begin
        z = (current_state == S_E) || (current_state == S_F);
    end

endmodule