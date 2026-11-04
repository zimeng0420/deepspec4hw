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

    // Next state logic (combinational logic)
    always @(*) begin
        case (current_state)
            OFF: next_state = (j == 1) ? ON : OFF;
            ON:  next_state = (k == 1) ? OFF : ON;
            default: next_state = OFF;  // Default state is OFF for safety
        endcase
    end

    // State transition logic (sequential logic)
    always @(posedge clk) begin
        if (reset)
            current_state <= OFF;       // Synchronous reset to OFF
        else
            current_state <= next_state;
    end

    // Output logic
    assign out = (current_state == ON);

endmodule