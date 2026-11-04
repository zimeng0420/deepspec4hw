module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);
    reg [2:0] y; // Present state

    // Next state logic
    reg [2:0] next_state;
    
    always @(*) begin
        case (y)
            3'b000: next_state = (x) ? 3'b001 : 3'b000; // State 000
            3'b001: next_state = (x) ? 3'b100 : 3'b001; // State 001
            3'b010: next_state = (x) ? 3'b001 : 3'b010; // State 010
            3'b011: next_state = (x) ? 3'b010 : 3'b001; // State 011
            3'b100: next_state = (x) ? 3'b100 : 3'b011; // State 100
            default: next_state = 3'b000;                // Default to state 000
        endcase
    end
    
    always @(posedge clk) begin
        if (reset) begin
            y <= 3'b000; // Reset state to 000
        end else begin
            y <= next_state; // Update state
        end
    end

    // Output logic
    always @(*) begin
        case (y)
            3'b011: z = 1; // Output z = 1 for state 011
            3'b100: z = 1; // Output z = 1 for state 100
            default: z = 0; // Output z = 0 for other states
        endcase
    end
endmodule