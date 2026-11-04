module top_module (
    input clk,
    input in,
    input reset,
    output out
);

    // State encoding
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t state, next_state;
    
    // Sequential logic for state transition
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= A; // Reset to state A
        else
            state <= next_state;
    end

    // Combinational logic for next state
    always_comb begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A; // Default state
        endcase
    end

    // Combinational logic for output
    assign out = (state == D) ? 1'b1 : 1'b0;

endmodule