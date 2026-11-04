module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    parameter A = 2'b01, B = 2'b10;
    reg [1:0] state, next_state;

    // Asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A; // Reset to State A
        else
            state <= next_state; // Transition to next state
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                if (x)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (x)
                    next_state = B;
                else
                    next_state = B;
            end
            default: next_state = A; // Default case
        endcase
    end

    // Output logic (Mealy machine)
    always @(*) begin
        case (state)
            A: z = x;  // Output z depends on x in state A
            B: z = ~x; // Output z is inverted x in state B
            default: z = 0; // Default output
        endcase
    end

endmodule