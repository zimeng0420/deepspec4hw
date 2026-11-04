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
    
    state_t state, next_state;

    // State transition logic
    always_comb begin
        case (state)
            A: next_state = (in) ? B : A;
            B: next_state = (in) ? B : C;
            C: next_state = (in) ? D : A;
            D: next_state = (in) ? B : C;
            default: next_state = A; // This will prevent unintended latches
        endcase
    end

    // Output logic (Moore)
    always_comb begin
        case (state)
            D: out = 1;
            default: out = 0;
        endcase
    end

    // Synchronous state update with synchronous reset
    always_ff @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule