module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output out
);

    // State encoding
    localparam OFF = 1'b0, ON = 1'b1;
    reg current_state, next_state;

    // Sequential block for state transition and synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= OFF;
        else
            current_state <= next_state;
    end

    // Combinational block for next-state logic
    always @(*) begin
        case (current_state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF; // safety to default state
        endcase
    end

    // Output logic
    assign out = current_state;

endmodule