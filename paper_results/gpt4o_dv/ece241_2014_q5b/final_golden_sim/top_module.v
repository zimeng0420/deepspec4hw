module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // One-hot encoded states
    reg [1:0] state, next_state;

    // State encoding
    localparam A = 2'b01;
    localparam B = 2'b10;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;           // Reset to state A
        else
            state <= next_state;  // Transition to the next state
    end

    // Combinational logic for next state and output
    always @(*) begin
        case (state)
            A: begin
                if (x) begin
                    next_state = B;
                    z = 1;
                end else begin
                    next_state = A;
                    z = 0;
                end
            end
            B: begin
                next_state = B;
                if (x)
                    z = 0;
                else
                    z = 1;
            end
            default: begin
                next_state = A;
                z = 0;
            end
        endcase
    end

endmodule