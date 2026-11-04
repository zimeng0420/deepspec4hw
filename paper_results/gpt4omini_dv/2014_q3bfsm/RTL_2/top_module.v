module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] y; // Current state
    reg [2:0] next_state; // Next state

    // State transition logic
    always @(*) begin
        case (y)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000; // Default case to handle undefined states
        endcase
    end

    // Output logic
    always @(*) begin
        case (y)
            3'b011: z = (x == 1'b0) ? 1'b1 : 1'b1;
            3'b100: z = (x == 1'b0) ? 1'b1 : 1'b1;
            default: z = 1'b0;
        endcase
    end

    // State update and reset logic
    always @(posedge clk) begin
        if (reset) begin
            y <= 3'b000; // Reset to state 000
        end else begin
            y <= next_state; // Update current state
        end
    end

endmodule