module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State Definitions
    parameter A = 2'b00; // Initial state
    parameter B = 2'b01; // After receiving '1'
    parameter C = 2'b10; // After receiving '10'

    // State Register
    reg [1:0] state;

    // Next State Logic
    reg [1:0] next_state;

    // Combinational Logic for next_state and z
    always_comb begin
        case (state)
            A: begin
                if (x)
                    next_state = B;
                else
                    next_state = A;
                z = 0;
            end
            B: begin
                if (x)
                    next_state = B;
                else
                    next_state = C;
                z = 0;
            end
            C: begin
                if (x) {
                    next_state = B;
                    z = 1;
                }
                else {
                    next_state = A;
                    z = 0;
                }
            end
            default: begin
                next_state = A;
                z = 0;
            end
        endcase
    end

    // State Update - Synchronous
    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= A;
        else
            state <= next_state;
    end

endmodule