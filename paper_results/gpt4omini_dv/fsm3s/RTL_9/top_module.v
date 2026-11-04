module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State encoding
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t current_state, next_state;

    // Next state logic
    always_comb begin
        case(current_state)
            A: next_state = (in == 0) ? A : B;
            B: next_state = (in == 0) ? C : B;
            C: next_state = (in == 0) ? A : D;
            D: next_state = (in == 0) ? C : B;
            default: next_state = A; // Default case for safety
        endcase
    end

    // State update and output logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
            out <= 0;
        end else begin
            current_state <= next_state;
            out <= (current_state == D) ? 1 : 0;
        end
    end

endmodule