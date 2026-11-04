module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State encoding
    parameter A = 1'b1;
    parameter B = 1'b0;

    reg current_state, next_state;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= B; // Reset state
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic to determine next state and output
    always @(*) begin
        case (current_state)
            B: begin
                out = 1'b1; // Output for state B
                if (in == 0)
                    next_state = A;
                else
                    next_state = B;
            end
            A: begin
                out = 1'b0; // Output for state A
                if (in == 0)
                    next_state = B;
                else
                    next_state = A;
            end
            default: begin
                out = 1'b1; // Default to state B output
                next_state = B;
            end
        endcase
    end

endmodule