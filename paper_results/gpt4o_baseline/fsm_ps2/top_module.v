module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output done
);

    reg [1:0] state, next_state; // States: 2 bits to track 3 states and reset
    reg done_reg;

    localparam IDLE = 2'd0,  // State: Waiting for in[3]=1
               BYTE2 = 2'd1, // State: Received first byte, waiting for second
               BYTE3 = 2'd2; // State: Received second byte, waiting for third

    always @(posedge clk) begin
        if (reset)
            state <= IDLE; // Reset state
        else
            state <= next_state; // State transition
    end

    always @(*) begin
        // Default outputs and next state
        done_reg = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                if (in[3]) // Check for in[3]=1
                    next_state = BYTE2;
            end

            BYTE2: begin
                next_state = BYTE3; // Transition to BYTE3
            end

            BYTE3: begin
                done_reg = 1'b1;    // Signal done
                next_state = IDLE; // Transition back to IDLE
            end
        endcase
    end

    assign done = done_reg; // Output the done signal

endmodule