module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // State encoding
    reg [1:0] current_state, next_state;
    
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // State transition on positive edge of clk or areset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;  // Reset to state A
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: next_state = (in == 0) ? A : B;
            B: next_state = (in == 0) ? C : B;
            C: next_state = (in == 0) ? A : D;
            D: next_state = (in == 0) ? C : B;
            default: next_state = A;  // Default to state A
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            D: out = 1;
            default: out = 0;
        endcase
    end

endmodule