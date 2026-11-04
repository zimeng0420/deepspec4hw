module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);
    reg [2:0] y; // Current State
    reg [2:0] next_state; // Next State

    always @(*) begin
        case (y)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000;
        endcase
    end

    always @(*) begin
        case (y)
            3'b000, 3'b001, 3'b010: z = 1'b0;
            3'b011, 3'b100: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) 
            y <= 3'b000; // Reset to state 000
        else 
            y <= next_state; // Update current state to next state
    end
endmodule