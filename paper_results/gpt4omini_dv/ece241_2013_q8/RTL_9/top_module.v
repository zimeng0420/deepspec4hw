module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State Encoding
    parameter S0 = 2'b00, // Initial state
              S1 = 2'b01, // Detected '1'
              S2 = 2'b10; // Detected '10'

    reg [1:0] state, next_state;

    // Asynchronous reset
    always @(negedge aresetn) begin
        state <= S0;
        z <= 0;
    end

    // State transition logic
    always @(posedge clk) begin
        if (aresetn == 0)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state and output logic
    always @(*) begin
        case (state)
            S0: begin
                if (x) begin
                    next_state = S1; // Transition to S1
                    z = 0;           // z = 0
                end else begin
                    next_state = S0; // Remain in S0
                    z = 0;           // z = 0
                end
            end
            S1: begin
                if (!x) begin
                    next_state = S2; // Transition to S2
                    z = 0;           // z = 0
                end else begin
                    next_state = S1; // Stay in S1
                    z = 0;           // z = 0
                end
            end
            S2: begin
                if (x) begin
                    next_state = S1; // Back to S1 on '1'
                    z = 1;           // z = 1 (sequence '101' detected)
                end else begin
                    next_state = S0; // Transition back to S0
                    z = 0;           // z = 0
                end
            end
            default: begin
                next_state = S0; // Default state
                z = 0;           // Default output
            end
        endcase
    end

endmodule