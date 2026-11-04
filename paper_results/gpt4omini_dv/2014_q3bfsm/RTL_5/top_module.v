module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);
    reg [2:0] y; // current state
    reg [2:0] next_state; // next state

    // State transition logic
    always @(*) begin
        case (y)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001; 
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100; 
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001; 
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010; 
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100; 
            default: next_state = 3'b000; // default state
        endcase
    end

    // Output logic
    always @(*) begin
        case (y)
            3'b011: z = 1; // Output is 1 in state 011
            3'b100: z = 1; // Output is 1 in state 100
            default: z = 0; // Output is 0 in all other states
        endcase
    end

    // State update logic
    always @(posedge clk) begin
        if (reset) begin
            y <= 3'b000; // Reset state to 000
        end else begin
            y <= next_state; // Update to next state
        end
    end
endmodule