module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // State encoding
    typedef enum reg [1:0] {A = 1'b0, B = 1'b1} state_type;
    state_type state, next_state;
    
    // State transition logic
    always @(*) begin
        case (state)
            B: next_state = (in == 0) ? A : B;
            A: next_state = (in == 0) ? B : A;
            default: next_state = B; // Default state to avoid latches
        endcase
    end

    // Sequential logic for state updating
    always @(posedge clk or posedge areset) begin
        if (areset) 
            state <= B; // Asynchronous reset to state B
        else 
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        case (state)
            B: out = 1;
            A: out = 0;
            default: out = 0;
        endcase
    end

endmodule