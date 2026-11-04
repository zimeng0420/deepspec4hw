module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    reg state, next_state;

    // State encoding
    localparam A = 1'b0, B = 1'b1;

    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                if (in == 0)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (in == 0)
                    next_state = A;
                else
                    next_state = B;
            end
            default: next_state = B; // Default state
        endcase
    end

    // State update and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= B; // Reset to state B
        end else begin
            state <= next_state; // Update state
        end
    end

    // Output logic based on current state
    always @(*) begin
        out = (state == B) ? 1'b1 : 1'b0; // Output logic
    end

endmodule