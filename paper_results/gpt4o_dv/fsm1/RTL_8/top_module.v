module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);
    // State encoding
    typedef enum reg [0:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;
    
    // State registers
    state_t current_state, next_state;
    
    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            B: next_state = (in == 0) ? A : B;
            A: next_state = (in == 0) ? B : A;
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        case (current_state)
            B: out = 1;
            A: out = 0;
        endcase
    end
    
    // State update (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= B;
        else
            current_state <= next_state;
    end

endmodule