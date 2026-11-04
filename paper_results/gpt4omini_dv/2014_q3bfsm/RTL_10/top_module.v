module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] y; // Current state
    reg [2:0] next_state; // Next state

    // Combinational Logic for Next State and Output
    always @(*) begin
        case (y)
            3'b000: next_state = (x == 1) ? 3'b001 : 3'b000;
            3'b001: next_state = (x == 1) ? 3'b100 : 3'b001;
            3'b010: next_state = (x == 1) ? 3'b001 : 3'b010;
            3'b011: next_state = (x == 1) ? 3'b010 : 3'b001;
            3'b100: next_state = (x == 1) ? 3'b100 : 3'b011;
            default: next_state = 3'b000; // Default state
        endcase
        
        // Output z logic
        case (y)
            3'b011: z = 1; // Output z=1 in state 011
            3'b100: z = 1; // Output z=1 in state 100
            default: z = 0; // z=0 in all other states
        endcase
    end

    // Sequential Logic: State Update
    always @(posedge clk) begin
        if (reset)
            y <= 3'b000; // Reset to state 000
        else
            y <= next_state; // Transition to next state
    end

endmodule