module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);

    // State encoding
    parameter OFF = 1'b0, ON = 1'b1;
    reg state, next_state;

    // State transition logic
    always @ (posedge clk) begin
        if (reset) begin
            state <= OFF; // Active-high synchronous reset
        end else begin
            state <= next_state; // Update state
        end
    end

    // Next state logic
    always @ (*) begin
        case (state)
            OFF: begin
                if (j) next_state = ON; // Transition to ON if j=1
                else next_state = OFF;   // Stay in OFF if j=0
            end
            ON: begin
                if (k) next_state = OFF; // Transition to OFF if k=1
                else next_state = ON;    // Stay in ON if k=0
            end
            default: next_state = OFF; // Default state
        endcase
    end

    // Output logic
    assign out = (state == ON) ? 1'b1 : 1'b0; // Output based on current state

endmodule