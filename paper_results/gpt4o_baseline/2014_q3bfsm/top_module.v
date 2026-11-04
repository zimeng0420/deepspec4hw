module top_module (
    input clk,
    input reset,
    input x,
    output reg z
);
    // Define states
    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000; // Default state
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            3'b011: z = 1'b1;
            3'b100: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

    // Synchronous state update
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000; // Reset state
        end else begin
            state <= next_state;
        end
    end
endmodule