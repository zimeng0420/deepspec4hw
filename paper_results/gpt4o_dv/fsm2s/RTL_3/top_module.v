module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);
    // State encoding
    localparam OFF = 1'b0, ON = 1'b1;

    // State register
    reg current_state, next_state;

    // Synchronous state transition
    always @(posedge clk) begin
        if (reset)
            current_state <= OFF;
        else
            current_state <= next_state;
    end

    // Combinational logic for next state
    always @(*) begin
        case (current_state)
            OFF: next_state = (j == 1'b1) ? ON : OFF;
            ON: next_state = (k == 1'b1) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            OFF: out = 1'b0;
            ON: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule