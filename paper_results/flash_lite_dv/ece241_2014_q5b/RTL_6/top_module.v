module top_module(
    input clk,
    input areset,
    input x,
    output z
);

    // State encoding using one-hot
    parameter A = 2'b01;
    parameter B = 2'b10;
    
    reg [1:0] state;
    reg [1:0] next_state;

    // Combinational logic for next state calculation
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
                next_state = A; // Default state (should not happen with one-hot)
        endcase
    end

    // Sequential logic for state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic
    assign z = (state == A) ? x : ~x;

endmodule