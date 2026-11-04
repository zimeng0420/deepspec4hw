module top_module (
	input clk,
	input areset,
	input x,
	output z
);

    // State Definitions (One-Hot Encoding)
    localparam STATE_A = 2'b01;
    localparam STATE_B = 2'b10;

    // Internal Signals
    reg [1:0] state;
    wire [1:0] next_state;

    // Output Logic
    always @(*) begin
        case (state)
            STATE_A: z = (x == 1'b1) ? 1'b1 : 1'b0; // z = x in state A
            STATE_B: z = (x == 1'b1) ? 1'b0 : 1'b1; // z = !x in state B
            default: z = 1'b0; // Should never happen, but good practice
        endcase
    end

    // Next State Logic
    always @(*) begin
        case (state)
            STATE_A: next_state = (x == 1'b1) ? STATE_B : STATE_A;
            STATE_B: next_state = STATE_B; // Stays in B regardless of x
            default: next_state = STATE_A; // Default to A (shouldn't happen)
        endcase
    end

    // State Register (Synchronous with Clock, Asynchronous Reset)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_A; // Reset to state A
        end else begin
            state <= next_state;
        end
    end

endmodule