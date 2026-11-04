module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding using one-hot
    localparam S_A = 2'b01;
    localparam S_B = 2'b10;

    // State register declaration
    reg [1:0] state, next_state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S_A;  // Reset to state A
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S_A: begin
                if (x) 
                    next_state = S_B;
                else 
                    next_state = S_A;
            end
            S_B: begin
                next_state = S_B;  // Always stay in B if reached
            end
            default: begin
                next_state = S_A; // Default to state A on invalid state
            end
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            S_A: z = x ? 1 : 0;
            S_B: z = x ? 0 : 1;
            default: z = 0;  // Default output if in invalid state
        endcase
    end

endmodule