module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);
    // State encoding
    typedef enum logic [1:0] {
        A = 1'b0, // State A
        B = 1'b1  // State B
    } state_t;
    
    state_t current_state, next_state;

    // State transition logic
    always_comb begin
        case (current_state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
        endcase
    end

    // Output logic
    always_comb begin
        case (current_state)
            B: out = 1'b1;
            A: out = 1'b0;
        endcase
    end

    // State register with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= B;
        else
            current_state <= next_state;
    end
endmodule