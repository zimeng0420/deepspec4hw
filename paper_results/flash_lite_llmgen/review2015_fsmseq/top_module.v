module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State Definitions
    parameter IDLE  = 3'b000;
    parameter S1    = 3'b001;
    parameter S2    = 3'b010;
    parameter S3    = 3'b011;
    parameter FOUND = 3'b100;

    // State Register
    reg [2:0] state;
    reg [2:0] next_state;

    // Next State Logic
    always @(*) begin
        case (state)
            IDLE:  begin
                if (data)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1:    begin
                if (data)
                    next_state = S2;
                else
                    next_state = IDLE;
            end
            S2:    begin
                if (data)
                    next_state = S1;
                else
                    next_state = S3;
            end
            S3:    begin
                if (data)
                    next_state = FOUND;
                else
                    next_state = IDLE;
            end
            FOUND: begin
                next_state = FOUND; // Stay in FOUND state
            end
            default: next_state = IDLE; // Handle any unexpected states
        endcase
    end

    // State Update Logic (Synchronous)
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output Logic
    always @(*) begin
        if (state == FOUND)
            start_shifting = 1;
        else
            start_shifting = 0;
    end

endmodule