module top_module (
    input clk,
    input in,
    input reset,
    output out
);

    // State encoding
    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] current_state, next_state;
    
    // Output logic
    assign out = (current_state == D) ? 1'b1 : 1'b0;

    // Next state logic
    always @(*) begin
        case (current_state)
            A: next_state = (in) ? B : A;
            B: next_state = (in) ? B : C;
            C: next_state = (in) ? D : A;
            D: next_state = (in) ? B : C;
            default: next_state = A; // Default case for safety
        endcase
    end

    // State update and reset logic
    always @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= A;
        else 
            current_state <= next_state;
    end

endmodule