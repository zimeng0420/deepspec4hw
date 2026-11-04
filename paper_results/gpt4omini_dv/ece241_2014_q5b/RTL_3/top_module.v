module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);
    reg state_A; // One-hot encoding for State A
    reg state_B; // One-hot encoding for State B

    // Combinational logic for output z
    always @(*) begin
        if (state_A) begin
            z = (x) ? 1 : 0; // A --x=1--> B (z=1), A --x=0--> A (z=0)
        end else if (state_B) begin
            z = (x) ? 0 : 1; // B --x=1--> B (z=0), B --x=0--> B (z=1)
        end else begin
            z = 0; // Default case
        end
    end

    // Sequential logic for state transitions
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1; // Reset to State A
            state_B <= 1'b0;
        end else begin
            case ({state_A, state_B})
                2'b10: begin // State A
                    state_A <= (x) ? 1'b0 : 1'b1; // Transition to B if x=1
                    state_B <= (x) ? 1'b1 : 1'b0; // Remain in A if x=0
                end

                2'b01: begin // State B
                    state_A <= (x) ? 1'b0 : 1'b1; // Remain in B if x=0
                    state_B <= 1'b1; // Stay in B
                end

                default: begin
                    state_A <= 1'b1; // Default to State A
                    state_B <= 1'b0;
                end
            endcase
        end
    end
endmodule