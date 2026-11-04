module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    // State Definition using one-hot encoding
    parameter A = 2'b01;
    parameter B = 2'b10;

    // State Register
    reg [1:0] state;

    // Next State Logic
    reg [1:0] next_state;

    // Combinational Logic for Next State
    always @(*) begin
        case (state)
            A: begin
                if (x)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B;
            end
            default:
                next_state = A; // Default to A (initial state)
        endcase
    end

    // State Update with Asynchronous Reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output Logic
    always @(*) begin
        case (state)
            A: z = x;
            B: z = ~x;
            default: z = x; // Default to x (in case of uninitialized state)
        endcase
    end

endmodule