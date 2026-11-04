module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // Define states
    parameter A = 2'b00; // Start/Initial state
    parameter B = 2'b01; // "1" detected
    parameter C = 2'b10; // "10" detected

    // State register
    reg [1:0] state;

    // Next state logic
    always_comb begin
        case (state)
            A: begin
                if (x)
                    state = B;
                else
                    state = A;
            end
            B: begin
                if (x)
                    state = B;
                else
                    state = C;
            end
            C: begin
                if (x)
                    state = B;
                else
                    state = A;
            end
        endcase
    end

    // Output logic
    always_comb begin
        z = 0;
        if (state == C && x)
            z = 1;
    end

    // State update (synchronous) and reset (asynchronous)
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= A;
        else
            state <= state;
    end

endmodule