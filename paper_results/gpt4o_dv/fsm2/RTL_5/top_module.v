module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output reg out
);
    // State Declaration
    reg state, next_state;
    localparam OFF = 1'b0, ON = 1'b1;

    // State Transition Logic (Combination Logic for Next State)
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF; // Transition based on 'j' input
            ON: next_state = k ? OFF : ON;  // Transition based on 'k' input
            default: next_state = OFF;      // Default State
        endcase
    end

    // State register and asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF; // Asynchronous reset to OFF state
        end else begin
            state <= next_state; // State update
        end
    end

    // Output Logic
    always @(*) begin
        case (state)
            OFF: out = 1'b0; // Output in OFF state
            ON: out = 1'b1;  // Output in ON state
            default: out = 1'b0;
        endcase
    end

endmodule