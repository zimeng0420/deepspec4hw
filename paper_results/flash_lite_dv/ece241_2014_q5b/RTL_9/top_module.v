module top_module(
    input clk,
    input areset,
    input x,
    output z
);

    // State encoding using one-hot
    parameter A = 2'b01;
    parameter B = 2'b10;

    // State register
    reg [1:0] state;

    // Next state logic
    reg [1:0] next_state;

    // Combinational logic for next state
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
                next_state = A; // Default to A for safety
        endcase
    end

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        case (state)
            A:
                z = x;
            B:
                z = ~x;
            default:
                z = x; // Default output (shouldn't happen with proper design)
        endcase
    end

endmodule