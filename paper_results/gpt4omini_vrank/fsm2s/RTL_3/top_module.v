module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);
    // State Encoding
    parameter OFF = 1'b0, ON = 1'b1;
    reg state, next_state;

    // State Transition Logic
    always @(*) begin
        case(state)
            OFF: begin
                if (j) 
                    next_state = ON;
                else 
                    next_state = OFF;
            end
            ON: begin
                if (k) 
                    next_state = OFF;
                else 
                    next_state = ON;
            end
            default: next_state = OFF; // Default state
        endcase
    end

    // State Update Logic
    always @(posedge clk) begin
        if (reset) 
            state <= OFF; // Reset to OFF state
        else 
            state <= next_state; // Update to next state
    end

    // Output Logic
    always @(state) begin
        case(state)
            OFF: out = 1'b0;
            ON: out = 1'b1;
            default: out = 1'b0; // Default output
        endcase
    end

endmodule