module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // Define states
    parameter A = 2'b00; // Initial state
    parameter B = 2'b01; // After receiving '1'
    parameter C = 2'b10; // After receiving '10'

    // State register
    reg [1:0] state;

    // Next state logic
    always_comb begin
        case (state)
            A: begin
                if (x) state = B;
                else state = A;
                z = 0;
            end
            B: begin
                if (x) state = B;
                else state = C;
                z = 0;
            end
            C: begin
                if (x) begin
                    state = B;
                    z = 1;
                end
                else begin
                    state = A;
                    z = 0;
                end
            end
        endcase
    end

    // State update (synchronous) and reset (asynchronous)
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= A;
        else
            state <= state;
    end

endmodule