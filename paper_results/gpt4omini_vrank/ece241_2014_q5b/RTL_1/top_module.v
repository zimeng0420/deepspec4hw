module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    parameter A = 2'b01, B = 2'b10;
    reg [1:0] state, next_state;

    // Asynchronous reset to state A
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
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
            default: next_state = A; // Default state
        endcase
    end

    // Output logic (Mealy)
    always @(state or x) begin
        case (state)
            A: z = x; // z=1 if x=1, z=0 if x=0
            B: z = ~x; // z=0 if x=1, z=1 if x=0
            default: z = 0; // Default output
        endcase
    end

endmodule