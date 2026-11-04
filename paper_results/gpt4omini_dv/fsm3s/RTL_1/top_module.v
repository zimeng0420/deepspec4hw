module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State Encoding
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t current_state, next_state;

    // Combinational Logic for Next State
    always @(*) begin
        case (current_state)
            A: next_state = (in) ? B : A;
            B: next_state = (in) ? B : C;
            C: next_state = (in) ? D : A;
            D: next_state = (in) ? B : C;
            default: next_state = A; // Default case to handle invalid states
        endcase
    end

    // Output Logic
    always @(*) begin
        case (current_state)
            A, B, C: out = 0;
            D: out = 1;
            default: out = 0; // Default case to handle invalid states
        endcase
    end

    // Synchronous Reset and State Transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

endmodule