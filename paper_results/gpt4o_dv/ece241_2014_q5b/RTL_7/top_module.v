module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding using one-hot
    localparam STATE_A = 2'b01;
    localparam STATE_B = 2'b10;

    reg [1:0] state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            STATE_A: begin
                if (x)
                    next_state = STATE_B; // x = 1
                else
                    next_state = STATE_A; // x = 0
            end
            STATE_B: begin
                next_state = STATE_B; // Remain in state B for x = 0 or 1
            end
            default: next_state = STATE_A; // Default case to handle if needed
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        case (state)
            STATE_A: z = x;     // x -> z: 0 -> 0, 1 -> 1
            STATE_B: z = ~x;    // x -> z: 0 -> 1, 1 -> 0
            default: z = 0;
        endcase
    end

    // State update logic (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_A;  // Reset to state A
        else
            state <= next_state;
    end

endmodule